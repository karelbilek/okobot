use warnings;
use strict;
use utf8;
use 5.010;
use Okobot::Database;
use Okobot::Basic;
binmode STDOUT, ":utf8"; #at se s tim neseru

my $obot = new Okobot::Basic("statbot");

$obot->recent_articles("arabstina", 1);