#!/usr/bin/perl -s
#
# Print the PATH environment variable in an easy to read format
#
# Author: chk
#
$verbose = 1 if ($v || $d);
$debug = 1 if ($d);

split(/:/,$ENV{"PATH"});

$i = 0;
foreach $_ (split(/[:\\\n]/,$ENV{"PATH"})) {
	if (length($_) > 0) {
		if ($verbose) {
			printf("%2d %s\n", $i++, $_);
		}
		else {
			print "$_\n";
		}
	}
}
