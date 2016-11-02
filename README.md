# BTC_Alarm
========
####A simple Bitcoin market value monitor and alarm.

BTC_Alarm consists of (so far) 2 programs and 1 text file.

bitcoin_price.pl finds the value of btc in USD and updates bitcoin_value.txt.

bitcoin_alarm.pl looks at bitcoin_value.txt and compares it to user-defined thresholds. If thresholds are met then it will proceed to email a warning to the user.
