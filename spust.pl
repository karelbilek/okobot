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
	#Okobot::Database::remove_naplav($VAR1, 100);
	
	for my $a (keys %$VAR1) {
		for my $b (keys %{$VAR1->{$a}}) {
			$clubs_hash->{$b}{$a} = $VAR1->{$a}{$b};
		}
	}
	
	$id_hash = $VAR1;
	
}


my $clubs_connections = Okobot::Database::club_connections($id_hash);
#my $id_connections = Okobot::Database::club_connections($clubs_hash);
#tohle neni chyba :)
#pokud chci pribuznost klubu, potrebuju clubs_connections, co pak predavam merge_classes, ktera spojuje vrcholy k sobe



say scalar Okobot::Database::get_classes_names($clubs_connections);
#pocet trid

# my $basic = new Okobot::Basic("statbot");
my $spoje={}; my $w={};
my $res="";
for (1..200) {
	
	Okobot::Database::merge_classes($clubs_connections, $spoje, $w);
	#spoje - na hodnoceni "sily" spojeni vrcholu
	#podle toho to pak nakonec radim
	
		
}


#Okobot::Database::classes_graph($res);



say Okobot::Database::get_joined_classes_names( $clubs_connections, $spoje);
#na vypis HTML



# 
# 
# Okobot::Database::top_vsestrannost($VAR1, "vsestrannost.html");
