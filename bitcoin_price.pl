#!/usr/bin/perl -w
#use LWP::Simple;
# Uses coindesk.com to pull latest bitcoin market price in USD.
# Prints amount to bitcoin_value.txt.
# Author: Zach L.

my $url = 'http://www.coindesk.com/price/';
my $content;
my $value;
my $out_file = "bitcoin_value.txt";

## Some websites dislike the useragent that LWP uses (coindesk for instance)
## run lwpagent /or/ wgetit - not both.
#$content = get("http://www.coindesk.com/price/");
$content = `wget $url -O -`;

die "Couldn't get it!" unless defined $content;

$content =~ m/bpi-value bpiUSD".(.+)..div/;

$value = $1;

open(FILE, ">", $out_file) || die "can not open file";
print FILE $value;
close(FILE);
