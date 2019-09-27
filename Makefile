SHELL=/bin/bash
BIN=bin
DATA=data
RESULTS=results

# The default behavior is to run all computation on the directory data/symmetric_0.5
ifndef thresholds
	thresholds=$(shell echo "{`LANG=en_US seq -f "%g" -s, 0 0.5 2`,`LANG=en_US seq -f "%g" -s, 2 0.1 4`,Al,Not}")
endif

# infiles contains all .msl files in the in_dir directory
ifndef in_dirs
	in_dirs=$(shell ls -d $(DATA)/*)
endif

find_files=$(shell echo $(folder)/s{001..002}.align.1.msl)

infiles=$(foreach folder,$(in_dirs),$(find_files))

add_out=$(shell echo $(fname).entropy.trim$(thresholds))
trimfiles=$(foreach fname,$(infiles),$(add_out))

errfiles=$(addsuffix .tree.err,$(trimfiles))

make_res=$(shell echo $(RESULTS)/$(shell basename $(folder))/trim$(thresholds).res)
res_file=$(foreach folder,$(in_dirs),$(make_res))

trim_target := $(shell echo %.trim$(thresholds))


# typing: make       , runs the target all which depends on the err files, 
all: $(errfiles)
	cat $^	

test:
	@echo $(thresholds)
	@echo $(errfiles)

	#@echo $(in_dirs)
	#@echo $(infiles)
	#@echo $(res_file)


plot: summary
	R < bin/plot_output.R --no-save


summary: $(res_file)
	tar -cf results.tar results/
	@echo "Summary done"

%.res:
	$(eval current_exp=$(shell basename $(shell dirname $@)))
	$(eval current_th=$(shell echo $@ | sed -e 's/^.*trim//g' -e 's/.res//g'))
	mkdir -p $(shell dirname $@)
	cat $(DATA)/$(current_exp)/*.trim$(current_th).tree.err > $@

# This target matches the pattern of the err file names.
# To be able to compute an errfile, we need the infered tree file
%.err: $(BIN)/compute_tree_diff.py %
	$(eval current_folder=$(shell basename $(shell dirname $@)))
	$(eval ref_tree=$(DATA)/$(current_folder)/$(current_folder).tree)
	python $^ $(ref_tree) > $@


# This target matches the pattern of the files containing infered tree.
# To be able to infer a tree, we need the trimmed alignement to be computed.
%.tree: $(BIN)/tree_infer.py %
	bin/FastTree -quiet < $* > $@

%.entropy: $(BIN)/calculate_entropy.py %
	python $^ > $@




%.trimNot: %
	ln -s $(shell echo `basename $* | sed 's/.entropy//g'`) $*.trimNot

%.trimAl: %
	bin/trimal -in $(shell echo $* | sed 's/.entropy//g') -automated1 -fasta -out $@

# Has to be put below the two previous one so that the trimAl and trimNot targets are ignored in Makefile_trim
include Makefile_trim

# This target matches the pattern of the files containing the trimmed alignement.
# To be able to compute a trimmed alignement we need the original .msl file and the value of the threshold.
Makefile_trim: FORCE
	rm -f Makefile_trim;\
	for t in $(shell echo $(thresholds)); do\
		echo -e "%.trim$$t: $(BIN)/compute_trim.py %\n\tpython $$""< --threshold $$t $$""* > $$""@\n" >> Makefile_trim;\
	done;\
	
FORCE:


clean: clean-res clean-err clean-tree clean-trim clean-entropy

clean-res:
	rm -f $(RESULTS)/**/*.res
clean-err:
	rm -f $(DATA)/**/*.err

clean-tree:
	rm -f $(DATA)/**/*trim*.tree

clean-trim:
	rm -f $(DATA)/**/*.trim*
	rm -f Makefile_trim

clean-entropy:
	rm -f $(DATA)/**/*.entropy*


# Avoid deleting intermediate files when the final .err files is computed.
.SECONDARY:


# Avoid deleting intermediate files in case of interruption or error
.PRECIOUS:

