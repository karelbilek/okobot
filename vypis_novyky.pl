require "okobot.pl";

package main;
use strict;
use warnings;
use utf8;

my $o = new Okobot("bot_almighty");
my @novyky = $o->get_new_favourites();


my $file;
open $file, ">>:utf8", "vypis.txt" or die $!;

my %howmuch;

for my $name (@novyky) {
	my @articles = $o->new_articles($name);
	for my $article (@articles) {
		$howmuch{$article->{author}}->{$name}++ if ($article->{author});
	}
}


for my $author (keys %howmuch) {
	
	for my $club (keys %{$howmuch{$author}}) {
		my $pis = $author."\n".$club."\n".($howmuch{$author}->{$club})."\n";
		print $file $pis;
	}
}