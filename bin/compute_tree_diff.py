#!./pyenv/bin/python
import sys
import os

import dendropy
from dendropy.calculate.treecompare import \
	weighted_robinson_foulds_distance, euclidean_distance


if __name__ == "__main__":
	usage = "Compute Robinson-Foulds distance between two trees in NEWICK format.\n\
		Usage: python bin/compute_tree_dist.sh [First tree in newick format] [Second tree in newick format]\n\
		Example: python bin/compute_tree_dist.sh 1.tree 2.tree"

	if len(sys.argv) != 3 or sys.argv[1] == "-h" or sys.argv[1] == "--help":
		print(usage, file=sys.stderr)
		sys.exit(1)

	# Parse arguments
	tree_files = [os.path.abspath(x) for x in sys.argv[1:]]
	
	# Read trees
	tns = dendropy.TaxonNamespace()
	trees = tuple([dendropy.Tree.get(path=x, schema="newick", taxon_namespace=tns)
				   for x in tree_files])

	# print(weighted_robinson_foulds_distance(*trees))
	print(euclidean_distance(*trees))

	sys.exit(0)
