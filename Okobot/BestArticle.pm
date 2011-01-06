package Okobot::BestArticle;


use 5.010;
use utf8;
use warnings;
use strict;

sub all_best_articles{
	my $obot = shift;
	my $days = shift;
	my @clubs = @_;
	
	my @art_all;
	for my $club (@clubs) {
		my @art = best_articles($obot, $club, $days);
		push (@art_all, @art);
	}
	
	my @res = sort {($b->{reply_value}||0) <=> ($a->{reply_value}||0)} @art_all;
	
	return @res[0..39];
	
}

sub fce {
	my $n = shift;
	#vsem stejne
	#return 1;
	
	#odstupnovane
	#return 1/(2**($n-1));

	#arnostovo upravene
	if ($n<4) {
		return 1;
	} else {
		return 0;
	}
}

sub best_articles {
	my $obot = shift;
	my $klub = shift;
	my $days = shift;
	
	say "nalogovano";
	my @articles = $obot->recent_articles($klub, $days);
	say "stahnuto, pocitam...";
	
	#ted zbytecne vorim hash, co uz jsem v all_articles jednou tvoril, ale sper to cert
	#(jsou to pointery, pamet to tedy nezabira)
	
	my %articles_hash = map {($_->{id}, $_)} @articles;
	
	for my $article (@articles) {
		my $add = 1;
		
		my $art_to_add = $article->{reply};
		
		while (defined $art_to_add and exists $articles_hash{$art_to_add}) {
			$articles_hash{$art_to_add}->{reply_value}+=fce($add);
		} continue {
			$art_to_add = $articles_hash{$art_to_add}->{reply};
			$add++;
			
		}
	}
	
	my @res_articles = sort {($b->{reply_value}||0) <=> ($a->{reply_value}||0)} @articles;
	
	return @res_articles[0..39];
}

1;