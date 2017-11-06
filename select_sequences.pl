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


my $cluster = 0;

open(ids, $ARGV[1]);

while(<ids>){
    if(/(.+) (seq_\d+)/){
        if($cluster != $1){
            print ">$2\n$seqs{$2}\n";
            $cluster = $1;
        }
    }
} close(ids)