# 17-06 Antoine: takes care of skeleton
the flow has been decomposed as follows:
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

All good 
