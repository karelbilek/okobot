use strict;
use warnings;
use 5.010;

open my $inf, "<", "../www/countsfile.html";
my $r = join("", <$inf>);
close($inf);

while ($r=~/<td>\s*(.*)\s*<\/td>\s*<\/tr>/mg) {
	my $r = $1;
	$r=~s/\s//g;
	say $r;
}