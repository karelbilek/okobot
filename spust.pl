use warnings;
use strict;
use utf8;
use 5.010;
use Okobot::Database;
use Okobot::Basic;
binmode STDOUT, ":utf8"; #at se s tim neseru



my $db = new Okobot::Database("bot_almighty");

use Data::Dumper;




my $clubs_hash;
my $id_hash;
{
	my $VAR1;
	open my $inf, "<:utf8", "counts";
	my $dumper = join ("", <$inf>);
	close $inf;

	$|=1;
	print "pred\n";

	eval($dumper);
	
	
	for my $a (keys %$VAR1) {
		for my $b (keys %{$VAR1->{$a}}) {
			$clubs_hash->{$b}{$a} = $VAR1->{$a}{$b};
		}
	}
	
	$id_hash = $VAR1;
	
	
	#pro generovani grafu KLUBU
	#Okobot::Database::remove_naplav($clubs_hash, 100);
	
	#pro generovani grafu IDENTIT
	Okobot::Database::remove_naplav($id_hash, 100);
	
	
	
}

#pro generovani grafu KLUBU
#my $clubs_connections = Okobot::Database::club_connections($id_hash);
#Okobot::Database::clean_lower_half($clubs_connections);
#Okobot::Database::do_graph($clubs_connections, $clubs_hash);

#pro generovani grafu IDENTIT
my $id_connections = Okobot::Database::club_connections($clubs_hash);
Okobot::Database::clean_lower_half($id_connections);
Okobot::Database::do_graph($id_connections, $id_hash);

