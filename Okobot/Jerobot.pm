package Okobot::Jerobot;

use 5.010;

use Okobot::Database;
use Data::Dumper;

sub get_all {
	my @arts;
	my $d = new Okobot::Database("bot_almighty");
	$d->do_for_all(sub{
		my $a = shift;
		if ($a->{author} eq "JeromeHeretic") {
			push (@arts, $a);
			say scalar @arts;
		}
	});
	
	open my $f, ">", "jerome.out";
	print $f Dumper(\@arts);
	close $f;
}

1;