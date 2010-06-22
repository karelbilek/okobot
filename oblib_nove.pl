require "okobot.pl";

package main;
use utf8;
use strict;
use Time::localtime;


my $o = new Okobot("bot_almighty");

open my $file, "<", "posledni";
my $posledni = <$file>;
close $file;

unlink "nove_kluby";
open my $nove_kluby, ">:utf8", "nove_kluby";

my $last;
for (($posledni+1)..($posledni+100)) {
	my %info = $o->get_info(id => $_);
	if ((!$info{booked}) and $info{read_allowed}) {
		
		my ($art) = $o->all_articles($info{name}, 1);
		if ($art->{year} > 2006) {
			$|=1;			
			print $_."\n";			
			$o->book($info{name});
			$last = $_;
			print $nove_kluby $_."\n".$info{nice_name}."\n";
			
		}
	}
}

close $nove_kluby;


open my $file, ">", "novy_posledni";
print $file $last;