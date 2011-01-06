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
	
	my @res_articles = sort {($b->{reply_value}||0) <=> ($a->{reply_value}||0)} @art_all;
	
	@res_articles = @res_articles[0..39];
	
	my %clusters;
	
	#tenhle kod uz v budoucnosti nikdy neprectu...
	
	for my $article (@res_articles) {
		push @{$clusters{$article->{thread}}{array}}, $article;
		
		my $m = $clusters{$article->{thread}}{score};
		if (!defined $m or $m<($article->{reply_value}||0)) {
			$clusters{$article->{thread}}{score} = ($article->{reply_value}||0);
		}
	}
	
	for my $cluster_id (keys %clusters) {
		my %all_in = map {($_->{id}, $_)} (@{$clusters{$cluster_id}{array}});
		$clusters{$cluster_id}{size} = scalar keys %all_in;
		
		my %struktured_in = %all_in;
		
		for my $article_id (sort {($all_in{$b}{reply_value}||0) <=> ($all_in{$b}{reply_value}||0)} keys %all_in) {
			my $article = $all_in{$article_id};
			if (exists $all_in{($article->{reply}||"")}) {
				push @{$all_in{$article->{reply}}->{kids}}, $article;
				delete $struktured_in{$article_id};
			}
		}
		
		$clusters{$cluster_id}{array} = [sort {$a->{level} <=> $b->{level}} values %struktured_in];
	}
	
	my @res_clusters = sort {$b->{score}<=>$a->{score}} values %clusters;
	
	return @res_clusters;
	
}

sub fce {
	my $n = shift;
	#vsem stejne
	#return 1;
	
	#odstupnovane
	return 1/(2**($n-1));

	#arnostovo upravene
	#if ($n<4) {
	#	return 1;
	#} else {
	#	return 0;
	#}
}

sub best_articles {
	my $obot = shift;
	my $klub = shift;
	my $days = shift;
	
	say "go club $klub";
	my @articles = $obot->recent_articles($klub, $days);
	say "stahnuto, pocitam...";
	
	#ted zbytecne vorim hash, co uz jsem v all_articles jednou tvoril, ale sper to cert
	#(jsou to pointery, pamet to tedy nezabira)
	
	my %articles_hash = map {($_->{id}, $_)} @articles;
	
	my %aut_rep_combs;
	
	
	for my $article (@articles) {
		my $level = 1;
		
		my $art_to_add = $article->{reply};
		my $aut = $article->{author};
		$article->{thread} = $article->{id};
		$article->{level} = 0;
		
		if (defined $art_to_add and !exists $aut_rep_combs{$aut}->{$art_to_add}) {
			$aut_rep_combs{$aut}->{$art_to_add} = undef;
		
			while (defined $art_to_add and exists $articles_hash{$art_to_add}) {
				$articles_hash{$art_to_add}->{reply_value}+=fce($level);
				$article->{thread}=$art_to_add;
				$article->{level}=$level;
			} continue {
				$art_to_add = $articles_hash{$art_to_add}->{reply};
				$level++;
			
			}
		}
	}
	
	return @articles;
}

1;