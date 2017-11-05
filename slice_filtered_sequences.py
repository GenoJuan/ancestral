#!/usr/bin/python

from Bio import SeqIO

positions = {}

f = open("outfile_filtered.csv")

for line in f.readlines():
    data = line.split('\t')
    
    seq_id    = data[0]
    aln_start = int(data[1])
    aln_end   = int(data[2])
    
    try:
        aln_start = min(positions[seq_id][0], aln_start)
        aln_end   = max(positions[seq_id][1], aln_end)
        positions[seq_id] = [aln_start, aln_end]
    except KeyError:
        positions[seq_id] = [aln_start, aln_end]
    

f.close()

f = open("outfile.fasta")

sequences = SeqIO.parse(f, "fasta")

for record in sequences:
    try:
        seq = record.seq[positions[record.id][0] - 1: positions[record.id][1]]
        print ">" + record.id
        print seq
    except KeyError:
        pass
    

f.close()