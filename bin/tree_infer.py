import argparse
import sys
from Bio import Phylo
from Bio import SeqIO
from Bio import AlignIO
from Bio.Phylo.TreeConstruction import DistanceCalculator
from Bio.Phylo.TreeConstruction import DistanceTreeConstructor

parser = argparse.ArgumentParser(description = 'Create a dendrogram from a trimmed .msl alignmnet')
parser.add_argument('file_pth', type = str, help = 'path to the .msl file')
args = parser.parse_args()
file = args.file_pth

SeqIO.convert(file,"fasta","temp.phy", "phylip")
# read the sequences in phylip format and align
align = AlignIO.read('temp.phy', 'phylip')

# Print the alignment
#print(align)

#calculate distance matrix
distm = DistanceCalculator('identity').get_distance(align)

#print out the distance Matrix
print('\nDistance Matrix',file=sys.stderr)
print(distm,file=sys.stderr)

#calculate the dendrogam using UPGMA algorithm
tree = DistanceTreeConstructor().upgma(distm)

#print out he dendrogram
print('\nDendrogram',file=sys.stderr)
Phylo.draw_ascii(tree)
