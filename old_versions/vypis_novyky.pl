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

#extra ty, co se objevily v posledni dobe
my $f;
open  $f, "<", "posledni";
my $novy_first = <$f>;
close $f;

open $f, "<", "novy_posledni";
my $novy_last = <$f>;
close $f;
for my $id ($novy_first .. $novy_last) {
	print $id."\n";
	my %info = $o->get_info(id => $id);
	if ($info{read_allowed}) {
		my @articles = $o->all_articles($info{name});
		for my $article (@articles) {
			$howmuch{$article->{author}}->{$info{name}}++ if ($article->{author});
		}
	}
}

for my $author (keys %howmuch) {
	
	for my $club (keys %{$howmuch{$author}}) {
		my $pis = $author."\n".$club."\n".($howmuch{$author}->{$club})."\n";
		print $file $pis;
	}
}