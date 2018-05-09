#!/usr/bin/perl
# filemunge.pl # see Perl tutorial on page 113

use strict; use warnings;

open(IN, "<$ARGV[0]") or die "error reading $ARGV[0] for reading";
open(OUT1, ">$ARGV[0].out1") or die "error creating $ARGV[0].out1"; 
open(OUT2, ">$ARGV[0].out2") or die "error creating $ARGV[0].out2"; 


my $IN1_line;
my @IN1_array;
my $IN1_array;

my $newpos;
my @chrsplit;

#while (<IN>) 
while ($IN1_line = <IN>)
{
#	chomp;  # remove a \n from the end of a line if present. 
	chomp($IN1_line);
#	my $rev = reverse $_;
	my $rev = reverse $IN1_line;
	print OUT1 "$rev\n";

	@IN1_array = split("\t", $IN1_line);
	# print("The array format of each line: @IN1_array, \n");
 	# print("The second column:", $IN1_array[1], "\n");
	# print("The scond column +1 :", $IN1_array[1]+1, "\n");

	$newpos = $IN1_array[1]+1;

	@chrsplit = split("r", $IN1_array[0]);
	print("the chr1 splitted: ", @chrsplit, "\n");
	print("the chr1 splitted one by one:", $chrsplit[0], "  and  " , $chrsplit[1], "\n");

	print OUT2 "$IN1_array[0]\t$newpos\t $IN1_array[2] \t $IN1_array[3]\n";

}
close IN;
close OUT1;
close OUT2;
