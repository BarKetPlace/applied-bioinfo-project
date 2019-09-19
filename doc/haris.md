# September 9th: read the pros and cons of the software for trimming sequences
# Decided for trimAI as explained in the report and downloaded the package. 
# Explanation in the paper (doi:10.1093/bioinformatics/btp348)
# The installation failed and I was unable to fix it with the manual 
# installation in the command line.



# September 15th: installed trimAI via github
$ cd ~/Downloads/trimAl/source
$ make # Tried again with the manual approach from the trimAl website, but failed

# Changed to github where the authors provide an updated version of trimAl 
# - trimAl v1.4 (Beta version)
$ git clone https://github.com/scapella/trimal.git
$ cd ~/trimAl
$ cat README
$ cd ~/trimAl/source
$ make # The problem was in the makefile... 

# There are two of them and the first one ("makefile") should have been 
# replaced with makefile
$ mv makefile.MacOS makefile
$ make

# Moved the programs to my external source for scripts
$ mv trimal ~/scripts # A previously created external directory for scripts
$ mv readal ~/scripts

# Followed the tutorial provided by the authors on their website 
# to familiarise myself with the program
# (http://trimal.cgenomics.org/getting_started_with_trimal_v1.2), to test the program 
# on the several examples provided in the trimAl repository
# Downloaded the examples from the website since they were not available in the repository
# Some examples shown below:
$ cd Api0000038
$ trimal -in Api0000038.msl -sgt
$ trimal -in Api0000038.msl -sgc
$ trimal -in Api0000038.msl -sct # Not available. Old code. It's actually -sst
$ trimal -in Api0000038.msl -scc # Not available Old code. It's actually -ssc
$ trimal -in Api0000038.msl -sident

# How to plot similarity scores 
$ trimal -in Api0000038.msl -ssc > SimilarityColumns
$ gnuplot
	plot 'SimilarityColumns' u 1:2 w lp notitle
	set yrange [-0.05:1.05]
	set xrange [-1:1210]
	set xlabel 'Columns'
	set ylabel 'Residue Similarity Score'
	plot 'SimilarityColumns' u 1:2 w lp notitle
	exit
	
# How to plot gap scores 
$ trimal -in Api0000038.msl -sgt > gapsDistribution

$ gnuplot
set xlabel '% Alignment'
set ylabel 'Gaps Score'
plot 'gapsDistribution' u 7:4 w lp notitle
exit

# Use a user-defined threshold
$ trimal -in Api0000038.msl -gt 0.190 -htmlout ex01.html
$ trimal -in Api0000038.msl -gt 0.8 -htmlout ex02.html

# Use the automated method
$ trimal -compareset Api0000038.msl -automated1 -htmlout ex03.html

# Based on the results in the simulations run by the authors, the -automated1 algorhitm 
# performed the best when the outcome is the Roberston-Foulds' distance


# September 17th - cloned the github repository to my computer
git clone https://github.com/BarKetPlace/applied-bioinfo-project.git

# Installed virtual python environment
bash
$ virtualenv -p python3 pyenv
$ source pyenv/bin/activate
$ pip install -r requirements.txt 
$ pip install upgrade










