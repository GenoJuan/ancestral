#!/usr/bin/perl;

use strict;

my %seqs = {};
my $id = ();
my @ids;

open(fasta, $ARGV[0]);

while(<fasta>){
	if(/>(.+)/){
		$id = $1;
	}
	if(/^(\w+)/){
		$seqs{$id} .= $1;
	}
} close(fasta); 

open(filtered, $ARGV[1]);

while(<filtered>){
	if(/(.+)/){
		push(@ids, $1);
	}
} close(fasta);

foreach $id (@ids){
	print ">$id\n$seqs{$id}\n";
}
