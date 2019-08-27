SHELL=/bin/bash
BIN=bin


# The default behavior is to run all computation on the directory data/symmetric_0.5
ifndef in_dir
	in_dir=data/symmetric_0.5
endif

ifndef threshold
	threshold=0.5
endif

# infiles contains all .msl files in the in_dir directory
infiles=$(shell echo $(in_dir)/*.msl)

# outfiles contains all .msl files with .trim.tree.err appended at the and of their name.
errfiles=$(addsuffix .trim.tree.err,$(infiles))


# typing: make       , runs the target all which depends on the err files, 
all: $(errfiles)
	cat $^	


# This target matches the pattern of the err file names I chose.
# To be able to compute an errfile, we need the infered tree file
%.trim.tree.err: $(BIN)/compute_tree_diff.sh %.trim.tree
	/bin/bash $^ > $@


# This target matches the pattern of the files containing infered tree.
# To be able to infer a tree, we need the trimmed alignement to be computed.
%.trim.tree: $(BIN)/compute_tree.sh %.trim
	/bin/bash $^ > $@


# This target matches the pattern of the files containing the trimmed alignement.
# To be able to compute a trimmed alignement we need the original .msl file and the value of the threshold.
%.trim: $(BIN)/compute_trim.py
	python $^ --threshold $(threshold) $* > $@


# Avoid deleting intermediate files when the final .err files is computed.
.SECONDARY:


# Avoid deleting intermediate files in case of interruption or error
.PRECIOUS:

