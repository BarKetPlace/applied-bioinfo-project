import argparse
from Bio import AlignIO
from Bio.Phylo.TreeConstruction import DistanceCalculator,DistanceTreeConstructor

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create a dendrogram from a trimmed .msl alignmnet')
    parser.add_argument('file_path', type=str, help='path to the .msl file')
    args = parser.parse_args()
    fname = args.file_path

    #SeqIO.convert(fname, "fasta", "temp.phy", "phylip")
    # read the sequences in phylip format and align
    #align = AlignIO.read('temp.phy', 'phylip')

    align = AlignIO.read(fname, 'fasta')

    # Print the alignment
    # print(align)

    # calculate distance matrix
    distm = DistanceCalculator('identity').get_distance(align)

    # print out the distance Matrix
    # print('\nDistance Matrix', file=sys.stderr)
    # print(distm, file=sys.stderr)

    # calculate the Dendrogam using UPGMA algorithm
    tree = DistanceTreeConstructor().nj(distm)

    # print out he Dendrogram
    print(tree.format('newick'))
