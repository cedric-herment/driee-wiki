#!/usr/bin/perl

use 5.006;
use strict;
use warnings;

use utf8;
use HTML::WikiConverter;
use LWP::Simple;
use HTML::Entities;
binmode(STDOUT, ":utf8");

my $wc = new HTML::WikiConverter( dialect => "DokuWiki", encoding => 'cp1252');

# Chargement des Urls

open(FICHIER,"urls du site.txt") or die ("Erreur lors de l'ouverture du fichier plan du site.txt");
my @urls = <FICHIER>;
close(FICHIER);

chdir "C:\\Users\\cedric.herment\\Documents\\w2\\wk2";

#MODIFICATION CHEMINS : OUI / NON

my $mc = 1;

if ($mc==1){open (CHEMIN,">chemins.txt") or die ("Erreur lors de l'ouverture du fichier chemins.txt : $!");}
	
for my $j (0 .. $#urls){
	
# Récupération du contenu et du chemin

	# Recuperation HTML
	
	my $url=$urls[$j];
	print "n $j / url : $url";
	my $html=get("http://intra.driee-idf.i2/$url");
	# print $html;
	
	# Recuperation du chemin

	my @filtre = $html =~ /Vous.&ecirc;tes.ici(.*?)<\/div><\/div>/s;
	my @chemin = $filtre[0] =~ />(.*?)<\/a>/g;
	# my @filename = $filtre[0] =~ /.*\&gt; (.*)/s;
	# print "filename : $filename[0]";
	#$filename[0] =~ s/[^a-zA-Z0-9_ -]*//g;
	# print "filename '$filename[0]'";
	# if ($filename[0] !~ /<\/a>/s) {push(@chemin, $filename[0]);}
	
	# print "$chemin[$#chemin]\n";
	#if ($title[0] ne $chemin[$#chemin] ) {push(@chemin, $title[0]);}
	
	my @title = $html =~ /<title>(.*) - DRIEE-IF Intranet<\/title>/s;
	if ($title[0] ne '' && $title[0] ne ' ') {push(@chemin, $title[0]);}
	# print "$title[0]\n";
	
	# Pré-traitement chemin
	my $l = 44 ;
	my $l2 = 0 ;
	for my $i (3 .. $#chemin){
		# Conversion chemin en url compatible
		$chemin[$i] =~ tr/ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöùúûüýÿ/AAAAAACEEEEIIIINOOOOOUUUUYaaaaaaceeeeiiiinooooouuuuyy/;
		$chemin[$i] =~ s/^ //g;
		$chemin[$i] =~ s/ $//g;
		$chemin[$i] =~ s/ – |– | –/-/g;
		$chemin[$i] =~ s/ /_/g;
		$chemin[$i] = lc($chemin[$i]);
		$chemin[$i] =~ s/’/'/g;
		$chemin[$i] =~ s/’/'/g;
		# print $chemin[$i];
		my $term =$wc->html2wiki( html => $chemin[$i], encoding => 'cp1252');
		$chemin[$i] = decode_entities($term);
		$chemin[$i] =~ s/&/et/g;
		$chemin[$i] =~ s/[^a-zA-Z0-9_ -]*//g;
		$chemin[$i] =~ s/_+/_/g;
		$l = $l + length($chemin[$i]) +1; 
	}
	if ($l > 259) 
		{
		my $marge = length($chemin[$#chemin])-($l-259);
		if ($marge>0)
			{
			$l2 = $l - length($chemin[$#chemin]);
			$chemin[$#chemin] = substr($chemin[$#chemin],0,length($chemin[$#chemin])-($l-259));
			$l2 = $l2 + length($chemin[$#chemin]);
			} 
		else {print "Pb de longueur de chaîne : $marge ";}
		}
	# print @chemin;
	# print "de taille $l2 \n";

	# Traitement du contenu
	
	my @html2 = $html =~ /id\=\"boxcentrale\".tabindex\=\"-1\">(.*)href\=\"#entete/s;
	$html2[0] =~ s/href=\"IMG/href=\"http:\/\/intra\.driee-idf\.i2\/IMG/g;
	$html2[0] =~ s/src=\'IMG/src=\'http:\/\/intra\.driee-idf\.i2\/IMG/g;
	$html2[0] = decode_entities($html2[0]);
	$html2[0] =~ s/’|’|“|”|‘/'/g;
	$html2[0] =~ s/•|▪|–|—|\*|→|⇒/-/g;
	$html2[0] =~ s/€/euros/g;
	$html2[0] =~ s/œ/oe/g;
	$html2[0] =~ s/‚/,/g;
	$html2[0] =~ s/…/\.\.\./g;
	# print $html2[0];
	$html2[0] =~ s/<div class=\"listerub\">/<div class=\"listerub\"><br>/g;
	$html2[0] =~ s/<div class=\"listeart\">/<div class=\"listeart\"><br>/g;
	
	# Suppression puces bizarres
	$html2[0] =~ s/{{plugins-dist\/cisquel\/puce.gif\?8x11\|\-}}/<br> -/g;
	
	my $wiki = $wc->html2wiki( html => $html2[0], encoding => 'cp1252');
	$wiki =~ s/\&gt;/>/g;
	$wiki =~ s/\&amp;/\&/g;
	# print $wiki;

	
	# Gestion des titres / liens
	$wiki =~ s/===== \[\[(.*)\|(.*)\]\] =====/===== $2 ===== \n \[\[$1\|$2\]\]/g;
	
	# Correction page pressing
	$wiki =~ s/pressings-r1552/nettoyage-a-sec-pressings-r413/g;
	# print $wiki;
	
	
# Enregistrement dans le dossier Wiki
	my $chemin_server = "";
	my $chemin_wiki = "";
	for my $i (3 .. $#chemin){
		# Ecriture du fichier
		if($i==$#chemin){
			open (FICHIER,">$chemin[$i].txt") or die ("Erreur lors de l'ouverture du fichier $chemin[$i].txt : $!");
				$chemin_server = $chemin_server."$chemin[$i]";
				$chemin_wiki = $chemin_wiki."$chemin[$i]";
				print FICHIER $wiki;
			close FICHIER;
			chdir "C:\\Users\\cedric.herment\\Documents\\w2\\wk2";
			chomp($urls[$j]);
			if ($mc==1){print CHEMIN "$urls[$j],$chemin_server,$chemin_wiki\n";}
			}
		else{
			if(-d $chemin[$i]){chdir $chemin[$i];} else {mkdir $chemin[$i]; print "$chemin[$i]\n"; chdir $chemin[$i];}
			$chemin_server = $chemin_server."$chemin[$i]\\";
			$chemin_wiki = $chemin_wiki."$chemin[$i]:";
			}
		}
}
if ($mc==1){close CHEMIN;}
print "STOP";

