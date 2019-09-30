
# Readme file for the project.
I have no idea what we are supposed to do.
This is Jana adding characters into the README file
Team Three Plus One ftw.

# Project description
The goal is to compare a phylogenetic tree obtained after trimming aligned sequences with the true tree used to generate the sequences.
We decompose the task in 5 main operations:

- (Given) 16 aligned sequences obtained after 1 sequence has evolved along 16 species' path on the original phylogenetic tree.
- Compute the Shannon entropy of each column.
- Aligned sequences trimming; using thresholding of columns entropy.
- Tree inference; using external software.
- Difference between original tree and infered tree; using some distance I forgot.

Four tasks are left for us to implement.
# Implementation

Each of the four tasks described above will be performed in a separate `bash` file.

Function | Script | Input | Output
:--------|:-------- |:---- |:-----
Compute the Shannon entropy	    | `bin/compute_entropy.py` | \*.msl| \*.msl.entropy
Aligned sequences trimming          | `bin/compute_trim.py` | \*.msl | \*.msl.entropy.trim<threshold>
Tree inference                      | `bin/tree_infer.py` | \*.msl.trim |\*.msl.entropy.trim<threshold>.tree
dist(original tree, infered tree)   |  `bin/compute_diff.sh` | \*.msl.trim.tree | \*.msl.entropy.trim<threshold>.tree.err


The names of the inputs and outputs are such that the content of a file is clear from its name.
For instance, a file with extension `.msl.entropy.trim0.5.tree` contains a *tree* computed from *trimmed* aligned *msl* sequences.
All scripts in `bin/` have as input a file matching one of the pattern in the nomenclature.
The scripts write to `stdout` and the Makefile takes care of writing the output to the corresponding file.

The advantage of saving to files is that we will not need to reproduce intermediate files all the time.
The downside is that it might slow down the program with lots of read/write.

## Install
```bash
$ git clone https://github.com/barketplace/applied-bioinfo-project.git
$ cd applied-bioinfo-project
```

We have added `trimal` and `fasttree` in `src`. If the binaries do not correspond to your architecture, you can download and install the tool.
```bash
$ cd src
$ git clone https://github.com/scapella/trimal
$ cd trimal
$ make
```
Then create a symlink from our `bin/`
```bash
$ cd ../../bin
$ ln -s ../src/trimal/source/trimal 
```

The FastTree executable can be placed directly into our `bin/`, see [here](http://www.microbesonline.org/fasttree/#Install) for details.

### Dependencies
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

Make sure that the virtual environment is activated.

## Example run
To see the different steps to be executed with threshold 0.5 on an input file, run:

```bash
$ make thresholds=0.5 data/symmetric_0.5/s001.align.1.msl.entropy.trim0.5.tree.err -n
Makefile:73: Makefile_trim: No such file or directory
python bin/calculate_entropy.py data/symmetric_0.5/s001.align.1.msl > data/symmetric_0.5/s001.align.1.msl.entropy
python bin/compute_trim.py --threshold 0.5 data/symmetric_0.5/s001.align.1.msl.entropy > data/symmetric_0.5/s001.align.1.msl.entropy.trim0.5
python bin/tree_infer.py data/symmetric_0.5/s001.align.1.msl.entropy.trim0.5 > data/symmetric_0.5/s001.align.1.msl.entropy.trim0.5.tree
python bin/compute_tree_diff.py data/symmetric_0.5/s001.align.1.msl.entropy.trim0.5.tree data/symmetric_0.5/symmetric_0.5.tree > data/symmetric_0.5/s001.align.1.msl.entropy.trim0.5.tree.err
```

- You can ignore 'Makefile:73: Makefile_trim: No such file or directory' as the file gets created automatically.

- The Makefile is written so that `make` figures out that to create `ali1.msl.trim.tree.err`, it has to create all intermediate files first.

Note 1: `make -n` does not execute any of the processing steps and only prints what would have been executed had `-n` not been written.

## Complete run

To see what would be executed if the algorihm were to be run on an entire folder, run:
```bash
python bin/calculate_entropy.py data/asymmetric_0.5/s001.align.1.msl > data/asymmetric_0.5/s001.align.1.msl.entropy
python bin/compute_trim.py --threshold 0.5 data/asymmetric_0.5/s001.align.1.msl.entropy > data/asymmetric_0.5/s001.align.1.msl.entropy.trim0.5
python bin/tree_infer.py data/asymmetric_0.5/s001.align.1.msl.entropy.trim0.5 > data/asymmetric_0.5/s001.align.1.msl.entropy.trim0.5.tree
python bin/compute_tree_diff.py data/asymmetric_0.5/s001.align.1.msl.entropy.trim0.5.tree data/asymmetric_0.5/asymmetric_0.5.tree > data/asymmetric_0.5/s001.align.1.msl.entropy.trim0.5.tree.err
python bin/calculate_entropy.py data/asymmetric_0.5/s002.align.1.msl > data/asymmetric_0.5/s002.align.1.msl.entropy
python bin/compute_trim.py --threshold 0.5 data/asymmetric_0.5/s002.align.1.msl.entropy > data/asymmetric_0.5/s002.align.1.msl.entropy.trim0.5
...
```
Here, `make` automatically fetches the `.msl` files in the specified folder and performs the four operations (entropy computation,trimming, tree computation and tree difference) on each file automatically.

Note 1: We can parallelize the computation using `make -j 2 ...` instead.

## Reproduce our plots
```bash
$ make nlim=030 -j 10 -s
$ make summary
$ make plot
```

- The result plot is in `results/result.png`.

- Al the Robinson-Foulds results are `ls results/**/*.res`

- The `results` folder is archived into `results.tar`

