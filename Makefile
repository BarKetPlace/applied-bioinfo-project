SHELL=/bin/bash
BIN=bin
DATA=data

# The default behavior is to run all computation on the directory data/symmetric_0.5
ifndef thresholds
	thresholds={0.25,0.5,0.75}
endif

# infiles contains all .msl files in the in_dir directory
ifndef in_dirs
	in_dirs=$(shell ls -d $(DATA)/*)
endif


find_files=$(wildcard $(folder)/*.msl)

infiles=$(foreach folder,$(in_dirs),$(find_files))

add_out=$(shell echo $(fname).trim$(thresholds).tree.err)
trimfiles=$(foreach fname,$(infiles),$(add_out))

errfiles=$(addsuffix .tree.err,$(trimfiles))


trim_target := $(shell echo %.trim$(thresholds))


test:
	@echo $(trimfiles)

# typing: make       , runs the target all which depends on the err files, 
all: $(errfiles)
	cat $^	


# This target matches the pattern of the err file names.
# To be able to compute an errfile, we need the infered tree file
%.err: $(BIN)/compute_tree_diff.sh %
	/bin/bash $^ > $@


# This target matches the pattern of the files containing infered tree.
# To be able to infer a tree, we need the trimmed alignement to be computed.
%.tree: $(BIN)/compute_tree.sh %
	/bin/bash $^ > $@


# This target matches the pattern of the files containing the trimmed alignement.
# To be able to compute a trimmed alignement we need the original .msl file and the value of the threshold.
$(trim_target): $(BIN)/compute_trim.py
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $^ --threshold $(th) $* > $@


# Avoid deleting intermediate files when the final .err files is computed.
.SECONDARY:


# Avoid deleting intermediate files in case of interruption or error
.PRECIOUS:

