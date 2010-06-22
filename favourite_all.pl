require "okobot.pl";

package main;
use strict;
use Time::localtime;


my $o = new Okobot("bot_almighty");
$o->login;

my $last;
for (reverse (0..6000)) {
	my %info = $o->get_info(id => $_);
	if ((!$info{booked}) and $info{read_allowed} and $info{topics}->[0]!=62) {
		
		my ($art) = $o->all_articles($info{name}, 1);
		if ($art->{year} > 2006) {
			$|=1;			
			print $_."\n";			
			$o->book($info{name});
			$last = $_;
		}
	}
}

print "posledni byl $last \n";