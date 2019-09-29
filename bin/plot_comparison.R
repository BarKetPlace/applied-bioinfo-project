#' PLOT TRIMAL RESULTS COMPARED TO OUR METHOD

#' Import required packages
for (pkg in c("tidyverse",
              "here")) {
  if (!require(pkg, character.only = T)) install.packages(pkg, repos = "http://cran.us.r-project.org")
  library(pkg, character.only = T)
}

#' Read in and format data for trimAl results
dir_res <- file.path(here::here(), "results")

res_data_fnames <- list.files(path = dir_res, pattern = 'trim[A-Z*]', full.names = T, recursive = T)  # TODO: set to look for 'trim0.res' for now <-  need to change to 'trim10.res' later when TrimAl data is in 
msa_groups <- unique(unlist(lapply(strsplit(res_data_fnames, "/" ), FUN = function(i) i[length(i)-1])))

res_df <- list()
for (group in msa_groups) {
  
  i = 1  
  for (fname in res_data_fnames) {
    res_info <- tail(unlist(strsplit(fname, split = "/")), n = 2)
    
    if (res_info[1] == group & i == 1) {
      df <- setNames(data.frame(read.table(fname)), nm = "error")
      df$msa_group <- group
      df$method <- as.character(gsub(".res", "", res_info[2]))
      res_df[[group]] <- df
    } else if (res_info[1] == group & i > 1) {
      df <- setNames(data.frame(read.table(fname)), nm = "error")
      df$msa_group <- group
      df$method <- as.character(gsub(".res", "", res_info[2]))
      res_df[[group]] <- rbind(res_df[[group]], df)
    }
    i = i+1
  }
  
}

#' Bind datasets (TrimAl & trimNot)
res_df_all <- bind_rows(res_df)
res_df_all$tree <- unlist( lapply(strsplit(x = res_df_all$msa_group, split = "_"), function(i) i[1]) )
res_df_all$mutation_rate <- unlist( lapply(strsplit(x = res_df_all$msa_group, split = "_"), function(i) i[2]) )

res_df_all[res_df_all$method == "trimNot", "method"] <- "No trimming"


#' Summarize statistics for each group (TrimAl & trimNot)
stats <- res_df_all
statsm <- reshape2::melt(stats, id.vars = c("msa_group", "method", "tree", "mutation_rate"))

sem <- function(x) sd(x)/sqrt(length(x))
statsm_summary <- statsm %>% 
  group_by(msa_group, method, tree, mutation_rate) %>%
  summarise(mean = mean(value), mean_se = sem(value))
statsm_summary$trim_thr <- NA
statsm_summary$mutation_rate <- as.numeric(statsm_summary$mutation_rate)



#' Read result.tsv data for our MSA Entropy Trimming method (MET)
met_result <- read_tsv(file = file.path(dir_res, "result.tsv"))

#' Identify best trimming thr for each case (msa_group) (MET)
met_summary <- met_result %>% 
  group_by(msa_group, tree, mutation_rate) %>%
  # filter(trim_thr != 4) %>%
  filter(mean == min(mean)) %>% 
  filter(mean_se == (min(mean_se))) %>%
  distinct(msa_group, .keep_all = TRUE)  # remove duplicates if some threshold produce the same result
met_summary$method <- "MET"

#' OLD: Identify best trimming thr for each case (msa_group) (MET) -- REPLACED BY 'trimNo.res' files
# notrim_summary <- met_result %>% 
#   group_by(msa_group, tree, mutation_rate) %>%
#   filter(trim_thr == 4) %>%
#   distinct(msa_group, .keep_all = TRUE)

# notrim_summary$method <- "No trimming"

#' Join the two summary tables:
all_summary <- rbind(statsm_summary, met_summary)

#' Plot output
p <- ggplot(all_summary, aes(x = mutation_rate, y = mean, ymin = mean - mean_se, ymax = mean + mean_se, 
                                color = method, shape = method)) +
  geom_line(stat = "identity", size = 1) +
  geom_point(stat = "identity", color = "grey30", size = 1) +
  geom_errorbar(width = 0, color = "grey30") +
  labs(title = "", 
       y = "Robinson-Foulds distance", x = "Mutation rate", 
       color ="", shape = "") +
  facet_wrap(~tree, scales="free_y") +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5),
        strip.text.x = element_text(size = 15),
        axis.title=element_text(size = 10),
        legend.text=element_text(size=12))

# Save plot
png(filename = file.path(dir_res, "result_comparison.png"), width = 2000, height = 1000, res = 300); p; dev.off()

#' Save output as table
write.table(x = all_summary, file = file.path(dir_res, "result_comparison.tsv"), quote = F, sep = "\t", row.names = F, col.names = T)

