#!/usr/bin/env perl
use strict; use warnings;

my $INDVFILE=0; #write to individual files
my $BIGFILE=1; #write to one large file

my $HOME="/home/wforan1/";
my $CSVPATH="$HOME/csv/";
my $PLSPATH="$HOME/Dropbox/School/2011_01-05Spring/686NeurComp/project/686Project/trials/";
my $ARFPATH="./";

my $SAMP=128;
my $BINDUR=15;
my $HEADER=q(
@attribute AF3 numeric
@attribute F7  numeric
@attribute F3  numeric
@attribute FC5 numeric
@attribute T7  numeric
@attribute P7  numeric
@attribute O1  numeric
@attribute O2  numeric
@attribute P8  numeric
@attribute T8  numeric
@attribute FC6 numeric
@attribute F4  numeric
@attribute F8  numeric
@attribute AF4 numeric
@attribute label {Sense,Antisense}
@data
);


open my $bigfile, ">${ARFPATH}total.arff" or die "cannot open total.arff\n" if $BIGFILE;
print $bigfile "\@relation 'all-csv ",time,"'\n",$HEADER if $BIGFILE;


my @csv=split /\n/, `ls $CSVPATH*csv`;
for my $f (@csv){
  my $trail=$f;
  $trail=~s/$CSVPATH(.*)\.csv$/$1/;

  my $pls=`ls $PLSPATH$trail*/*pls`;
  chomp($pls);

  next unless $pls;
  
  my $numbins=`wc -l $pls|cut -f1 -d' '`;
  my $csv_size=`wc -l $f|cut -f1 -d' '`;
  chomp $numbins; chomp $csv_size;

 ######
 #
 
 open my $csvfile, $f or warn "cannot open csvfile: $f\n";
 open my $plsfile, $pls or warn "cannot open plsfile: $pls\n";
 next unless ($csvfile && $plsfile );

 my $writefile;
 if($INDVFILE){
     open my $writefile, ">${ARFPATH}$trail.arff" or warn "cannot open arff: $trail.arff\n";
     next if !$writefile;
 }
 
 #print to file
 print $writefile "\@relation '$trail ",time, "'\n",$HEADER if $INDVFILE; 

 my $count=0;
 my $samplecount=0;
 my @sums=(0,0,0,0,0,0,0,0,0,0,0,0,0,0);
 <$csvfile>; #get first line out of the way
 while(<$csvfile>){
   $count++; 
   next if $count<  $csv_size - ($numbins*$SAMP*$BINDUR); #skip until we're reading bins; +1 for header
   next if !m/,\s*/;
   my @row=(split/,\s*/)[2,3,4,5,6,7,8,9,10,11,12,13,14,15];

   for (my $idx = 0; $idx < scalar(@sums); $idx++) {
   	$sums[$idx]+=$row[$idx];
   }
   $samplecount++;

   if($samplecount>=$SAMP*$BINDUR){ #next label
     
     my $label=<$plsfile>;
     print $writefile join(',', map({$_/$samplecount;} @sums),$label) if $INDVFILE;
     print $bigfile join(',', map({$_/$samplecount;} @sums),$label) if $BIGFILE;
     $samplecount=0;
   }
 }
}
