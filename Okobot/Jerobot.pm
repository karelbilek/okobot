package Okobot::Jerobot;

use 5.010;

use Okobot::Database;
use Data::Dumper;
use warnings;
use strict;

use Algorithm::NaiveBayes;

sub get_all {
	my @arts;
	my @pre_arts;
	my $d = new Okobot::Database("bot_almighty");
	
	$d->do_for_all(sub{
		my $a = shift;
		if ((defined $a->{author}) and ($a->{author} eq "JeromeHeretic")) {
			push (@arts, $a);
			say scalar @arts;
			if (exists $a->{reply}) {
				my $reply_num = $a->{reply};
				my $reply_article = $d->get_article($reply_num);
				push (@pre_arts, $reply_article) if $reply_article;
			}
		}
	});
	
	{
		open my $f, ">", "jerome.out";
		print $f Dumper(\@arts);
		close $f;
	}
	{
		open my $f, ">", "prejerome.out";
		print $f Dumper(\@pre_arts);
	
		close $f;
	}
}

sub splitsize {
	my $what = shift;
	my @s = split (/\ /,$what);
	return scalar @s;
}

sub clean_short {
	my @s;
	{
		open my $f, "<", "jerome.out";
		my $dumped = join ("", <$f>);
		my $VAR1;
		eval($dumped);
		close $f;
		@s = @$VAR1;
	}
	
	@s = map {$_->{body}=~s/<[^<]*>/ /g; $_} @s;
	@s = grep {splitsize($_->{body})>=15} @s;
	{
		open my $f, ">", "jerome.out2";
		print $f Dumper(\@s);
		close $f;
	}
}

sub bayes {
	my $question = shift;
	my $s;
	$|=1;
	
	say "nacitani ...";
	{
		open my $f, "<", "jerome.out2";
		say "pred joinem";
		my $dumped = join ("", <$f>);
		my $VAR1;
		say "pred eval";
		eval($dumped);
		say "za eval";
		close $f;
		$s = $VAR1;
	}
	
	my $nb = Algorithm::NaiveBayes->new;
	
	my %back;
	
	
		say "pred add instance";
	for my $a (@$s) {
		my @words = split(/\ \.\?,!/, $a->{body});
		my %counts;
		for (@words) {$counts{$_}++};
		$nb->add_instance (attributes => \%counts, label => $a->{id});
		
		$back{$a->{id}}=$a;
	}
	
	say "begin train";
	$nb->train;
	say "end train";
	
	my @artwords = split(/\ \.\?,!/, $question);
	my %artcounts;
	for (@artwords) {$artcounts{$_}++};
	
	my $result = $nb->predict
	    (attributes => {bar => 3, blurp => 2});
	
	my $best = (sort {$result->{$b} <=> $result->{$a}} keys %$result)[1];
	
	say $result->{$best};
	say $back{$best}->{body};
}

1;