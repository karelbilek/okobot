use warnings;
use strict;
use utf8;
use 5.010;
use Okobot::Database;
use Okobot::Basic;
binmode STDOUT, ":utf8";



my $clubs_hash;
{
	my $VAR1;
	open my $inf, "<:utf8", "counts";
	my $dumper = join ("", <$inf>);
	close $inf;

	
	eval($dumper);
	
	$clubs_hash = $VAR1;
	
	
}

my %pocty_klubu;

for my $id (keys %$clubs_hash) {
	for my $club (keys %{$clubs_hash->{$id}}) {
		$pocty_klubu{$club}+=$clubs_hash->{$id}->{$club};
	}
}

my @r = sort {$pocty_klubu{$b}<=>$pocty_klubu{$a}} keys %pocty_klubu;
@r = @r[0..50];

for (@r) {say $_}