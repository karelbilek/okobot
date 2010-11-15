require "okobot.pl";

use strict;
use warnings;
use utf8;
use Encode;
use Data::Dumper;

my $o = new Okobot("statbot");

open my $inf, "<", "posledni_klub";
my $club = <$inf>;
close $inf;
my $prvni = $club+1;
my $posledni = $club+11;
unlink "posledni_klub";
open my $outf, ">", "posledni_klub";
print $outf $posledni;
close $outf;


for my $i ($prvni..$posledni) {
	my %cl = $o->get_info(id=>$i);
	if ($cl{read_allowed}) {
		my @all = $o->all_articles($cl{name}, undef, undef, 2009,0,0);
		open my $outf2, ">", "okoun_databaze/cl_".$i;
		print $outf2 Dumper(\@all); 
		close $outf2;
	}
}