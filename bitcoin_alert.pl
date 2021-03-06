#!/usr/bin/perl -s
# PROGRAM TO ALERT VIA EMAIL
# WHEN BITCOIN VALUE GOES HIGHER AND/OR LOWER THAN
# SPECIFIED AMOUNTS. 
# Author: Zach L.

### HOWTO ###
# Script can be invoked by perl interpreter or made executable via chmod.
# email variable can either be set in the script or overriden
# with command line option (via the -s option seen in the shebang above)
# Ex: perl bitcoin_alert.pl -email="anon@gmail.com"
#
# To change high/low values, it is prefered to edit the script manually.
# Command line arguments can be used, however;
# Ex: perl bitcoin_alert.pl -high_value="1000.00" -low_value="300.00"

### MODULES ###
use Mail::Sendmail;
use Sys::Hostname;


### VARIABLES ####
unless(defined($high_value)){ $high_value = "1000.00";} # Low btc price to alert. -1 for disable. USD.
unless(defined($low_value)){ $low_value = "200.00";}  # High btc price to alert. -1 for disable. USD.
my $value; # Current value of btc. Generated automatically by bitcoin_price.pl.
my $input_file = "bitcoin_value.txt";
unless(defined($email)){$email = 'someemail@somedomain.com';}
unless(defined($from_email)){$from_email = "" . getlogin() . "@" . hostname() . "";}
my $message = "script has malfunctioned.";

##################


### MAIN ###
open FH,"<",$input_file or die $!;
@value_all = <FH>;
$value = $value_all[-1]; # Get last line (most recent)
close FH;

$value =~ s/\$//; # Remove leading $ if present
$value =~ m/^(\d+.\d+)/; # Just get value from vale/date string.
$value = $1;

if (($value < $low_value) && ($low_value != "-1")){
	$message = "ALERT: Bitcoin has reached $value!\nIt is below your low value.";
	&alert_email;
}
elsif (($value > $high_value) && ($high_value != "-1")){
	$message = "ALERT: Bitcoin has reached $value!\nIt is above your high value.";
	&alert_email;
}
### END ###

### ALERT EMAIL
sub alert_email {
	my %mail = ( 
		To => "$email",
		From => $from_email,
		Subject => '==Bitcoin Alert==',
		Message => "$message",
	);
	sendmail(%mail) or die $Mail::Sendmail::error;
}
