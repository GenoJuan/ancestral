# This script has the purpouse to reproduce the pipeline for ancestral TBP sequence reconstruction.
# Developer: Juan A. Arias Del Angel (Universidad Nacional Autónoma de México)
# Supervisor and original idea: (Universidad Autónoma del Estado de Morelos)
# Contact: jariasdelangel@gmail.com
# Last modification: 05-Nov-2017

# General description: 

# Dependencies: 
# Perl v5.24.0
# Python v2.7.13 
# BLAST v2.6.0+

###########################################################################################################
##########################              Mac OS X Yosemite v.10.10.5              ##########################
###########################################################################################################

### The pipeline starts from a protein sequence collection retrieved from NCBI database. 
### All the sequences in the collection are retrieved under the key "TATA-box binding protein".

# 1.change_id_ancestral_TBP.pl: change the original header for a numeric header.
# Input:
# - TBP_sequences.fasta: a file containing a sequence collection annotated as "TATA-box binding protein".
# Output:
# - outfile.fasta: a file containing the same collection of sequences but with a modified header.
# - oufile.csv   : a tab-limited table containing in the first column the modified header and in
#                  the second coolumn the respective original header.

perl 1.change_id_ancestral_TBP.pl TBP_sequences.fasta

# makeblastdb
# Input:
# -in: a file containing the same collection of sequences but with a modified header.
# -dbtype: a character string specifing the type of sequence contained in -in argument.
# Output:
# *.pin, *.psq, *.phr: database generated files by BLAST to perform alignments. 
# '*' stands for the original name of -in.

makeblastdb -in outfile.fasta -dbtype prot

# blastp: perform protein sequence alignment.
# Input:
# -db: a character string specifying the database.
# -query: a character string specifying the query sequences.
# -out: a tab-limited table containing the results of sequence alignment.
# -outmft: a numeric value specifying the format of -out.
### - Column 1: query_sequence
### - Column 2: database_sequence
### - Column 3: identity porcentage
### - Column 4: alignment length
### - Column 5: number of mismatchs
### - Column 6: number of gaps
### - Column 7: start of the aligned region of query sequence
### - Column 8: end of the aligned region of query sequence
### - Column 9: start of the aligned region of sequence in the database
### - Column 10: end of the aligned region of sequence in the database
### - Column 11: alignment e-value
### - Column 12: alignment bitscore
# -evalue: a threshold value for the e-value alignment.
# Output:
# *.pin, *.psq, *.phr: database generated files by BLAST to perform alignments. 
# '*' stands for the original name of -in.

blastp -db outfile.fasta -query TBP_seed.fasta -out outfile_blast.out -outfmt 6 -evalue 1e-50

# Retain the information redarding to the header, start and end positions of the sequences signficatively aligned.

more outfile_blast.out | cut -f2,9,10 | sort  > outfile_filtered.csv

# For the retained sequences slice the sub-sequences aligned with the query.
# For those sequences aligned to two or more queries, select the minimal start position and the maximum end position.

python slice_filtered_sequences.py > outfile_sliced_filtered.fasta

# makeblastdb: create a BLAST database using the sliced filtered TBP sequences
# blastp: perform protein sequence alignment all-against-all.

makeblastdb -in outfile_sliced_filtered.fasta -dbtype prot
blastp -db outfile_sliced_filtered.fasta -query outfile_sliced_filtered.fasta -out outfile_blast.out -outfmt 6 -evalue 1e-50
