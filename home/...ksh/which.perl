#!/usr/bin/perl
#
# Perl program to simulate the Unix 'which' command, only faster
#
$keep_looking = 0;
if($ARGV[0] eq "-a")
   {
   shift;
   $keep_looking = 1;
   }
while(<stdin>)
   {
   ($nm, $val) = /^alias (\S+)='(.*)'$/;
   $ALIAS{$nm} = $val;
   }
foreach $command (@ARGV)
   {
   $found = 0;
   foreach $alias (keys(%ALIAS))
      {
      if($command eq $alias)
         {
         print "$command is an alias for '", $ALIAS{$command},"'\n";
         $found = 1;
         last;
         }
      }
   next if $found && !$keep_looking;
   foreach $directory (split(/:/, $ENV{"PATH"}))
      {
      if(-x $directory.'/'.$command && ! -d $directory.'/'.$command)
         {
         print "$directory/$command\n";
         $found = 1;
         last if ! $keep_looking;
         }
      }
   print "$command not found.\n" if ! $found;
   }

