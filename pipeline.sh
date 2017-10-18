perl change_id_ancestral_TBP.pl sequence.fasta

makeblastdb -in outfile.fasta -dbtype prot

blastp -db outfile.fasta -query TBP_seed.fasta -out outfile_blast.out -outfmt 6 -evalue 1e-50

more outfile_blast.out | cut -f2 | sort | uniq > outfile_filtered.csv
