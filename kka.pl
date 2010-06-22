require "okobot.pl";

package main;
use strict;

my $o = new Okobot("running");
$o->login;
my @articles = $o->all_articles("komentare_k_aktualitam", 3000);
my %letters;
my %articles;
for (@articles) {
	my $body =$_->{body};
	$body =~ s/<[^>]*>//g;
	$body =~ s/\s//g;
	$letters{$_->{author}}+=length($body);
	$articles{$_->{author}}++;
}

print "seřazeno dle počtu příspěvků\n--\n";
print $_." ".($articles{$_})."\n" for (sort {($articles{$b})<=>($articles{$a})} keys %articles);

print "\n\n\n=======\nseřazeno dle písmen\n--\n";

print $_." ".($letters{$_})."\n" for (sort {($letters{$b})<=>($letters{$a})} keys %articles);

print "\n\n\n=======\nseřazeno dle grafomanství (poměr písmen na příspěvek)\n--\n";

print $_." ".($letters{$_}/ $articles{$_})."\n" for (sort {($letters{$b}/ $articles{$b})<=>($letters{$a}/$articles{$a})} keys %articles);
