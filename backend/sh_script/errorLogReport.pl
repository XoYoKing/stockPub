#! /usr/bin/perl


$HOME = $ENV{HOME};
$env = $ENV{ENV};

`grep -i -n error $HOME/stocklogs/*>$HOME/lastday_stock_err_report.txt`;

my $time = shift || time();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
$year += 1900;
$mon ++;

$subject = $year."-".$mon."-".$mday."-懒人股票-错误报告_".$env;
print $subject."\n";

$filePath = "$HOME/lastday_stock_err_report.txt";

`node $HOME/stockPub/backend/utility/sendEmail.js $subject $filePath &`
