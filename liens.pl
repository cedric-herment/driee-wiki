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

# Recuperation des urls et chemins dans le fichier chemins.txt

chdir "C:\\Users\\cedric.herment\\Documents\\w2\\Wk3";
my @chemins;
open (CHEMIN,"chemins.txt") or die ("Erreur lors de l'ouverture du fichier chemins.txt : $!");
	my $i=0;
	while(my $ligne = <CHEMIN>){
		push @{ $chemins[$i] }, split (/,/, $ligne);
		$i+=1;
	}
close CHEMIN;

# Reconstruction des liens entre pages

for my $j (0 .. 499){
	
	# Chemin et ouverture du fichier
	print "url n $j: $chemins[$j][0]\n";
	open (FICHIER,"$chemins[$j][1].txt") or die ("Erreur lors de l'ouverture du fichier $chemins[$j][1].txt : $!");
		my @file = <FICHIER>;
	close(FICHIER);
	
	for my $ligne (@file){
	my @suburls = $ligne =~ /\[\[(.*?)\|/g;
	# if (defined($suburls[0])){print "suburl : $suburls[0]\n"};
		for my $i(0 .. $#suburls){
			my $dec=0;
			for my $k(0 .. $#chemins){
				if($suburls[$i] eq $chemins[$k][0] && $dec==0){
				# print "$ligne\n";
				$ligne =~ s/$suburls[$i]/wiki:$chemins[$k][2]/g;
				$dec=1;
				# print "$ligne\n";
				}
			}
			if($dec==0 && $j != 48){
				# print "$suburls[$i]\n";
				my $html=get("http://intra.driee-idf.i2/$suburls[$i]");
				if(defined($html)){
					$ligne =~ s/$suburls[$i]/http:\/\/intra.driee-idf.i2\/$suburls[$i]/g;
					}
			}
		}
	}

	open (FICHIER,">$chemins[$j][1].txt") or die ("Erreur lors de l'ouverture du fichier $chemins[$j][1].txt : $!");
		print FICHIER @file;
	close(FICHIER);
}




print "STOP";