"""
Calculate Shannon entropy using the math and Counter modules.
Script obtained from https://rosettacode.org/wiki/Entropy#Python
and is designed for Python ≥ 2.7.

Counter creates a dictionary with each letter in given string and the frequency count for that letter within the string.

L.F., 190731
"""

import math
from collections import Counter


def entropy(s):
    p, lns = Counter(s), float(len(s))
    return -sum(count/lns * math.log(count/lns, 2) for count in p.values())