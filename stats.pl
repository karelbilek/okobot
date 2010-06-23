require "okobot.pl";
use utf8;
use warnings;
use strict;
use Time::localtime;

my $o = new Okobot("bot_almighty");

my $lt = $ARGV[0];
my $ltm = localtime($lt);

my $datum = ($ltm->mday).". ".($ltm->mon+1).". ".($ltm->year+1900);

#======nove kluby
open my $nk_f, "<:utf8", "nove_kluby";
my @nk = <$nk_f>;
close $nk_f;

my $nk_text;
while (scalar @nk) {
	my $id = (shift @nk);
	my $name = (shift @nk);
	$nk_text.='<a href="http://www.okoun.cz/boards?boardId='.$id.'">'.$name.'</a> [<a href="http://www.okoun.cz/old/boards?boardId='.$id.'">old</a>]<br>';
}

$o->post("okoun_stats", "nové kluby od ".$datum, $nk_text, 1);

#======grafiky
$o->post("okoun_stats", "příspěvky klubů od ".$datum, "<a href=\"http://running.chram.net/graf_kluby_".$ARGV[1].".gif\"><img src=\"http://running.chram.net/graf_kluby_".$ARGV[1]."_thumb.gif\"></a>", 1);

$o->post("okoun_stats", "příspěvky identit od ".$datum, "<a href=\"http://running.chram.net/graf_ID_".$ARGV[1].".gif\"><img src=\"http://running.chram.net/graf_ID_".$ARGV[1]."_thumb.gif\"></a>", 1);