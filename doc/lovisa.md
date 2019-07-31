# Lovisa's Notebook

## 2019-07-31 
**14:30 - Calculate Shannon entropy**  
Found a website where they presented different scripts to calculate Shannon entropy in different languages [link to site](https://rosettacode.org/wiki/Entropy#Python).  
The version that seemed most straight forward was this one. The function takes a string as input and returns the entropy value.

```python
import math
from collections import Counter

def entropy(s):
  p, lns = Counter(s), float(len(s))
  return -sum( count/lns * math.log(count/lns, 2) for count in p.values())
```

Made a python script containing the entropy function: `applied-bioinfo-project/bin/calculate_entropy.py`.

**16:00 - Trim msl using entropy threshold**
Made a first draft of a script to process a raw msl file (fasta format) and return trimmed sequences based on given entropy threshold.
Default threshold is set to 0.5.

The scripts trims the columns by first converting the input file into a numpy array, then computing Shannon entropy on each column, then removing the columns where the entropy is lower than the threshold, and lastly the trimmed sequences are printed in fasta format. The function for calculating the entropy is included in the scipt and is thus not reliant on any other scripts.

What still needs to be done:  
* Refine how output is presented (?) - currently printed in fasta format (same as input) to stdout  
* Add more and better input checks and error handling (or is this enough?)

I have tested the script on one msl file and it seems to be working, but please proof read and test it yourselves as well.

Script: `applied-bioinfo-project/bin/comute_trim.sh`

Modules needed to be installed prior to use:  
* numpy  
* biopython  

Example of usage with default threshold (0.5)
```bash
$ python3 bin/compute_trim.py data/symmetric_0.5/s001.align.1.msl
```

Example of usage with modified threshold
```bash
$ python3 bin/compute_trim.py data/symmetric_0.5/s001.align.1.msl --threshold 3
```
