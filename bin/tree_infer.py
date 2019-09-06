
# Import modules
from Bio import Phylo
from Bio import AlignIO
from Bio.Phylo.TreeConstruction import DistanceCalculator
from Bio.Phylo.TreeConstruction import DistanceTreeConstructor

#Convert muscle format into phylip, which can be used in AlignIO.Read v=becuse i didn't manage to make it run with msl
#read the ,msl file, store the data in a list (this would probably be better in an array of sorts, i.e with pandas)
#write it into another file (temp.phy)
#I will add the arguments during the weekend
name = []
seqs = []
seq = ''
with open(file, 'r') as fasta:
    for line in fasta:
        if line[0] != '>':
            seq = seq + line[0:-1]
        if line[0] == '>':
            if seq != '':
                #print(seq)
                seqs.append(seq)
                seq = ''
            name.append(line[0:-1])
    seqs.append(seq)
#Note the length of the elements
seqnum = len(name)
seqlen = len(seqs[0])
#print (len(seqs))
#for i in range(len(seqs)):
#    print(len(seqs[i]))
fasta.close()
#for i in range(len(name)):
#    print(seqs[i])

#modify the name to be the same length for all - this will be redone to look better
for j in range(len(name)):
    name[j] = name[j].replace(' ', '_')
#    name[j] = name[j].replace('.', '')
    name[j] = name[j][:10]
#print(name)

#write out the lists in a new file
with open('temp.phy', 'w') as out:
    out.write(f'{seqnum}   {seqlen} \n')
    for i in range(len(name)):
        out.write(f'{name[i]} {seqs[i]} \n')
    out.close()

#read the sequences in phylip format and align
align = AlignIO.read('fastaphy.phy', 'phylip')

# Print the alignment
#print(align)

#calculate distance matrix
distm = DistanceCalculator('identity').get_distance(align)

#print out the distance Matrix
print('\nDistance Matrix')
print(distm)

#calculate the dendrogam using UPGMA algorithm
tree = DistanceTreeConstructor().upgma(distm)

#print out he dendrogram
print('\nDendrogram')
Phylo.draw_ascii(tree)
