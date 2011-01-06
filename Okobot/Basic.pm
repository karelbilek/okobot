package Okobot::Basic;

use 5.010;
use utf8;
use warnings;
use strict;
use LWP::UserAgent;
use Encode;

sub new {
	my $class = shift;
	my ($name, $password) = @_;
	if (!defined $password) {
		open my $heslofile, "<", "hesla/".$name.".txt";
		$password = <$heslofile>;
	}
	my $ua = LWP::UserAgent->new;
	$ua->cookie_jar( {} );
	
	my $self = {name=>$name, password=>$password, ua=>$ua};
	bless $self, $class;
	if ($self->__login) {
		return $self;
	} else {
		print "CANNOT DO\n";
		return undef;
	}
}

sub get_new_favourites {
	my $self = shift;
	
	my @res;
	
	my $cont = $self->get_url('http://www.okoun.cz/favourites.jsp?new=1') or return ();
	
	
	while ($cont =~ /<a class="name" href="\/boards\/([^"]*)"/g) {
		push @res, $1;
	}
	
	return @res;
}

sub get_url {
	
	my ($self, $url, $post, $post_array) = @_;
	say "Getting url $url";
	my $tries = 0;
	while ($tries<5) {
		my $res = undef;
		eval {
			my $response = ($post) ? ($self->{ua}->post($url, $post_array)) : ($self->{ua}->get($url));

			if ($response->is_success) {
				
				$res = $response->decoded_content;
			}
		};
		return $res if $res;
		$tries++;
	}
	return undef;
}

sub get_info {
	my $self = shift;
	my %descr = @_;
	
	
	my $cont = ((defined $descr{name}) ? $self->get_url('http://www.okoun.cz/old/boards/'.$descr{name}) : $self->get_url('http://www.okoun.cz/old/boards?boardId='.$descr{id})) or die;
	
	if ($cont =~ /<div id="mainWindow" class="layout">\s*Diskusní klub odpovídající Vašemu požadavku neexistuje.\s*<script type="text\/javascript">/s) {
		return ();
	}
	
	if (defined $descr{name}) {
		
		($cont =~ /<input type="hidden" name="shownBoardId\(([0-9]+)\)" value="/) or die;
		
		$descr{id} = $1;
	} else {
				
		($cont =~ /<h2 class="name">klub <a href="\/old\/boards\/([^"]*)">/) or die	;
		
		$descr{name} = $1;
		
	}
	
	if ($cont=~/<input type="submit" value="Zařadit klub mezi oblíbené" class="bmk-add">/) {
		$descr{booked} = 0;
	} else {
		$descr{booked} = 1;
	}
	
	$cont=~/<title>klub (.*)  na Okounovi &lt;°\)\)\)&gt;&lt;<\/title>/;
	
	$descr{nice_name}=$1;
	
	my @topics;

	while ($cont =~ /<a href="\/old\/topic.jsp\?topicId=([0-9]+)">/g) {
		if ($1!=1) {
			push (@topics, $1);
		}
	}
	
	$descr{topics}=\@topics;
	
	if ($cont =~ /<div id="board-postArticle" class="posted-item-form">\s*V tomto klubu nemáte povoleno zasílat diskusní příspěvky\s*<\/div>/s) {
		$descr{post_allowed} = 0;
	} else {
		$descr{post_allowed} = 1;
	}
	
	if ($cont=~/<div id="board-articles" class="list posted-item-list">\s*Nemáte právo číst tento klub\s*<\/div>/s) {
		$descr{read_allowed} = 0;
	} else {
		$descr{read_allowed} = 1;
	}
	
	return %descr;
	
}


sub __login {
	my $self = shift;

	my $cont = $self->get_url('http://www.okoun.cz/old/index.jsp', 1, [login=>($self->{name}), password=>($self->{password}), doLogin=>"1", topicId=>"1"]) or return 0;
	
	return ($cont=~/vitaj!/); #lol
}

sub get_article {
	my $self = shift;
	my $club_descr = shift;
	my $article_id = shift;
	
	my $url = (defined $club_descr->{name}) ? ('http://www.okoun.cz/old/boards/'.$club_descr->{name}.'?contextId='.$article_id)  : ('http://www.okoun.cz/old/boards?boardId='.$club_descr->{id}.'&contextId='.$article_id);
	my $cont = $self->get_url($url) or return undef;
	
	my %articles_hash;
	__add_articles_to_hash(\%articles_hash, $cont);
	
	return $articles_hash{$article_id};
	
	
}


my %mesice = (leden=>1, únor=>2, březen=>3, duben=>4, květen=>5, červen=>6, červenec=>7, srpen=>8, září=>9, říjen=>10, listopad=>11, prosinec=>12);
sub __add_articles_to_hash {
	my ($hash, $cont, $only_new, $last_ref) = @_;
	
	
	$cont=~/<h2 class="name">klub <a href="\/old\/boards\/([^\/]*)">/;
	my $clubname = $1;
	
	my $prostredek = ($only_new) ? " posted-item-new":"";
	
	my $regex = '<div id="article-([0-9]*)".?\n[^c]*class="article item posted-item'.$prostredek.'(.*?)(<\/div>[^<]*<div class="context">[^<]*<a href="\/old\/boards\/(?<reply>[^"]*)" onclick="[^"]*">[^<]*<\/a>[^<]*)?<\/div>[^<]*<\/div>[^<]*(<br class="separator" \/>|<\/form>[^<]*<ul class="pager">)';
	
	
	while ($cont =~ /$regex/sg) {
		
		my $article_id = $1;
		my $article_mess = $2;
		my $reply_all = $+{reply};
		
		my $author_icon_num;
		my $author_icon_name;
		if ($article_mess =~ /src="\/ico\/[^\?]*\?l=([^&]*)&amp;i=([0-9]*)" class="user-icon"/) {
			$author_icon_num = $2;
			$author_icon_name = $1;
		}
	
		my $author;
		
		if ($article_mess =~ /<span class="author row">\s*(.*?)\s*(<span class="author-|\.\.\.)/) {
			my $author_maybe = $1;
			if ($author_maybe =~ /<!-- anonym -->/) {
				$author = undef;
			} else {
				$author = $author_maybe;
			}
		} else {
			$author = undef; #anonym
		}
	
		$article_mess =~ /\.\.\.\s*([0-9]*)\.([^ \.]*) ([0-9]*) ([0-9]*):([0-9]*):([0-9]*)\s*<br \/>\s*<\/span>/s;
		
		
		my @date = (day=>$1, month=>$mesice{$2}, year=>$3, hour=>$4, minute=>$5, second=>$6);
	
		$article_mess =~ /<span class="title row">([^<]*)<\/span>/;
	
		my $title=$1; #muze byt prazdny
	
								#aby nezacinal a nekoncil otravnym whitespace
		$article_mess =~ /<div class="body">\s*(\S.*\S)\s*$/s;
		my $article_body = $1;
		
		
		my %article_hash = (id=>$article_id, author=>$author, author_icon_num=>$author_icon_num, author_icon_name=>$author_icon_name, title=>$title, body=>$article_body, clubname=>$clubname, @date);
		
		
		if (defined $reply_all and $reply_all=~/contextId=(.*)#/) {
			
			$article_hash{reply} = $1;
		}
		
		$hash->{$article_id} = \%article_hash;
		$$last_ref = $article_id if $last_ref;
	}
}

sub book {
	my $self = shift;
	my $klub = shift;
	#/old/boardRSS.jsp?boardId=150
	my $cont = $self->get_url('http://www.okoun.cz/old/boards/'.$klub) or return 0;
	
	($cont =~ /<input type="hidden" name="shownBoardId\(([0-9]+)\)" value="n">/) or return 0;
	
	my $club_id = $1;
	
	$self->get_url('http://www.okoun.cz/old/markFavouriteBoards.do', 1, ["shownBoardId($club_id)"=>"n", "favouriteBoardId($club_id)"=>"on", "boardId" => $club_id, "forwardOnSuccess"=>"board"]) or return 0;
	
	return 1;
}

sub recent_articles {
	my $s = shift;
	my $klub = shift;
	my $days = shift;
	
	my @timeData = localtime(time - $days * 24 * 60 * 60);
	my $day = $timeData[3];
	my $month = $timeData[4]+1;
	my $year = $timeData[5]+1900;
	
	
	return $s->all_articles($klub, undef, undef, $year, $day, $month);
}

sub all_articles {
	my $self = shift;
	my $klub = shift;
	my $max = shift;
	my $search = shift || "";
	my $maxyear = shift;
	my $maxday = shift || 1;
	my $maxmonth = shift || 1;
	
	#say "year $maxyear month $maxmonth day $maxday";
	
	my $cont = $self->get_url('http://www.okoun.cz/old/boards/'.$klub."?searchedStrings=".$search) or return ();
	
	
	
	my %articles_hash;
	
	my $stop;
	my $last;
	do {
		__add_articles_to_hash(\%articles_hash, $cont, 0, \$last);
		
		if ($cont =~ /<a href="([^"]*)">Starší<\/a>/) {
			
			$cont = $self->get_url("http://www.okoun.cz".$1) or return ();
		} else {
			$stop = 1;
		}
		
		if ($max and scalar keys %articles_hash >= $max) {
			$stop = 1;
		}
		
		if ($last and $maxyear 
			and 
				(
					(($articles_hash{$last}->{year}) < $maxyear)
				or 
					(($articles_hash{$last}->{year}) == $maxyear
					and 
					($articles_hash{$last}->{month}) < $maxmonth)
				or
					(($articles_hash{$last}->{year}) == $maxyear
					and 
					($articles_hash{$last}->{month}) == $maxmonth
					and
					($articles_hash{$last}->{day}) < $maxday))) {
			$stop=1;
		}
		
	} until ($stop);
	
	#hack for oldest page
	if ((!$max or scalar keys %articles_hash < $max) 
		and 
		(!$maxyear or !$last or (
			(($articles_hash{$last}->{year}) > $maxyear)
		or 
			(($articles_hash{$last}->{year}) == $maxyear
			and 
			($articles_hash{$last}->{month}) > $maxmonth)
		or
			(($articles_hash{$last}->{year}) == $maxyear
			and 
			($articles_hash{$last}->{month}) == $maxmonth
			and
			($articles_hash{$last}->{day}) >= $maxday)))) {
		$cont = $self->get_url('http://www.okoun.cz/old/boards/'.$klub.'?f=0&searchedStrings='.$search) or return ();
		__add_articles_to_hash(\%articles_hash, $cont);
	}
	my @keys = sort {$b<=>$a} keys %articles_hash;
	
	if (scalar @keys == 0) {
		return ();
	}
	my @res = @articles_hash{@keys[0..($max?($max-1):$#keys)]};
	
	if ($maxyear) {
		@res = grep {(
			($_->{year}) > $maxyear)
		or 
			(($_->{year}) == $maxyear
			and 
			($_->{month}) > $maxmonth)
		or
			(($_->{year}) == $maxyear
			and 
			($_->{month}) == $maxmonth
			and
			($_->{day}) >= $maxday)
		} @res;
	}
	
	
	return @res;
		
}

sub new_articles {
	my $self = shift;
	my $klub = shift;
	
			#abych mohl sledovat nove, musim to mit bukle
	my $cont_fav = $self->get_url('http://www.okoun.cz/favourites.jsp?new=1') or return ();
	
	my $klub_reg = $klub;
	$klub_reg =~ s/([\.\\\^\|\(\)\[\]\*\?\+\{\}])/\\$1/g;
		#budu to strkat do regexpu, ale zas na odkaz to chci bez toho
	
	# my $regex = '<a href="\/old\/boards\/'.$klub_reg.'"><span class="board-name">';
	# 
	# 
	# if ($cont=~/$regex/) {
		
		
		my $regex = '<a class="name" href="\/boards\/'.$klub_reg.'">[^<]*<\/a>\s*\([^\/]*\/<b><a href="([^\"]*)">';
		
		if ($cont_fav!~/$regex/) {
			return ();
		}
		$cont_fav =~ /$regex/;
		
		my $besturl = "http://www.okoun.cz/old".$1;
		
		my %articles_hash;
		
		my $cont = $self->get_url($besturl) or return ();
		
		my $stop;
		my $first=1;
		
		do {
			__add_articles_to_hash(\%articles_hash, $cont, $first);
			$first=0;
				
				#tady jdu od starsich k novejsim
			if ($cont =~ /<a href="([^"]*)">Novější<\/a>/) {
				
				$cont = $self->get_url("http://www.okoun.cz".$1) or return ();
			} else {
				$stop = 1;
			}
		} until ($stop);
		
		
		
		return @articles_hash{sort {$b<=>$a} keys %articles_hash};
	# 
	# } else {
	# 	return ();
	# } 
}


my %formats = (0=>"plain", 1=>"html", 2=>"radeox");
sub post {
	my $self = shift;
	my $klub = shift;
	my $title = shift;
	my $body = shift;
	my $format = shift;
	my $parent = shift;
	
	
	my $cont = $self->get_url('http://www.okoun.cz/old/boards/'.$klub.'?f=0') or return 0;
	
	($cont =~ /\/old\/boardRSS\.jsp\?boardId=([0-9]*)/) or return 0;
	
	my $club_id = $1;
	
	$self->get_url('http://www.okoun.cz/old/postArticle.do', 1, [boardId=>$club_id, parentId=>$parent, title=>encode("utf8", $title), email=>"", body=>encode("utf8", $body), bodyType=>$formats{$format}]) or return 0;
	return 1;
}

1;