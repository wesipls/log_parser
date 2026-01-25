#!/usr/bin/perl

use strict;
use warnings;

my %config;
my $config_file = 'parser.conf';
if (!-e $config_file) {
    $config_file = 'example_parser.conf';
}

open(my $fh, '<', $config_file) or die "Could not open file '$config_file' $!";
while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/;
    next if $line =~ /^\s*#/;
    if ($line =~ /^(\w+)=(.*)$/) {
        $config{$1} = $2; # Store key-value pairs in the hash
    }
}
close($fh);

foreach my $key (sort keys %config) {
    print "$key = $config{$key}\n";
}

