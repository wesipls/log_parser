package ConfigLoader;

use strict;
use warnings;

# Function to load configuration from a given file
sub load_config {
    my ($config_file) = @_;
    my %config;

    # Open the configuration file
    open(my $fh, '<', $config_file) or die "Could not open file '$config_file' $!";

    # Read each line of the configuration file
    while (my $line = <$fh>) {
        chomp $line;
        next if $line =~ /^\s*$/;  # Skip empty lines
        next if $line =~ /^\s*#/; # Skip comment lines

        # Parse key-value pairs
        if ($line =~ /^(\w+)=(.*)$/) {
            $config{$1} = $2;
            $config{$1} =~ s/^\s+//; # Remove leading whitespace
        }
    }

    close($fh);
    return %config;
}

1;

