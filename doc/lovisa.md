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

Script: `applied-bioinfo-project/bin/compute_trim.py`

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
  
## 2019-09-10  
**Group meeting**  
Met up with the group to discuss project progress so far and how to proceed.    
  
  
## 2019-09-14  
**12:00 – Make R script for plotting output**  
I wrote an R script, "plot_output.R", for reading all .res files and plotting the trimming threshold vs the symmetric distance. 
The script uses the information given in the folder name (e.g. "symmetric_0.5") to determine the tree structure and the mutation frequency, 
and it takes the trimming threshold from the file name (e.g. "trim0.5.res"). 
The median and standard error of the symmetric distances is calculated from each file before plotting the data. 
The output plot is saved as a png called "results.png" in the results directory.  
  
The script currently ignores "trim0.res" files, since they are empty at the moment. This should be fixed when we have fixed the content of those files, since the trimming with thr=0 (i.e. no trimming) can be regarded as the baseline we want to compare against.  
  
I decided to write it in R instead of python since that is the language I am currently more used to when generating plots. 
  
  
**16:00 – Test run the plot script from command line**

To run the plot script, type the following in the command line:
  
```bash
$ R < bin/plot_output.R --no-save
```
  
Dependent packages should hopefully be automatically installed if required when running the script.
  
  
## 2019-09-19  
**Group meeting**  
Met up with the group to discuss project progress so far and how to proceed.  
 
  
## 2019-09-26  
**Write on project report**   
Added text for method section about MSA Entropy Trimming and made a simple figure illustrating an example of how the trimming was performed.  
  
  
## 2019-09-27  
**09:45 – Work on plot script**  
Updated plot_output.R script so that it also writes the summarized result data as a tsv file alongside the result plot.  
  
This table can then be used as input for another plot script where we compare the TrimAl method with our best trimming results.  
  
Made a R script, plot_comparison.R, for collecting information about the RF distances at the different mutation rates for each of the methods (MET, trimAl, and no trimming). 
For MET, the threshold (<4) giving the lowest RF difference was selected for comparison, while the 'no trimming' data was picked from the trim4.res result file.  
  
trimAl was run using part of our pipeline, and the results will be strored in files called trim10.res (?). 
Since the files were not available at the time of writing this script, I've collected the trim.0.5.res and preliminary called them trimAl results. 
This needs to be changed before plotting the final results! (TODO)  
  

## 2019-09-29  
**Update and run plot scripts for new results**  
Updated the plot_output.R and plot_comparison.R scripts to work with the new .res file names for our MET method, trimAl (trimAl.res), and no trimming (trimNo).  
  
New plot png files were generated and tsv tables used for the plots were saved as separate objects.  
  
