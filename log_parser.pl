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

if (-d $file_to_parse) {
    opendir(my $dh, $file_to_parse) or die "Cannot open directory $file_to_parse: $!";
    while (my $file = readdir($dh)) {
        next if ($file =~ /^\./); # Skip hidden files and directories (e.g., ., ..)
        my $full_path = "$file_to_parse/$file";
        next unless (-f $full_path); # Process only if it's a file

        if ($config{'mode'} eq 'single_line') {
            my $args = join(' ', map { "-v $_=\"$config{$_}\"" } grep { $_ ne 'mode' } keys %config);
            $args .= " $full_path";
            system("perl parsers/single_line.awk $args");
        } elsif ($config{'mode'} eq 'multi_line') {
            my $args = join(' ', map { "-v $_=\"$config{$_}\"" } grep { $_ ne 'mode' } keys %config);
            $args .= " $full_path";
            system("perl parsers/multi_line.awk $args");
        }
    }
    closedir($dh);
} else {
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
}


