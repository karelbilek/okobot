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

my @art = Okobot::BestArticle::all_best_articles($obot, 7, qw(komentare_k_aktualitam
obrazek%2C_pred_kterym_jsem_se_prave_vyhonil%28la%29.
jdu_na_kaficko
fotbal
text%2C_pred_kterym_jsem_se_prave_vyhonil%28la%29.
olol_fotomontaze_%3A%29%29
%22umi_kocka_couvat_%22_a_dalsi_dulezite_otazky
co_nas_sere
mate_doma_kocku_
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
okouni_blog) );
for (@art) {
	say "autor:", $_->{author};
	say "value:", $_->{reply_value};
	say "text:", $_->{body};
	say "klub:", $_->{clubname};
	say "------";
}