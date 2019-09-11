SHELL=/bin/bash
BIN=bin
DATA=data
RESULTS=results

# The default behavior is to run all computation on the directory data/symmetric_0.5
ifndef thresholds
	thresholds={0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1}
endif

# infiles contains all .msl files in the in_dir directory
ifndef in_dirs
	in_dirs=$(shell ls -d $(DATA)/*)
endif


find_files=$(wildcard $(folder)/*.msl)

infiles=$(foreach folder,$(in_dirs),$(find_files))

add_out=$(shell echo $(fname).trim$(thresholds))
trimfiles=$(foreach fname,$(infiles),$(add_out))

errfiles=$(addsuffix .tree.err,$(trimfiles))

make_res=$(shell echo $(RESULTS)/$(folder)/trim$(thresholds).res)
res_file=$(foreach folder,$(shell basename $(in_dirs)),$(make_res))

trim_target := $(shell echo %.trim$(thresholds))


# typing: make       , runs the target all which depends on the err files, 
all: $(errfiles)
	cat $^	

test:
	@echo $(res_file)

summary: $(res_file)
	@echo "Summary done"

%.res:
	$(eval current_folder=$(shell dirname $@))
	$(eval current_th=$(shell echo $@ | sed -e 's/^.*trim//g' -e 's/.res//g'))
	cat $(current_folder)/*.trim$(current_th).tree.err > $@

# This target matches the pattern of the err file names.
# To be able to compute an errfile, we need the infered tree file
%.err: $(BIN)/compute_tree_diff.py %
	$(eval current_folder=$(shell basename $(shell dirname $@)))
	$(eval ref_tree=$(DATA)/$(current_folder)/$(current_folder).tree)
	python $^ $(ref_tree) > $@


# This target matches the pattern of the files containing infered tree.
# To be able to infer a tree, we need the trimmed alignement to be computed.
%.tree: $(BIN)/tree_infer.py %
	python $^ > $@


# This target matches the pattern of the files containing the trimmed alignement.
# To be able to compute a trimmed alignement we need the original .msl file and the value of the threshold.

%.trim0: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim0.1: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim0.2: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim0.3: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim0.4: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim0.5: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim0.6: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim0.7: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim0.8: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim0.9: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@

%.trim1: $(BIN)/compute_trim.py % FORCE
	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
	python $< --threshold $(th) $* > $@



FORCE:
	
#%.trim0.75: $(BIN)/compute_trim.py
#	$(eval th=$(shell echo $@ | sed 's/^.*trim//g'))
#	python $^ --threshold $(th) $* > $@



# Avoid deleting intermediate files when the final .err files is computed.
.SECONDARY:


# Avoid deleting intermediate files in case of interruption or error
.PRECIOUS:

