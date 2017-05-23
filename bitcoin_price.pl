#!/usr/bin/perl -w
# Uses specific websites to pull latest bitcoin market price in USD.
# Prints amount to bitcoin_value.txt.
# Author: Zach L.

use LWP::Simple;
use FindBin '$Bin';
use feature say;

my $url1 = 'http://api.coindesk.com/v1/bpi/currentprice.json';
my $url2 = 'http://api.coinbase.com/v2/exchange-rates?currency=BTC';
my $content;
my $value = 0;
my $out_file = "$Bin/bitcoin_value.txt"; # Use script directory as base path.

my @all_values;

### URL1 ###
# Uses wget because coindesk does not like LWP useragent.
#$content = `wget --quiet $url1 -O -`;
$content = get($url1);
$content =~ m/36;","rate":"(.+)","description":"Unit/;
chomp($1);
$amt = $1;
$amt =~ s/,//;
$amt = sprintf "%.2f", $amt;
push(@all_values, $amt);

### URL2 ###
# Coinbase accepts LWP useragent (thanks coinbase!)
$content = get($url2);
$content =~ m/USD":"([^"]+)"/;
push(@all_values, $1);


# Sort array by value. Lowest is element 0. Highest is $#array
@all_values = sort {$a <=> $b} @all_values;
my $min_value = $all_values[0];
my $max_value = $all_values[$#all_values];

# If Highest value is more than 15% higher than smallest value, there's something wrong.
if( ($max_value - (($max_value/100.0)*15.0)) > $min_value){
	die("Bitcoin values are more than 15% appart.");
}

# Add all values together and find average.
foreach(@all_values){$value+=$_}
my $average_value = $value/(scalar(@all_values));
# Only 2 decimal places wanted.
$average_value = sprintf("%.2f", $average_value);

open(FILE, ">>", $out_file) || die "can not open file";
print FILE "$average_value " . localtime() . "\n";
close(FILE);
