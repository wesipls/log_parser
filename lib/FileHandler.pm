# Script for handling files if LogParser.pl target is a directory.

package FileHandler;

use strict;
use warnings;
use File::Basename;

sub get_files_in_directory {
    my ($directory) = @_;
    my @files;

    opendir(my $dh, $directory) or die "Cannot open directory $directory: $!";

    while (my $file = readdir($dh)) {
        next if $file =~ /^\./;
        my $full_path = "$directory/$file";
        push @files, $full_path if -f $full_path;
    }

    closedir($dh);

    return @files;
}

1;

