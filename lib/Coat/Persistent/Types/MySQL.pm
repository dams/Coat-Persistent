package Coat::Persistent::Types::MySQL;

# MySQL types usable in has_p definitions 
# (either for isa or for store_as)

use strict;
use warnings;

use POSIX;
use Coat::Types;

# datetime' 

subtype 'MySQL:DateTime'
    => as 'Str'
    => where { /^\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d$/ };

coerce 'MySQL:DateTime'
    => from 'Int'
    => via { 
        my ($sec, $min, $hour, $day, $mon, $year) = localtime($_);
        $year += 1900;
        $mon++;
        $day = sprintf('%02d', $day);
        $mon = sprintf('%02d', $mon);
        $hour = sprintf('%02d', $hour);
        $min = sprintf('%02d', $min);
        $sec = sprintf('%02d', $sec);
        return "$year-$mon-$day $hour:$min:$sec";
    };

coerce 'Int'
    => from 'MySQL:DateTime'
    => via {
        my ($year, $mon, $day, $hour, $min, $sec) = /^(\d{4})-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)$/;
        $year -= 1900;
        $mon--;
        return mktime(~~$sec, ~~$min, ~~$hour, ~~$day, $mon, $year);
    };

# date

subtype 'MySQL:Date'
    => as 'Int'
    => where { /^\d{4}-\d\d-\d\d$/ };

coerce 'MySQL:Date'
    => from 'Int'
    => via { 
        my ($sec, $min, $hour, $day, $mon, $year) = localtime($_);
        $year += 1900;
        $mon++;
        $day = sprintf('%02d', $day);
        $mon = sprintf('%02d', $mon);
        return "$year-$mon-$day";
    };

coerce 'Int'
    => from 'MySQL:Date'
    => via {
        my ($year, $mon, $day) = /^(\d{4})-(\d\d)-(\d\d)$/;
        $year -= 1900;
        $mon--;
        return mktime(0, 0, 0, ~~$day, $mon, $year);
    };

# year 

subtype 'MySQL:Year'
    => as 'Int'
    => where { /^\d{4}$/ };

coerce 'MySQL:Year'
    => from 'Int'
    => via { 
        my ($sec, $min, $hour, $day, $mon, $year) = localtime($_);
        return $year += 1900;
    };

coerce 'Int'
    => from 'MySQL:Year'
    => via {
        my $year = $_;
        $year -= 1900;
        return mktime(0, 0, 0, 1, 0, $year);
    };

1;
