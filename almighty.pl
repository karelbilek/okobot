use File::Copy;

$tm = time;
$ltm = localtime($time);

if (-e "vypis.txt") {
	move("vypis.txt", "vypisy/".$tm);
}


print "11\n";
system("perl oblib_nove.pl");
print "13\n";
system("perl vypis_novyky.pl");

print "16\n";
system("perl graf_kluby.pl");

print "19\n";
system("neato graph.dot -Tpng > graph.png");

print "22\n";
system("convert graph.png -depth 8 -resize 70% graph.gif");
system("convert  -size 120x120 graph.gif -resize 120x120 graph_thumb.gif");

print "25\n";
move("graph.gif", "../www/graf_kluby_".$tm.".gif");
move("graph_thumb.gif", "../www/graf_kluby_".$tm."_thumb.gif");

unlink "graph.dot";
unlink "graph.png";
unlink "graph.gif";

print "32\n";
system("perl graf_ID.pl");

print "35\n";
system("neato graph.dot -Tpng > graph.png");

print "38\n";
system("convert graph.png -depth 8 -resize 70% graph.gif");
system("convert  -size 120x120 graph.gif -resize 120x120 graph_thumb.gif");

move("graph.gif", "../www/graf_ID_".$tm.".gif");
move("graph_thumb.gif", "../www/graf_ID_".$tm."_thumb.gif");

unlink "graph.dot";
unlink "graph.png";
unlink "graph.gif";

my $lt_f;
open $lt_f, "<", "last_time";
my $lt_old = <$lt_f>;
close $lt_f;

print "51\n";
system("perl stats.pl $lt_old $tm");

unlink "last_time";
open $lt_f, ">", "last_time";
print $lt_f $tm;
close $lt_f;

unlink "posledni";
move("novy_posledni", "posledni");