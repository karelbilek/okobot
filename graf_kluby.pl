
package main;
use strict;
use warnings;

unlink "graph.dot";

my $file;
open $file, "<:utf8", "vypis.txt" or die $!;

my $out;
open $out , ">>:utf8", "graph.dot" or die $!;

my $clubcount=0;

my %clubs;

print $out 'graph WTF {
	graph [layout=neato, overlap=vpsc];
	node [shape=circle];
	edge [color=transparent];
';

my @inp = <$file>;
chomp @inp;
my %whowhere;
my %counts;
for my $i (0..($#inp/3)) {
	my $author = $inp[$i*3];
	my $club = $inp[$i*3+1];
	my $count = $inp[$i*3+2];
	
	
	if ($count > 5) {
		push @{$whowhere{$author}}, $club;
	}
	
	$counts{$club}+=$count;
}

my %sizes;
my %connections;
for my $ref (values %whowhere) {
	for my $where1 (@$ref) {
		for my $where2 (@$ref) {
			if ($where1 ne $where2) {
				if (!$clubs{$where1}) {
					#my $size = ((log $counts{$where1})-4.5)*2;
					my $size = sqrt $counts{$where1}/30;
					if ($size > 0.1666) {
						$clubcount++;
						$clubs{$where1}=$clubcount;
					
						$sizes{$where1}=$size;#"\tclub".$clubcount." [label = \"$where1\", fixedsize=true, width=$size];\n";
					}
				}
				
				if (!$clubs{$where2}) {
					
					#my $size = ((log $counts{$where2})-4.5)*2;
					my $size = sqrt $counts{$where2}/30;
					
					if ($size > 0.1666) {
						$clubcount++;
						$clubs{$where2}=$clubcount;
						$sizes{$where2}=$size;
						#print $out "\tclub".$clubcount." [label = \"$where2\", fixedsize=true, width=$size];\n";
					}
				}
				
				
				$connections{$where1}->{$where2}++;
			}
		}
	}
}

for (sort {$sizes{$a}<=>$sizes{$b}} keys %sizes) {
	print $out "\tclub".$clubs{$_}." [label = \"$_\", fixedsize=true, width=".$sizes{$_}."];\n";
}

for my $where1 (keys %connections) {
	for my $where2 (keys %{$connections{$where1}}) {
		if (($where1 lt $where2) and ($clubs{$where1}) and ($clubs{$where2})) {
			print $out "\tclub".$clubs{$where1}." -- club".$clubs{$where2}." [len = \"".(sqrt((keys %{$connections{$where1}}) + (keys %{$connections{$where2}}))*0.7*(sqrt ($connections{$where1}->{$where2})))."\"];\n";
		}
	}
}

print $out "}\n";