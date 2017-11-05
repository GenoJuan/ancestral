# This script has the purpouse to reproduce the pipeline for ancestral TBP sequence reconstruction.
# Developer: Juan A. Arias Del Angel (Universidad Nacional Autónoma de México)
# Supervisor and original idea: (Universidad Autónoma del Estado de Morelos)
# Contact: jariasdelangel@gmail.com
# Last modification: 05-Nov-2017

# General description: 

# Dependencies: 
# perl v5.24.0
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

blastp -db outfile.fasta -query TBP_seed.fasta -out outfile_blast.out -outfmt 6 -evalue 1e-50

more outfile_blast.out | cut -f2 | sort | uniq > outfile_filtered.csv

# run R merging_results.r

perl /home/jarias/Escritorio/filter_database.pl outfile.fasta outfile_filtered.csv > tbp_filtered.fasta

makeblastdb -in tbp_filtered.fasta -dbtype prot

blastp -db tbp_filtered.fasta -query tbp_filtered.fasta -out outfile_blast.out -outfmt 6 -evalue 1e-50
