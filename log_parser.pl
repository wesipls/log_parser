#!/usr/bin/perl

use strict;
use warnings;

my %config;
use Getopt::Long;

my $config_file = 'parser.conf';
my $file_to_parse = '';
GetOptions(
    "file=s" => \$file_to_parse,
    "config=s" => \$config_file
) or die("Error in command line arguments\n");

open(my $fh, '<', $config_file) or die "Could not open file '$config_file' $!";
while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/;
    next if $line =~ /^\s*#/;
    if ($line =~ /^(\w+)=(.*)$/) {
                $config{$1} = $2;
                $config{$1} =~ s/^\s+//;
    }
}
close($fh);

if ($config{'mode'} eq 'single_line') {
    my $args = join(' ', map { "-v $_=\"$config{$_}\"" } grep { $_ ne 'mode' } keys %config);
    $args .= " $file_to_parse";
    system("perl parsers/single_line.awk $args");
} elsif ($config{'mode'} eq 'multi_line') {
    my $args = join(' ', map { "-v $_=\"$config{$_}\"" } grep { $_ ne 'mode' } keys %config);
    $args .= " $file_to_parse";
    system("perl parsers/multi_line.awk $args");
} else {
    die "Error: mode '$config{mode}' is not recognized. Please use 'mode=single_line' or 'mode=multi_line'.\n";
}


