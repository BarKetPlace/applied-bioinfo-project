#' PLOT OUTPUT RESULT

#' Import required packages
for (pkg in c("tidyverse",
              "here")) {
  if (!require(pkg, character.only = T)) install.packages(pkg, repos = "http://cran.us.r-project.org")
  library(pkg, character.only = T)
}

#' Read in and format data
dir_res <- file.path(here::here(), "results")
res_data_fnames <- list.files(path = dir_res, pattern = '.res', full.names = T, recursive = T)
msa_groups <- unique(unlist(lapply(strsplit(res_data_fnames, "/" ), FUN = function(i) i[length(i)-1])))

res_df <- list()
for (group in msa_groups) {
  
  i = 1  
  for (fname in res_data_fnames) {
    res_info <- tail(unlist(strsplit(fname, split = "/")), n = 2)
    
    if (res_info[1] == group & i == 1) {
      df <- setNames(data.frame(read.table(fname)), nm = "error")
      df$msa_group <- group
      df$trim_thr <- as.numeric(gsub("trim", "", gsub(".res", "", res_info[2])))
      res_df[[group]] <- df
    } else if (res_info[1] == group & i > 1) {
      df <- setNames(data.frame(read.table(fname)), nm = "error")
      df$msa_group <- group
      df$trim_thr <- as.numeric(gsub("trim", "", gsub(".res", "", res_info[2])))
      res_df[[group]] <- rbind(res_df[[group]], df)
    }
    i = i+1
  }
  
}

#' IF TESTING: Alter dummy data for group 1 and 2
# res_df[[msa_groups[1]]]$error <- res_df[[msa_groups[1]]]$error + sample(1:50, length(res_df[[msa_groups[1]]]$error), replace = TRUE)
# res_df[[msa_groups[2]]]$error <- res_df[[msa_groups[2]]]$error + sample(1:10, length(res_df[[msa_groups[2]]]$error), replace = TRUE)

#' Bind datasets
res_df_all <- bind_rows(res_df)
res_df_all$tree <- unlist( lapply(strsplit(x = res_df_all$msa_group, split = "_"), function(i) i[1]) )
res_df_all$mutation_rate <- unlist( lapply(strsplit(x = res_df_all$msa_group, split = "_"), function(i) i[2]) )

#' Summarize statistics for each group
stats <- res_df_all
statsm <- reshape2::melt(stats, id.vars = c("msa_group", "trim_thr", "tree", "mutation_rate"))

sem <- function(x) sd(x)/sqrt(length(x))
statsm_summary <- statsm %>% 
  group_by(msa_group, trim_thr, tree, mutation_rate) %>%
  summarise(mean = mean(value), mean_se = sem(value))

#' Plot
p <- ggplot(statsm_summary, aes(x = trim_thr, y = mean, ymin = mean - mean_se, ymax = mean + mean_se, 
                                color = mutation_rate, shape = mutation_rate)) +
  geom_line(stat = "identity", size = 1) +
  geom_point(stat = "identity", color = "grey30", size = 1) +
  geom_errorbar(width = 0, color = "grey30") +
  labs(title = "", 
       y = "Robinson-Foulds distance", x = "Trimming threshold (Shannon entropy)", 
       color ="Mutation rate", shape = "Mutation rate") +
  facet_wrap(~tree, scales="free_y") +
  theme_linedraw() +
  theme(plot.title = element_text(hjust = 0.5),
        strip.text.x = element_text(size = 15),
        axis.title=element_text(size = 10))

png(filename = file.path(dir_res, "result.png"), width = 2000, height = 1000, res = 300); p; dev.off()
