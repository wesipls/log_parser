package FileHandler;

use strict;
use warnings;
use File::Basename;

# Function to retrieve all files in a directory
sub get_files_in_directory {
    my ($directory) = @_;
    my @files;

    # Open the directory
    opendir(my $dh, $directory) or die "Cannot open directory $directory: $!";

    while (my $file = readdir($dh)) {
        next if $file =~ /^\./; # Skip hidden files and directories (e.g., ., ..)
        my $full_path = "$directory/$file";
        push @files, $full_path if -f $full_path; # Add to list if it's a file
    }

    closedir($dh);

    return @files;
}

1;

