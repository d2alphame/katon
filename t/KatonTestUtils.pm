package KatonTestUtils;

use v5.34;
use strict;
use warnings;

# Setup
my $temp_dir = "/tmp/katon";
my $temp_test_dir = "$temp_dir/test";

sub import {

    # Check if the $temp_dir exists. Create it if it doesn't.
    unless (-d $temp_dir) {
        mkdir $temp_dir or die "Could not create directory $temp_dir: $!";
    }

    # Check if $temp_test_dir exists. Create it if it doesn't.
    unless (-d $temp_test_dir) {
        mkdir $temp_test_dir or die "Could not create directory $temp_test_dir: $!";
    }
}


# Delete the temporary folders and their contents
END {
    if(-d $temp_dir) {
        rmtree $temp_dir, { safe => 1, keep_root => 0 };
    }
}


1;