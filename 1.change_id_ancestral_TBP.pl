#!/usr/bin/perl;

use strict;

my $id = 1;

open(fasta, $ARGV[0]);

my $out1 = "outfile.csv";
my $out2 = "outfile.fasta";

open(my $outfile1, '>', $out1);
open(my $outfile2, '>', $out2);

while(<fasta>){
	if(/>(.+)/){
		print $outfile2 ">seq\_";
		print $outfile2 "0" x (5-length($id)) . $id;
		print $outfile2 "\n";

		print $outfile1 "$1\t";
		print $outfile1 "seq\_";
		print $outfile1 "0" x (5-length($id)) . $id;
		print $outfile1 "\n";

		$id++;
		
	} else {
		print $outfile2 $_;
	}
} close(fasta);

close $outfile1;
close $outfile2;


