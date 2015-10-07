#!/usr/bin/perl

$path=$ENV{"PATH"};

@path = split(":", $path);

foreach $i (@ARGV) {
    @path = grep($_ ne $i, @path);
}


$" = " ";
print "PATH=" . join(":",@path) . "\n";
