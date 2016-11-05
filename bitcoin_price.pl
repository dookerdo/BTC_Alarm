#!/usr/bin/perl -w
# Uses specific websites to pull latest bitcoin market price in USD.
# Prints amount to bitcoin_value.txt.
# Author: Zach L.

use LWP::Simple;
use FindBin '$Bin';

my $url1 = 'http://www.coindesk.com/price/';
my $url2 = 'http://www.coinbase.com/charts?locale=en';
my $content;
my $value = 0;
my $out_file = "$Bin/bitcoin_value.txt"; # Use script directory as base path.

my @all_values;

### URL1 ###
# Uses wget because coindesk does not like LWP useragent.
$content = `wget --quiet $url1 -O -`;
$content =~ m/bpi-value bpiUSD".\$(.+)..div/;
push(@all_values, $1);

### URL2 ###
# Coinbase accepts LWP useragent (thanks coinbase!)
$content = get($url2);
$content =~ m/1 BTC = \$(\d+\.\d+)/;
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
