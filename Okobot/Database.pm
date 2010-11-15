package Okobot::Database;

use 5.010;

use Okobot::Basic;
use warnings;
use strict;
use Data::Dumper;

sub new {
	my $class = shift;
	my $name = shift;
	$name = lc($name);
	
	my $basic = new Okobot::Basic($name);
	my $self = {name=>$name, basic=>$basic};
	
	bless $self, $class;
	return $self;
}

sub dir_dbase {
	my $s = shift;
	mkdir "dbase";
	mkdir "dbase/".$s->{name};
	
	return "dbase/".$s->{name};
}

sub rm_dbase {
	my $s=shift;
	if (-d "dbase") {
		
		if (-d "dbase/".$s->{name}) {
			system('rm -r dbase/'.$s->{name});
		}
	}
}

sub remove_naplav {
	my $counts = shift;
	my $howmuch = shift;
	
	for my $id (keys %$counts) {
		my $all;
		for my $c (keys %{$counts->{$id}}) {
			$all+=$counts->{$id}{$c};
		}
		
		if ($all<100) {delete $counts->{$id}}
	}
}

sub classes_graph {
	my $text = shift;
	
	
	my %nodes; #nazev tridy -> node
	my %named;
	
	
	my $maxnode=0;
	my @text = split(/\n/, $text);
	for (@text) {
		chomp;
		/^(.*) -> (.*)$/;
	
		if (!$nodes{$1}) {
			$nodes{$1}=++$maxnode;
			$named{$1}=undef;
		}
		if (!$nodes{$2}) {
			$nodes{$2}=++$maxnode;
			$named{$2}=undef;
		}
		$nodes{$1."+".$2}=++$maxnode;
	}
	
	print "digraph p{\n
		graph [rankdir=\"BT\"]\n";
	for (keys %nodes) {
		if (exists $named{$_}) {
			#if ($ARGV[1]) {
				#print "node".$nodes{$_}." [label=\"".$_."\" width=\"".$ARGV[1]."\" fixedsize=\"true\"]";
			#} else {
				print "node".$nodes{$_}." [label=\"".$_."\"]";
			#}
		} else {
				print "node".$nodes{$_}." [label=\"\" shape=\"none\" width=\"0\" height=\"0\"]";
		}

		print "\n";
	}

	for (@text) {
		/^(.*) -> (.*)$/;
		print "node".$nodes{$1}." -> node".$nodes{$1."+".$2}." [arrowhead=\"none\"]\n";
		print "node".$nodes{$2}." -> node".$nodes{$1."+".$2}." [arrowhead=\"none\"]\n";
	}
	print "}";
}


sub article_filename {
	my $s = shift;
	my $id = shift;
	
	$id=~/(..)(..)..$/;
	
	mkdir $s->dir_dbase."/".$1;
	mkdir $s->dir_dbase."/".$1."/".$2;
	return $s->dir_dbase."/".$1."/".$2."/".$id;
}

sub save_article {
	my $s = shift;
	my $article = shift;
	open my $outf, ">", $s->article_filename($article->{id});
	print $outf Dumper($article); 
	close $outf;
}

sub save_articles {
	my $s = shift;
	my @all = shift;
	for (@all) {
		$s->save_article($_);
	}
}

sub save_new_favourites {
	my $s = shift;
	
	my $b = $s->{basic};
	
	
	my @f = $b->get_new_favourites();
	for my $name (@f) {
		$|=1;
		print $name."\n";
		$s->save_articles($b->new_articles($name));
		
	}
}

sub save_list {
	my $s = shift;
	my $list = shift;
	my ($maxyear, $maxday, $maxmonth) = @_;
	my $b = $s->{basic};
	
	for my $name (@$list) {
		$|=1;
		print $name."\n";
		$s->save_articles($b->all_articles($name, undef, undef, $maxyear,$maxmonth,$maxday));
		
	}
}

sub save_and_book_all_IDs {
	my $s = shift;
	my $list = shift;
	
	my $b = $s->{basic};
	
	for my $id (@$list) {
		my %cl = $b->get_info(id=>$id);
		if ($cl{read_allowed}) {
			$|=1;
			print $cl{name}."\n";
			$b->book($cl{name});
			$s->save_articles($b->all_articles($cl{name}));
			
		}
	}
}

sub save_all_known {
	my $s= shift;
	my $first = shift;
	my $last = shift;
	my $b = $s->{basic};
	
	for my $id ($first..$last) {
		my %cl = $b->get_info(id=>$id);
		if ($cl{read_allowed}) {		
			$|=1;
			print $cl{name}."\n";
			$s->save_articles($b->all_articles($cl{name}, undef, undef, 2009,0,0));
		}
	}
}



sub do_for_all {
	my $s = shift;
	my $db = $s->dir_dbase;
	my $subref = shift;
	for (<$db/*>) {
		for (<$_/*>) {
			for my $file (<$_/*>) {
				open my $inf, "<:utf8", $file;
				my $dumped = join ("", <$inf>);
				close($inf);
				my $VAR1;
				eval($dumped);
				$subref->($VAR1);
				$VAR1=undef;
			}
		}
	}
}



sub get_counts {
	my $s = shift;
	my %counts;
	$s->do_for_all(sub{
		my $a = shift;
		if ($a->{author}) {
			$counts{$a->{author}}{$a->{clubname}}++;
		}
	});
	return \%counts;	
}

sub get_total{
	my $s=shift;
	my $i;
	$s->do_for_all(sub{
		$i++;
		if (($i%10000)==0) {
			$|=1;
			say $i;
		}
	});
	return $i;
}

sub get_id_counts {
	my $s = shift;
	my %id_counts;
	my %id_lengths;
	
	$s->do_for_all(sub{
		
		my $a = shift;
		if ($a->{author}) {
			$id_counts{$a->{author}}++;
			$id_lengths{$a->{author}}+=length($a->{body});
		}
	});
	
	return (\%id_counts, \%id_lengths);
}


sub top_grafomani {
	my ($id_counts, $id_lengths, $countsfile, $lengthsfile)=@_;
	my @keys_counts = sort {$id_counts->{$b} <=> $id_counts->{$a}} keys %$id_counts;
	my @keys_lengths = sort {$id_lengths->{$b} <=> $id_lengths->{$a}} keys %$id_lengths;
	
	say "POCTY";
	say"==";
	say "<table>";
	my $i=1;
	for (@keys_counts[0..29]) {
		my $number = $id_counts->{$_};
		$number =~ s/(\d{1,3}?)(?=(\d{3})+$)/$1 /g;
		say "<tr><td>".($i++)."</td><td>".$_."</td><td>".$number."</td></tr>";
	}
	say "</table>";
	
	say "DELKY";
	say"==";
	say "<table>";
	
	for (@keys_lengths[0..29]) {
		my $number = $id_lengths->{$_};
		$number =~ s/(\d{1,3}?)(?=(\d{3})+$)/$1 /g;
		say "<tr><td>".($i++)."</td><td>".$_."</td><td>".$number."</td></tr>";
	}
	say "</table>";
	
	
	
	open my $cf, ">:utf8", $countsfile;
	say $cf "<table>";
	
	for (@keys_counts) {
		my $number = $id_counts->{$_};
		$number =~ s/(\d{1,3}?)(?=(\d{3})+$)/$1 /g;
		say $cf "<tr><td>".($i++)."</td><td>".$_."</td><td>".$number."</td></tr>";
	}
	say $cf "</table>";
	close $cf;
	
	open my $lf, ">:utf8", $lengthsfile;
	say $lf "<table>";
	
	$i=1;
	for (@keys_lengths) {
		my $number = $id_lengths->{$_};
		$number =~ s/(\d{1,3}?)(?=(\d{3})+$)/$1 /g;
		say $lf "<tr><td>".($i++)."</td><td>".$_."</td><td>".$number."</td></tr>";
	}
	say $lf "</table>";
	close $lf;
	
}

sub top_vsestrannost {
	my $counts = shift;
	my $vsestrannost_file = shift;
	
	my @keys_counts = sort {(scalar keys %{$counts->{$b}}) <=> (scalar keys %{$counts->{$a}})} keys %$counts;

	say "<table>";
	my $i=1;
	
	for (@keys_counts[0..29]) {
		my $number = (scalar keys %{$counts->{$_}});
		say "<tr><td>".($i++)."</td><td>".$_."</td><td>".$number."</td></tr>";
	}
	
	say "</table>";
	
	open my $lf, ">:utf8", $vsestrannost_file;
	say $lf "<table>";
	
	$i=1;
	for (@keys_counts) {
		my $number = (scalar keys %{$counts->{$_}});
		say $lf "<tr><td>".($i++)."</td><td>".$_."</td><td>".$number."</td></tr>";
	}
	say $lf "</table>";
	close $lf;
	
}

sub club_connections {
	my $counts = shift;
	
	my %cons;
	
	for my $id (keys %$counts) {
		for my $clubA (keys %{$counts->{$id}}) {
			for my $clubB (keys %{$counts->{$id}}) {
				if ($clubA ne '' and $clubB ne '' and $clubA lt $clubB) {
					
					$cons{$clubA}{$clubB}+=log($counts->{$id}->{$clubA} * $counts->{$id}->{$clubB}) if (log($counts->{$id}->{$clubA} * $counts->{$id}->{$clubB}));
					
				}
			}
		}
	}
	return \%cons;
}

sub get_joined_classes_names {
	my $basic = shift;
	#basic je potreba k vypisovani "hezkych" nazvu klubu - nechci pouzivat toho sameho bota, jako na database
	#protoze by mi mohl odnovit neco, co odnovit nechci :)
	
	my $cons = shift;
	
	my $spoje = shift;
	my @n = get_classes_names($cons);
	
	my @joined = sort {$spoje->{$b}<=>$spoje->{$a}} (grep {/\+/} @n);
	
		my $res = "<table>\n";
		my $i = 1;
		for my $line (@joined) {
			my @clubs = split(/\+/, $line);
			$res.="<tr><td>".($i++)."</td><td>";
			
			if ($basic) {
				# hezky vypis klubu
				for my $club_ugly (@clubs) {
					my %cl = $basic->get_info(name=>$club_ugly);
					my $nice = $cl{nice_name};
					$res.="<a href=\"http://www.okoun.cz/boards/".$club_ugly."\">".$nice."</a> ";
				}
			} else {
				$res .= join (" - ", @clubs);
				
			}
			
			$res.="</td></tr>\n";
		}
		$res.="</table>";
		
	# my $res = join ("\n", @joined);
	return $res;
}

sub get_classes_names {
	my $cons = shift;
	my %mentioned;
	for my$clubA (keys %$cons) {
		$mentioned{$clubA}=undef;
		for my $clubB (keys %{$cons->{$clubA}}) {
			$mentioned{$clubB}=undef;
			
		}
	}
	return keys %mentioned;
}

sub count_splitsize {
	my $w = shift;
	my @arr = split(/\+/, $w);
	return scalar @arr;
}

sub edgecount {
	my $num = shift;
	return $num*($num-1)*(1/2);
}

sub merge_classes {
	my $cons = shift;
	my $classes_average = shift;
	my $add_by_merging = shift;
	my $bigplus = 100;
	
	my $biggerminus = -(9**9**9);
	
	my %bests; #sort je tady a o kus niz jenom proto, aby to 2x po sobe vyslo stejne. pokud o to nejde, muze se to nechat by
	for my$clubA (keys %$cons) {
		my $best;
		my $max=$biggerminus;
		for my $clubB (keys %{$cons->{$clubA}}) {
			if ($cons->{$clubA}{$clubB} > $max) {
				$max = $cons->{$clubA}{$clubB};
				$best = $clubB;
			}
		}		
		$bests{$clubA} = $best."|".$cons->{$clubA}{$best};
	}
	
	my $best;
	my $secbest;
	my $max=$biggerminus; # 
	for my $candidate (keys %bests) {
		$bests{$candidate}=~/^(.*)\|(-?\d*\.?\d*e?-?\d*)$/;
		if (!$2) {
			die $candidate." ma divnou ".$bests{$candidate};
		}
		if ($2>$max) {
			$max = $2;
			$best = $candidate;
			$secbest=$1;
		}
	}
	$classes_average->{$best."+".$secbest}= ($classes_average->{$best} || 0) + ($classes_average->{$secbest} || 0) + $max;
	
	say "Best je velky $max";
	
	my @neighbours;
	{
		my %helphash;
		for my $clubA (keys %$cons) {
			if (exists $cons->{$clubA}{$best} or exists $cons->{$clubA}{$secbest}) {
				$helphash{$clubA}=undef;
			}
		}
		for my $clubA (keys%{$cons->{$best}}) {
			$helphash{$clubA}=undef;
		}
		for my $clubA (keys%{$cons->{$secbest}}) {
			$helphash{$clubA}=undef;
		}
		delete $helphash{$best};
		delete $helphash{$secbest};
		
		@neighbours = keys %helphash;
	}
	
	for my $clubA (@neighbours) {
		
		my $firstvys =  ($cons->{$clubA}{$best}||0) + ($cons->{$best}{$clubA}||0);
		my $secondvys =  ($cons->{$clubA}{$secbest}||0) +($cons->{$secbest}{$clubA}||0);
		
		my $vys = ($firstvys + $secondvys)/2;
		
		delete $cons->{$clubA}{$secbest};
		delete $cons->{$clubA}{$best};
		if ($vys > 0) {
			if ($clubA lt ($best."+".$secbest)) {
				$cons->{$clubA}{$best."+".$secbest} = $vys;
			} else {
				$cons->{$best."+".$secbest}{$clubA} = $vys;
			}
		}
		if (scalar keys %{$cons->{$clubA}} == 0) {
			delete $cons->{$clubA};
		}
	}
	delete $cons->{$best};
	delete $cons->{$secbest};
	
	
	
	say $best." -> ".$secbest;
	
	return $best." -> ".$secbest."\n";
}


1;