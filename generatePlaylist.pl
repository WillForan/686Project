#!/usr/bin/env perl
use warnings; use strict;

my $CLIPSIZE=15;
$CLIPSIZE=$ARGV[0] if($ARGV[0]);

my %clips;
my %clips_totaltimes;

#build "database" of clips
for my $clip (split/\n/,`ls *ense*.mp3`){
#for my $clip (split/\n/,`ls *ense{BLwordSalad,MontyPythonNews,freedomReligion,NewsAljazzera}.mp3`){
    #get clip length
    my $length=`mp3info -p "%S" $clip`;

    #store total time
    $clips_totaltimes{$clip} = $length;

    #store start time for clips
    for (my $t = 0; $t < int($length/$CLIPSIZE); $t++) {
    	push(@{$clips{$clip}},$t*$CLIPSIZE);
    }
}

#intialize total time
my $totaltime=0;

#while there are still clips (and clip times) to print
while(scalar keys %clips){

  #get clip
  my $c_idx=int rand keys %clips;
  my $c=(keys %clips)[$c_idx];
  my @t=@{$clips{$c}};

  #get clip start
  my $idx=int(rand $#t);


  #get clip end
  my $clip_length=$CLIPSIZE;
  #if(int($clips_totaltimes{$c}/$CLIPSIZE)-1==$t[$idx]/$CLIPSIZE) {
  #  $clip_length+=$clips_totaltimes{$c}%$CLIPSIZE;
  # }

  #print the time
  print "#$c_idx $idx $totaltime - ";
  $totaltime+=$clip_length;
  print "$totaltime\n";

  #print play command
  #print "mplayer $c -ss $t[$idx] -endpos ", $clip_length,"\n";
  #print "ffplay -ss $t[$idx] -t $clip_length -autoexit -nodisp $c \n";
  print "ffmpeg -ss $t[$idx] -t $clip_length  -i $c  playlist/tmp/$totaltime-$c.mp3\n";
  
  #remove time
  splice(@{$clips{$c}},$idx,1);

  #remove clip
  if(@{$clips{$c}}==0) {
      delete $clips{$c};
  }

 last if $totaltime > 300;
}
