require "okobot.pl";

use strict;
use warnings;
use utf8;
use Encode;


my $o = new Okobot("statbot");


my %rady;

#for my $i (1..5350) {
for my $i (1..5350) {
	my %cl = $o->get_info(id=>$i);
	if ($cl{read_allowed}) {
		my @all = $o->all_articles($cl{name}, undef, undef, 2009,0,0);
		my $predchozi_rada=0;
		my $predchozi_author=0;
		for my $art (@all) {
			if ($art->{author} and $art->{author} eq $predchozi_author) {
				if (!$rady{$predchozi_rada}){
					my %h = (delka=>2, klub=>$cl{name}, nice_klub=>$cl{nice_name}, author=>$art->{author});
					$rady{$predchozi_rada}=\%h;
				} else {
					$rady{$predchozi_rada}->{delka}++;
				}
			} else {
				$predchozi_rada = $art->{id};
				$predchozi_author = $art->{author};
			}
		} 
	}
}

my @keys = sort {$rady{$b}->{delka} <=> $rady{$a}->{delka}} keys %rady;
open my $f, ">:utf8", "out.txt";
for (@keys[0..1]) {
	print $f '<a href="http://www.okoun.cz/boards/'.$rady{$_}->{klub}.'?contextId='.$_.'#article-'.$_.'">'.$rady{$_}->{author}.' v klubu '.decode_utf8($rady{$_}->{nice_klub}).' - '.$rady{$_}->{delka}."</a><br>\n";
}