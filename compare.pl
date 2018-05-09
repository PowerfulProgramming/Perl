#!/usr/bin/perl
# aligner.pl

###########################################################
#  Script that compares output from SOAP2 and BWA results.
#  created by dtm Mar2018
###########################################################

use strict;
use warnings;

my $usage = q(
Input: 		aligner.pl <SOAP2 results> <BWA results>
Output lines:	1. Number of reads aligned in SOAP.
		2. Number of reads aligned in BWA.
		3. Number of reads that are both aligned and aligned to
		   same position.
		4. Number of reads that are both aligned but aligned to
		   different positions.
);

#globals
my $read_first; 
my $read_sec;
my %hashAlign2 = ();
my $align2Ref = \%hashAlign2;
my $align_len_1 = 0;
my $align_len_2 = 0;
my @split_first; 
my @split_sec;

my @id_split;
my $id1, my $id2, my $pos_first, my $pos_sec;
my $both = 0; my $same = 0; my $diff;
my $linesRead = 0;
my $percentComplete;

die($usage) if(@ARGV < 2);

#filehandles

open(ALIGN1, "$ARGV[0]") or die("Unable to open file $ARGV[0]\n");
open(ALIGN2, "$ARGV[1]") or die("Unable to open file $ARGV[1]\n");

print($usage."\nGetting file lengths and parsing data\n");

#get file lengths and place into a hash table

while($read_sec = <ALIGN2>) {
	chomp($read_sec);
	@split_sec = split(" ", $read_sec);
	if($split_sec[0] !~ m/@/ && int($split_sec[3]) != 0) {
		$hashAlign2{$split_sec[0]} = $read_sec;
		$align_len_2++;
	}
}

while($read_first = <ALIGN1>){
	$align_len_1++;
}
seek(ALIGN1, 0, 0);

print("Start comparing\n");

# process start

while($read_first = <ALIGN1>){
	$linesRead++;
	chomp($read_first);
	@split_first = split(" ", $read_first);
	@id_split = split(/\//, $split_first[0]);
	$id1 = $id_split[0];
	$pos_first = $split_first[7]."_".$split_first[8];
	if(exists($hashAlign2{$id1})){
		$both=$both+1;
		$read_sec = $$align2Ref{$id1};
		chomp($read_sec);
		@split_sec = split(" ", $read_sec);
		$pos_sec = $split_sec[2]."_".$split_sec[3];
		if ($pos_first eq $pos_sec){
			$same=$same+1;
		}
	}
	if($linesRead % 500000 == 0){
		$percentComplete = int($linesRead/$align_len_2 * 100);
		print("$percentComplete% complete\n");
	}
}

$diff=$both-$same;

print("\nCompleted!\n");
print("# $align_len_1 are aligned in SOAP.\n");
print("# $align_len_2 are aligned in BWA.\n");
print("# $same are aligned to same positions.\n");
print("# $diff are aligned to different positions.\n");

close ALIGN1;
close ALIGN2;





