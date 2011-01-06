use warnings;
use strict;
use utf8;
use 5.010;
use Okobot::BestArticle;

use Okobot::Basic;

binmode STDOUT, ":utf8"; #at se s tim neseru

my $obot = new Okobot::Basic("statbot");

use Data::Dumper;

my @art = Okobot::BestArticle::all_best_articles($obot, 7, qw(dotazy komentare_k_aktualitam unhappy_love) );
for (@art) {
	say "autor:", $_->{author};
	say "value:", $_->{reply_value};
	say "text:", $_->{body};
	say "klub:", $_->{clubname};
	say "------";
}