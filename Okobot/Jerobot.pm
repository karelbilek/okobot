package Okobot::Jerobot;

use 5.010;

use Okobot::Database;
use Data::Dumper;
use warnings;
use strict;

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
	
	@s = map {$_->{body}=~s/<[^<]*>//g; $_};
	@s = grep {splitsize($_->{body})>=10} @s;
	{
		open my $f, ">", "jerome.out2";
		print $f Dumper(\@s);
		close $f;
	}
}

1;