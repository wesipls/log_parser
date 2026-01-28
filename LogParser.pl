#!/usr/bin/perl

# Usage: ./LogParser.pl --file <file_or_directory> [--config <config_file>]
# Uses parser.conf by default if no config file is specified.
# Supports parsing single files or all files in a directory.
#
# Short script to parse log files and remove duplicate entries.
#
# If the output looks weird, check the configuration file for settings.
# If it still looks weird try running the awk parser scripts directly, instructions can be found in the awk script comments.
# If it still looks weird, there might be a bug, this program has been tested on a limited set of log files.
# You can open a github issue with the log file inlucded, or a pull reuest with a fix.

use strict;
use warnings;
use Getopt::Long;
use lib 'lib';
use ConfigLoader;
use FileHandler;
use ParserExecutor;

my $config_file = 'parser.conf';
my $file_to_parse = '';

GetOptions(
    "file=s"   => \$file_to_parse,
    "config=s" => \$config_file
) or die("Error in command line arguments\n");

my %config = ConfigLoader::load_config($config_file);

if (-d $file_to_parse) {
    my @files = FileHandler::get_files_in_directory($file_to_parse);
    foreach my $file (@files) {
        ParserExecutor::execute_parser($config{'mode'}, \%config, $file);
    }
} else {
    ParserExecutor::execute_parser($config{'mode'}, \%config, $file_to_parse);
}
