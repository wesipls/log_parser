package ParserExecutor;

use strict;
use warnings;

# Function to execute a parsing script
sub execute_parser {
    my ($mode, $config, $file_path) = @_;

    # Ensure a valid mode is set
    unless ($mode eq 'single_line' || $mode eq 'multi_line') {
        die "Error: mode '$mode' is not recognized. Please use 'single_line' or 'multi_line'.\n";
    }

    # Build arguments string from configuration
    my $args = join(' ', map { "-v $_=\"$config->{$_}\"" } grep { $_ ne 'mode' } keys %{$config});
    $args .= " $file_path";

    # Execute the corresponding parser script
    if ($mode eq 'single_line') {
        system("perl parsers/single_line.awk $args");
    } elsif ($mode eq 'multi_line') {
        system("perl parsers/multi_line.awk $args");
    }
}

1;

