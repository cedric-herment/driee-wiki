#!/usr/bin/perl

#Récupération propres des url

use 5.006;
use strict;
use warnings;

use utf8;
use HTML::WikiConverter;
use LWP::Simple;

open(FICHIER,"plan du site.txt") or die ("Erreur lors de l'ouverture du fichier plan du site.txt");
my $ligne= <FICHIER>;
my @urls = $ligne =~ /href=\"(.*?)\"/g;
close(FICHIER);

my @urlsvf=@urls;
for my $url(@urls){
	my $html=get("http://intra.driee-idf.i2/$url");
	print "page $url chargée\n";
	# my @html2 = $html =~ /publi&eacute;(.*)Haut/s;
	my @html2 = $html =~ /(id\=\"boxcentrale.*)href\=\"#entete/s;
	my @suburls = $html2[0] =~ /href=\"(.*html?)\"/g;
	for my $suburl(@suburls){
		my $i=0;
		for my $urlvf(@urlsvf){
			if($urlvf eq $suburl){$i=1;}
			}
		if($i==0){push(@urlsvf,$suburl)};
		}
	}
	
open(FICHIER,">urls du site2.txt") or die ("Erreur lors de l'ouverture du fichier urls du site.txt"); 
for my $urlvf(@urlsvf){print FICHIER "$urlvf\n";}
close (FICHIER);
print "STOP";