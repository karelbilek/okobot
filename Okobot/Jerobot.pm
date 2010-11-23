package Okobot::Jerobot;

use 5.010;

use Okobot::Database;
use Data::Dumper;

sub get_all {
	my @arts;
	my @pre_arts;
	my $d = new Okobot::Database("bot_almighty");
	
	$d->do_for_all(sub{
		my $a = shift;
		if ($a->{author} eq "JeromeHeretic") {
			push (@arts, $a);
			say scalar @arts;
			if ($a->{reply}) {
				my $reply_num = $a->{$reply};
				my $reply_article = $s->get_article($reply_num);
				push (@pre_arts, $reply_article);
			}
		}
	});
	
	open my $f, ">", "jerome.out";
	print $f Dumper(\@arts);
	open my $f, ">", "prejerome.out";
	print $f Dumper(\@pre_arts);
	
	close $f;
}

1;