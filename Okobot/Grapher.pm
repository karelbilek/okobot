package Okobot::Grapher;

use warnings;
use strict;

use 5.010;

sub new {
	
	my $class = shift;
	bless {}, $class;
}

sub set_weight {
	my $s = shift;
	my $what = shift;
	my $weight = shift;
	$s->{weights}{$what}=$weight;
	
}

sub add_connection{
	my $s = shift;
	
	my $first=shift;
	my $second = shift;
	my $weight = shift;
	
	$s->{mentions}{$first}=undef;
	$s->{mentions}{$second}=undef;
	
	if ($first lt $second) {
		$s->{connections}{$first}{$second}=$weight;
	} else  {
		$s->{connections}{$second}{$first}=$weight;
	}
}

sub do_graph {
	my $s = shift;
	my $circles = shift;
	my $visible = shift;

	open my $out , ">:utf8", "graph.dot" or die $!;
	
	say $out 'graph WTF {';
	say $out '	graph [layout=neato, overlap="vpsc"];';
	if ($circles) {say $out '	node [shape=circle];'}
	if (!$visible) {say $out '	edge [color=transparent];'}
	
	my %nodenames;
	my $nodecount=0;
	
	for my $name (keys %{$s->{mentions}}) {
		$nodecount++;
		if (exists $s->{weights}{$name}) {
			say $out "	node".$nodecount." [label = \"$name\", fixedsize = true, width = ".$s->{weights}{$name}."]";
		} else {
			say $out "	node".$nodecount." [label = \"$name\"]";
		}
		$nodenames{$name} = $nodecount;
	}
	
	for my $first (keys %{$s->{connections}}) {
		my $first_n = $nodenames{$first};
		for my $second (keys %{$s->{connections}{$first}}) {
			my $second_n = $nodenames{$second};
			if ($s->{connections}{$first}{$second}) {
				say $out "	node".$first_n." -- node".$second_n." [length = \"".$s->{connections}{$first}{$second}."\"]";
			} else {
				say $out "	node".$first_n." -- node".$second_n;
			}
		}
		
	}
	say $out "}\n";
	
	close $out;
	
	#system ("neato graph.dot -Tpng > graph.png");
}

1;