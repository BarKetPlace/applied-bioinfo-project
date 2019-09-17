# 17-06 Antoine: takes care of skeleton
8:the flow has been decomposed as follows:
input alignement -> 
compute the entropy of each column -> 
trim the aligned sequences -> 
infer a tree from the trimmed sequences -> 
compute difference between infered and real tree ->
output error coefficient.

the input is an alignement file and the output a coefficient.
First shot at running make if the err associated with file `ali.msl` were to be computed with a threshold of 0.6:
```bash
$ make threshold=0.6 ali1.msl.trim.tree.err
echo bin/compute_trim.sh 0.6 ali1.msl > ali1.msl.trim
echo bin/compute_tree.sh ali1.msl.trim > ali1.msl.trim.tree
echo bin/compute_tree_diff.sh ali1.msl.trim.tree > ali1.msl.trim.tree.err
```

5pm:now I fixed a README so that everyone sees how to use the makefile



All good 

# 03-07 Antoine starts working on the tree distance computation
9.30am: Adds a virtual environment with dendropy package
```bash
source pyenv/bin/activate
```
10am: The tree files are in `newick` schema. In python: 
```python
import dendropy
tree=dendropy.Tree.get(path="symmetric_0.5.tree",schema="newick")
```
10.48am: Run a tree distance computation with
```bash
$ bin/compute_tree_diff.sh data/symmetric_0.5/symmetric_0.5.tree data/asymmetric_1.0/asymmetric_1.0.tree 
16
```

# 27-08
## Install python interpreter from requirement file
```bash
$ virtualenv -p python3 pyenv
$ source pyenv/bin/activate
$ pip install -r requirements.txt
```

## Fix the makefile to run python script directly.
```bash
$ make ali1.msl.trim threshold=0.6 -n
python bin/compute_trim.py --threshold 0.6 ali1.msl > ali1.msl.trim
```

# 10-09
## Fix the tree computation script
## Add the trimming threshold to the files name

```bash
$ make in_dirs=data/symmetric_0.5 data/symmetric_0.5/s001.align.1.msl.trim0.4.tree.err -n -B
python bin/compute_trim.py --threshold 0.4 data/symmetric_0.5/s001.align.1.msl > data/symmetric_0.5/s001.align.1.msl.trim0.4
python bin/tree_infer.py data/symmetric_0.5/s001.align.1.msl.trim0.4 > data/symmetric_0.5/s001.align.1.msl.trim0.4.tree
python bin/compute_tree_diff.py data/symmetric_0.5/s001.align.1.msl.trim0.4.tree data/symmetric_0.5/symmetric_0.5.tree > data/symmetric_0.5/s001.align.1.msl.trim0.4.tree.err
```

## todo: need to find a way to have the %.trim$(th) rules work properly
Right now all the rules have to be written manually

## 17-09:

- Alright the %.trim$(th) rules are now automatically generated and stored in Makefile\_trim.
- I changed the file listing command
```bash
find_files=$(shell echo $(folder)/s{001..010}.align.1.msl)
```
This runs much faster than a call to `ls` and allows flexibility on the choice of the number of files.

- Added the results ran on 10 .msl files in `results/`

