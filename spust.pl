use warnings;
use strict;
use utf8;
use 5.010;
use Okobot::Database;
use Okobot::Basic;
binmode STDOUT, ":utf8"; #at se s tim neseru



my $db = new Okobot::Database("bot_almighty");

use Data::Dumper;

# my ($id_counts, $id_lengths) = $db->get_id_counts();
# 
# print Dumper($id_counts, $id_lengths);

# open my $inf, "<:utf8", "nohup.out";
# my $dumper = join ("", <$inf>);
# close $inf;
# 
# my $VAR1;
# my $VAR2;
# eval($dumper);
# 
# Okobot::Database::top_grafomani($VAR1, $VAR2, "countsfile", "lengthsfile");



# my $allcounts = $db->get_counts();
# 
# open my $o, ">:utf8", "counts";
# print $o Dumper($allcounts);
# close $o;




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
	
	#na smazani pod 100 prispevku ... nevyplatilo se moc
	Okobot::Database::remove_naplav($VAR1, 100);
	
	for my $a (keys %$VAR1) {
		for my $b (keys %{$VAR1->{$a}}) {
			$clubs_hash->{$b}{$a} = $VAR1->{$a}{$b};
		}
	}
	
	$id_hash = $VAR1;
	
}



my $id_connections = Okobot::Database::club_connections($clubs_hash);


{
	my $spoje={}; my $w={};
	while (scalar Okobot::Database::get_classes_names($id_connections) > 5) {
		Okobot::Database::merge_classes($id_connections, $spoje, $w);
		
	}


	say Okobot::Database::get_joined_classes_names(0, $id_connections, $spoje);
	
	
}



# 
# 
# Okobot::Database::top_vsestrannost($VAR1, "vsestrannost.html");
