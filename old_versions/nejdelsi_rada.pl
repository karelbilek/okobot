require "okobot.pl";

use strict;
use warnings;
use utf8;
use Encode;


my %rady;

my $o = new Okobot("statbot");

#for my $i (1..5350) {
for my $i (1..5350) {
	if (-e "okoun_databaze/cl_".$i) {
		my %cl = $o->get_info(id=>$i);
		my @all;
		{
			open my $inf, "<", "okoun_databaze/cl_".$i;
			
			my @r = <$inf>;
			my $l= join("", @r);
			
			close $inf;
			my $VAR1;
			eval $l;
			@all = @$VAR1;
		}
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
				$predchozi_author = $art->{author} || 0;
			}
		} 
	}
}

my @keys = sort {$rady{$b}->{delka} <=> $rady{$a}->{delka}} keys %rady;
open my $f, ">:utf8", "out.txt";
for (@keys[0..19]) {
	print $f '<a href="http://www.okoun.cz/boards/'.$rady{$_}->{klub}.'?contextId='.$_.'#article-'.$_.'">'.$rady{$_}->{author}.' v klubu '.decode_utf8($rady{$_}->{nice_klub}).' - '.$rady{$_}->{delka}."</a><br>\n";
}