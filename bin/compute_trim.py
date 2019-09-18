"""
Script for parsing a .msl file, computing column-wise entropy, and trimming columns based on given entropy threshold.

L.F, 2019-07-31
TODO: make file executable as sh script
TODO: add more error and warning checks
"""

import argparse
import sys
import numpy as np
from Bio import SeqIO
import math
from collections import Counter


def parse_msl(file_path):
    # print("[1/3] Parsing msl file...", file=sys.stderr)
    all_seqs = []
    all_ids = []
    all_desc = []
    for seq_record in SeqIO.parse(file_path, 'fasta'):
        all_seqs.append(seq_record.seq)
        all_ids.append(seq_record.id)
        all_desc.append(seq_record.description)

    seq_matrix = np.array(all_seqs)
    return seq_matrix, all_ids, all_desc


def compute_entropy(input_matrix):
    """
    Compute Shannon entropy on each column of the input array.
    """
    # print("[2/3] Computing entropy...", file=sys.stderr)
    col_entropy = []
    for column in input_matrix.T:
        col_entropy.append(entropy(column))

    return col_entropy


def entropy(s):
    """
    Function for calculating Shannon entropy on given string.
    """
    p, lns = Counter(s), float(len(s))
    return -sum(count/lns * math.log(count/lns, 2) for count in p.values())


def trim_columns(input_matrix, entropy_list, threshold=0.5):
    """
    Trim columns from the msl matrix by providing a list of entropy values and specifying an entropy threshold
    to be used when selecting columns. I.e. only keep columns which entropy exceeds or equals the given threshold.
    """
    # print("[3/3] Trimming bases...", file=sys.stderr)
    if input_matrix.shape[1] == len(entropy_list):
        entropy_bool = [x <= threshold for x in entropy_list]
        trimmed_matrix = input_matrix[:, entropy_bool]
        return trimmed_matrix
    else:
        raise IndexError("Input matrix dimensions do not match that of input entropy list.")


def matrix_to_fasta(trimmed_matrix, all_desc):
    """
    Print trimmed matrix in fasta format
    """
    for i in range(len(all_desc)):
        print(">" + all_desc[i] + "\n" + ''.join(trimmed_matrix[i, :]))


def main(file_path, threshold):
    try:
        msl_matrix, msl_ids, msl_desc = parse_msl(file_path)

        msl_entropy = compute_entropy(msl_matrix)
        msl_trimmed = trim_columns(msl_matrix, msl_entropy, threshold=threshold)

        # print("[Trimming complete!]", file=sys.stderr)
        matrix_to_fasta(msl_trimmed, msl_desc)

    except Exception as e:
        print("An error occurred! " + str(e), file=sys.stderr)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Trim bases from raw .msl file based on Shannon entropy')
    parser.add_argument('file', type=str,
                        help="Path to input msl file")
    parser.add_argument('--threshold', type=float, default=0.5,
                        help="Shannon entropy threshold to be used when trimming (default is 0.5)")
    args = parser.parse_args()

    main(file_path=args.file,
         threshold=args.threshold)
