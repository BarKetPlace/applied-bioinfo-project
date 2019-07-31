"""
Calculate Shannon entropy using the 'math' and 'Counter' python modules.
Script adapted from https://rosettacode.org/wiki/Entropy#Python

L.F., 190731
"""

import math
from collections import Counter


def entropy(s):
    p, lns = Counter(s), float(len(s))
    return -sum(count/lns * math.log(count/lns, 2) for count in p.values())
