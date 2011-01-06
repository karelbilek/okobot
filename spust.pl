use warnings;
use strict;
use utf8;
use 5.010;
use Okobot::BestArticle;

use Okobot::Basic;

binmode STDOUT, ":utf8"; #at se s tim neseru

my $obot = new Okobot::Basic("statbot");

use Data::Dumper;

#my @art = Okobot::BestArticle::all_best_articles($obot, 7, "tohle_psal_sam_zivot");
my @clubs = qw(komentare_k_aktualitam
obrazek%2C_pred_kterym_jsem_se_prave_vyhonil%28la%29.
jdu_na_kaficko
fotbal
text%2C_pred_kterym_jsem_se_prave_vyhonil%28la%29.
olol_fotomontaze_%3A%29%29
sbirame_kalendaricky
%22umi_kocka_couvat_%22_a_dalsi_dulezite_otazky
co_nas_sere
mate_doma_kocku_
rodokmeny%2C_genealogie
krestanstvi
radovan_kaluza_fetisismus
detstvi___nostalgie
kinderhulan_-_young_padawan_na_mistra
dotazy
ujete_fotky
tohle_psal_sam_zivot
co_prave_hrajete_aneb_okoun_game_community
jidlo_a_vareni
unhappy_love
spolecnost
sexy_chlapi
osklivka_betty
monstra_a_zrudy%2C_ktere_si_pestujeme
nunu
okoun_compressor
medialni_mrdky
radek_hulan
vychova_deti
smazka_obecna
bludicka_a_jeji_rodina
denik_referendum
fotografie_okounaku
silnicni_doprava
kabinet_doktora_ozivleho
kuraci_z_hospod_ven%21
vite%2C_ze...
prace
co_vas_nesere...
ukaz_se_nam
odborne_zneftipnene_ftipy
zbrane
gorre_reloaded
okouni_blog
iphone
fashionisto_a__fetisismus
cestina
posaderologie
spotrebitel
night_club
medicina
chucpe
minecraft
duchovno
oznameni
univerzalni_fetisismus
pranyr_prekladu
poznate_hru_z_obrazku_
aktuality
animovane_gify
konspiracni_teorie
linux
orwell_%3A_1984
prazske_restaurace%2C_bary_a_hospody
osklivy_zensky
tak_se_nam_ukaz.
komixove_stripy
facebook
gentleman_se_prevleka_k_veceri_i_ji-li_sam
google_android
inception
jak_nas_vidi_ostatni_okouni
kompost
hnusne_nehty_fetisismus
teh_interwebz
uhodni_misto
kam_s_nim_
asociace
infoporn
preklepy%2C_prereky%2C_prekuky
brno
ceska_televize
watchers
cesko_slovensko_ma_talent
ondrej_vomocil
historie_a_antropologie
kldr
sparta_praha%2C_ole%21
video%2C_pred_kterym_jsem_si_prave_vyhonil%28a%29
pravo_a_zakony
uz_jste_si_nekdy_vsimli...
cesky_nevkus
kytara_a_tak
usni_cervi
neftipne_ftipy
freudovy_kulicky
ukaz_nam_svuj_byt
google
hardware
co_prave_ctu
prirodozpytno
retezovka_s_minimem_zmen_podle_levensteinovy_vzdalenosti
japka_alias_apple_a_mac
tohle_chci
astar_akbar%21
synestezie
stoleti____
fotky_vasich_domacich_mazlicku
fotky_nasich_deti
okouni_ankety
globalni_oteplovani
starcraft_ii
if_%28i%3D1%29
poznate_hru_z_osmi_bitu_
musim_zhubnout_%21%21%21%21
islam
survival
co_jsem_mel_dnes_k_obedu
houby_a_houbarstvi
judr._phdr._mgr._et_mgr._henryk_lahola_fetisismus
ujeta_videa
vedci_zjistili
bratri_nemcove%3A_dilo_a_zivot
jedeme_s_buchtou_na_vylet
radim_hasalik%3A_dilo_a_zivot
detstina
uhodni_osobnost_podle_obrazku
nomenomen
patos
sql
gramaticke_soky
prazske_zabery
ropa
bubu
jauneraci_vs._chrapouni
kozaderologie
podzemi
3._svetova_valka
bazar_-_nakup%2C_prodej.
macak_fetisismus
matematika
vypisky_z_cetby
klub_pratel_sportu
psi_klub
jiri_babica_fetisismus
zabavne_novinove_titulky
nemravne_animovane_gify
vystreleny_voko
definicni_vyroky
windows_xp
rapidshare_a_spol.
stavime_okounov
vune_dalav
otazky_a_odpovedi
hezke_oblecene_slecny
za_kazde_pivo_udelej_carku
kun%2C_pritel_cloveka
civilizace_i_%2B_ii_%2B_iii_%2B_iv_%2B_v_atd._-_proste_hry_sida_meiera_a_jim_podobny.
flor_-_deda_zlutak_team
i_see_faces
jazykovy_koutek
movies
fanklub_fotbaloveho_tymu_okouni
tramping_a_vandrovani
vite%2C_ze_...
svobodne_zednarstvi
vysla_jim_predpoved_
nareci_ceska
sny
libomudravna
cl_report
prostreno
vsichni_jsme_fagi
software
fallout
panika%21%21%21
bulvar
ceska_piratska_strana
zednarstvi
co_prave_posloucham
strana_zelenych
bugreports
psychologie_a_psychiatrie
etymologie
english
dabing
alchymie
okouni_a_polookouni_pary_ve_fotografiich
java
neftipne_creatory
pivo
zeky_fetisismus
religionistika
pohunek_prebral
klub_spratelenych_nealkoholiku
rozklicuj_film_aneb_skleroza_je_svinstvo
bible
e-books
pan_hradu
opera_-_nejrychlejsi_browser_na_zemi
vedecky_humor
odesel_jsem_z_okouna
monarchie
objective_c
hezke_chvile
ftipy
ukaz_sve_auto
panoptikum_pleonasmu%2C_obrazarna_oxymor
panic_ve_20ti
zrale_zeny
nostalgie
komentare_k_olol_fotomontazim
rekl_nekdo_%22sex%22_
architektura
preziti
turecky_bazar
digitalni_fotografie
olivie_brabcova_aka_olyfka_fetisismus
evoluce
spatne_basne
kresleny_humor
laserove_ocni_operace
petr_loukota_fetisizmus
urban_legends
aktualni_pocasi
banky
iran
gps_a_geocaching
zahradkareni%21
klub_pro_doceneni_zrzek
moudry_je_dabel
statni_sprava
pocitani
udelej_si_sam
praha_7
investice%2C_spekulace%2C_penize
pan_lipan
mhd%2C_autobusy%2C_tramvaje%2C_metro
mne_se_chce_neco_rict
linux%28tm%29_vs._windows%28tm%29
serialy
japonsko_manga_a_anime
inliner_akce
nechutna_slova
milan_buricin_fetisismus
volne_asociace
dragon_age%3A_origins
industrialni_stavby
slavia_praha
feminismus
pranyr_vyslovnosti
lolcats
reklamy
obrazek_hermiony%2C_pred_kterym_jsem_se_prave_vyhonil%28a%29
jazykove_valky
ukaz_sve_pribuzne
vlastivedne_vylety
kuriozni_smrti
letadla_a_letenky
chobotnice
letani
fyzika
ceske_drahy
co_byste_si_prali
kulhanek_je_buh%21
porady_z_vegy_a_magionu
sexy_kary_%3A%29
unicorn
neperspektivni_architektura
4lisky
okoun_se_testuje
planespotting
fukingdesign
cyklistika
sci-fi
nechutne_fotky
ctrl_%2B_v
okoun_relationships_history_%28s_prihlednutim_k_laskave_infografice%29
vulgarismy
inliner_fetisismus
kolik_tresni%2C_tolik_visni
z_nasich_vzkazniku
www.nicole-amy.eu
mrakologie
dfens-cz.com_-_allgemeine_diskussion
adobe_photoshop
futurama
okoun_sportuje
zelvi_zlutitko
hokej

);

sub print_article {
	my $f = shift;
	my $a = shift;
	
	print $f "<table class=\"ctable\"><tr><td class=\"icontd\"><img src=\"http://www.okoun.cz/ico/?l=".$a->{author_icon_name}."&i=".$a->{author_icon_num}."\" width=\"40\" height=\"50\"></td><td class=\"texttd\">";
	
	
	print $f "<b>",$a->{author},"</b> <a href=\"http://www.okoun.cz/boards/".$a->{clubname}."?contextId=".$a->{id}."#article-".$a->{id}."\">kon</a>, <a href=\"http://www.okoun.cz/boards/".$a->{clubname}."?rootId=".$a->{id}."#article-".$a->{id}."\">vlk</a><br>";
	
	print $f "<br>";
	print $f $a->{body};
	
	for my $sub (@{$a->{kids}}) {
		print_article($f, $sub);
	}
	print $f  "</td></tr></table>";
}

sub do_it {
	my ($c, $w) = @_;
	
	my @clusters = Okobot::BestArticle::all_best_articles($obot, $c, @clubs);


	open my $f, ">:utf8", $w;

	say $f "<html>
		<head>
		<link rel=\"stylesheet\" type=\"text/css\" href=\"styl.css\" />
		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">
			<title>okoun autokompresor</title>
		</head>
		<body>
		<h3>okoun autokompresor</h3>
		<a href=\"index.html\">sedmidenní</a> - <a href=\"index1.html\">dnešní</a> - <a href=\"info.html\">info</a>";
		
	say $f '
	<script language="javascript">
	function zobraz(id) {
		var ele = document.getElementById("bd"+id);
		var text = document.getElementById("sw"+id);
		if(ele.style.display == "block") {
		    		ele.style.display = "none";
				text.innerHTML = "zobraz";
		  	}
			else {
				ele.style.display = "block";
				text.innerHTML = "skryj";
			}
	}
	</script>
	';
		
	for my $cluster (@clusters) {
		my @arr = @{$cluster->{array}};
		my $article = $arr[0];
		
		
		print $f "<table class=\"ctable\"><tr><td class=\"icontd\"><img src=\"http://www.okoun.cz/ico/?l=".$article->{author_icon_name}."&i=".$article->{author_icon_num}."\" width=\"40\" height=\"50\"></td><td class=\"texttd\">";
		print $f "<b>",$article->{clubname},"</b> - velikost vlákna ",$cluster->{size};
		#say "value:", $_->{reply_value};
		print $f "<br><a href=\"javascript:zobraz(".$article->{id}.");\" id=\"sw".$article->{id}."\">zobraz</a><br>";
		print $f "<div id=\"bd".$article->{id}."\" style=\"display:none\">";
		#print $f $article->{body};
		
		for my $subarticle (@arr) {
			
			print_article($f, $subarticle);
			#print $f "<table class=\"ctable\"><tr><td class=\"icontd\"><img src=\"http://www.okoun.cz/ico/?l=".$subarticle->{author_icon_name}."&i=".$subarticle->{author_icon_num}."\" width=\"40\" height=\"50\"></td><td class=\"texttd\">";
			
			
			#print $f "<b>",$subarticle->{author},"</b> <a href=\"http://www.okoun.cz/boards/".$article->{clubname}."?contextId=".$article->{id}."#article-".$article->{id}."\">kon</a>, <a href=\"http://www.okoun.cz/boards/".$article->{clubname}."?rootId=".$article->{id}."#article-".$article->{id}."\">vlk</a><br>";
			
			#print $f "<br>";
			#print $f $subarticle->{body};
			#print $f  "</td></tr></table>";
		}
		
		print $f "</div>";
		#say "klub:", $_->{clubname};
		print $f  "</td></tr></table>";
	}

	say $f "</body></html>"
}




do_it($ARGV[0], "out/".$ARGV[1].".html");

say "OK!";





















