
# Readme file for the project.
I have no idea what we are supposed to do.
This is Jana adding characters into the README file
Team Three Plus One ftw.

# Project description
The goal is to compare a phylogenetic tree obtained after trimming aligned sequences with the true tree used to generate the sequences.
We decompose the task in 4 main operations:

- (Given) 16 aligned sequences obtained after 1 sequence has evolved along 16 species' path on the original phylogenetic tree.
- Aligned sequences trimming; using thresholding of columns entropy.
- Tree inference; using external software.
- Difference between original tree and infered tree; using some distance I forgot.

Three tasks are left for us to implement.
# Implementation

Each of the three tasks described above will be performed in a separate `bash` file.

Function | Script | Input | Output
:--------|:-------- |:---- |:-----
Aligned sequences trimming          | `bin/compute_trim.py` | \*.msl | \*.msl.trim
Tree inference                      | `bin/compute_tree.sh` | \*.msl.trim |\*.msl.trim.tree
dist(original tree, infered tree)   |  `bin/compute_diff.sh` | \*.msl.trim.tree | \*.msl.trim.tree.err


The names of the inputs and outputs are such that the content of a file is clear from its name.
For instance, a file with extension `.msl.trim.tree` contains a *tree* computed from *trimmed* aligned *msl* sequences.
All shell scripts in `bin/` have as input a file matching one of the pattern in the nomenclature.
The scripts write to `stdout` and the Makefile takes care of writing the output to the corresponding file.

The advantage of saving to files is that we will not need to reproduce intermediate files all the time.
The downside is that it might slow down the program with lots of read/write.

## Install
We need `bash`, `make`, a `python3` interpeter and `virtualenv` for the project. (Anyone using Windows ?)
```bash
$ make -v
GNU Make 4.1
...
$ bash --version
GNU bash, version 4.4.19(1)-release (x86_64-pc-linux-gnu)
...
$ python3 --version
Python 3.6.8
$ virtualenv --version
15.1.0 
```
## Python virtual environment 
Virtual environments are useful to create a standalone python environment.
Once activated, the python interpreter can only use packages installed within the virtual environment.

Go to the project root folder and run the following command:
```bash
$ virtualenv -p python3 pyenv
```

A folder containing a raw python3 interpreter has been created in `pyenv/`.
Activate the environment and install the necessary package.
```bash
$ source pyenv/bin/activate
$ pip install -r requirements.txt
```

To come back to the default system python interpreter run:
```bash
$ deactivate
```

When we run our code, we should make sure that the virtual environment is activated.

## Example run
To see the different steps to be executed with threshold 0.5 on a dummy input file `ali1.msl`, run:

```
$ make threshold=0.5 ali1.msl.trim.tree.err -n
python bin/compute_trim.py --threshold 0.5 ali1.msl > ali1.msl.trim
/bin/bash bin/compute_tree.sh ali1.msl.trim > ali1.msl.trim.tree
/bin/bash bin/compute_tree_diff.sh ali1.msl.trim.tree > ali1.msl.trim.tree.err
```

Above we ask to create a dummy target `ali1.msl.trim.tree.err`, with threshold=0.5 on the trimming part.
The Makefile is written so that `make` figures out that to create `ali1.msl.trim.tree.err`, it has to create all intermediate files first.

Note 1: `make -n` does not execute anything and only prints what would have been executed had `-n` not been written.

## Complete run

To see what would be executed if the algorihm were to be run on an entire folder, run:
```
$ make in_dir=data/symmetric_0.5 -n | head -n 6
python bin/compute_trim.py --threshold 0.5 data/symmetric_0.5/s001.align.1.msl > data/symmetric_0.5/s001.align.1.msl.trim
/bin/bash bin/compute_tree.sh data/symmetric_0.5/s001.align.1.msl.trim > data/symmetric_0.5/s001.align.1.msl.trim.tree
/bin/bash bin/compute_tree_diff.sh data/symmetric_0.5/s001.align.1.msl.trim.tree > data/symmetric_0.5/s001.align.1.msl.trim.tree.err
python bin/compute_trim.py --threshold 0.5 data/symmetric_0.5/s002.align.1.msl > data/symmetric_0.5/s002.align.1.msl.trim
/bin/bash bin/compute_tree.sh data/symmetric_0.5/s002.align.1.msl.trim > data/symmetric_0.5/s002.align.1.msl.trim.tree
/bin/bash bin/compute_tree_diff.sh data/symmetric_0.5/s002.align.1.msl.trim.tree > data/symmetric_0.5/s002.align.1.msl.trim.tree.err
...
```
Here, `make` automatically fetches the `.msl` files in the specified folder and performs the three operations (trimming, tree computation and tree difference) on each file automatically.

Note 1: We can parallelize the computation using `make -j 2 ...` instead.
