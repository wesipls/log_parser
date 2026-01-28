#!/usr/bin/perl

# Main script for parsing logs based on configuration settings
# This script uses configuration files and external parser scripts to parse either single files or all files in a directory.

use strict;
use warnings;

use Getopt::Long;
use lib 'lib'; # Add the path to the custom modules

# Importing custom modules
use ConfigLoader;  # For loading configurations from a file
use FileHandler;   # For handling file operations (directory traversal and file listing)
use ParserExecutor; # For executing parser scripts based on settings and input files

# Command-line options
my $config_file = 'parser.conf'; # Default configuration file name
my $file_to_parse = '';         # Variable to store the file or directory to parse

# Retrieve command-line options
GetOptions(
    "file=s"   => \$file_to_parse, # File or directory to parse, passed as --file=<filename>
    "config=s" => \$config_file    # Custom configuration file, passed as --config=<config_file>
) or die("Error in command line arguments\n");

# Load the configuration
# The configuration file is expected to follow a key=value structure.
my %config = ConfigLoader::load_config($config_file);

if (-d $file_to_parse) {
    # Handle input as a directory
    # Retrieve all files from the specified directory
    my @files = FileHandler::get_files_in_directory($file_to_parse);

    # Process each file using the parser executor module
    foreach my $file (@files) {
        ParserExecutor::execute_parser($config{'mode'}, \%config, $file);
    }
} else {
    # Handle input as a single file
    ParserExecutor::execute_parser($config{'mode'}, \%config, $file_to_parse);
}

# This script assumes that the external parser scripts ('single_line.awk' and 'multi_line.awk')
# are already created and properly located in the parsers/ directory.

__END__

