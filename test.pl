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
my $i=0;
my @chemin;

$chemin[$i]=" evaluation-des-risques-et-donnees-historiques-a4877.html";

# Conversion chemin en url compatible
$chemin[$i] =~ tr/ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöùúûüýÿ/AAAAAACEEEEIIIINOOOOOUUUUYaaaaaaceeeeiiiinooooouuuuyy/;
$chemin[$i] =~ s/^ //g;
$chemin[$i] =~ s/ /_/g;
$chemin[$i] = lc($chemin[$i]);
$chemin[$i] =~ s/’/'/g;
$chemin[$i] =~ s/’/'/g;
# $chemin[$i] =~ s/•|▪|–|\*/-/g;
# $chemin[$i] =~ s/€/euros/g;
# $chemin[$i] =~ s/œ/oe/g;
# $chemin[$i] =~ s/\/|:|"|→/-/g;
print $chemin[$i];	
my $term =$wc->html2wiki( html => $chemin[$i], encoding => 'cp1252');
$term = decode_entities($term);
$term =~ s/&/et/g;
$term =~ s/[^a-zA-Z0-9_ -]*//g;
print "$term\n";
print "STOP";

my $html=get("http://intra.driee-idf.i2/$chemin[$i]");
my @html2 = $html =~ /id\=\"boxcentrale\".tabindex\=\"-1\">(.*)href\=\"#entete/s;
$html2[0] =~ s/href=\"IMG/href=\"http:\/\/intra\.driee-idf\.i2\/IMG/g;
$html2[0] =~ s/src=\'IMG/src=\'http:\/\/intra\.driee-idf\.i2\/IMG/g;
$html2[0] = decode_entities($html2[0]);
print $html2[0];
$html2[0] =~ s/’|’|“|”|‘/'/g;
$html2[0] =~ s/•|▪|–|—|\*|→|⇒/-/g;
$html2[0] =~ s/€/euros/g;
$html2[0] =~ s/‚/,/g;
$html2[0] =~ s/œ/oe/g;
$html2[0] =~ s/…/\.\.\./g;
my $wiki = $wc->html2wiki( html => $html2[0], encoding => 'cp1252');
print $wiki;

  