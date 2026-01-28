# Parses configuration file and return key-value pairs as a hash.

package ConfigLoader;

use strict;
use warnings;

sub load_config {
    my ($config_file) = @_;
    my %config;

    open(my $fh, '<', $config_file) or die "Could not open file '$config_file' $!";

    while (my $line = <$fh>) {
        chomp $line;
        next if $line =~ /^\s*$/;
        next if $line =~ /^\s*#/;

        # Parse key-value pairs
        if ($line =~ /^(\w+)=(.*)$/) {
            $config{$1} = $2;
            $config{$1} =~ s/^\s+//;
        }
    }

    close($fh);
    return %config;
}

1;

