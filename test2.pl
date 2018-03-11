#!/usr/bin/perl


use 5.006;
use strict;
use warnings;

use utf8;
use HTML::WikiConverter;
use LWP::Simple;
use HTML::Entities;
binmode(STDOUT, ":utf8");

my $html=get("http://intra.driee-idf.i2/clouc.html");
if(! defined($html)){print "yes !!";}