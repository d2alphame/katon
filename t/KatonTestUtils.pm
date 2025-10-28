package KatonTestUtils;

use v5.34;
use strict;
use warnings;

use File::Path;

# Setup
my $temp_dir = "/tmp/katon";
my $temp_test_dir = "$temp_dir/test";



# Takes a list of filename => content pairs and creates those files in
# $temp_test_dir. Returns the directory the files were created in.
sub create_files {
    my (%files) = @_;
    while (my ($filename, $content) = each %files) {
        open my $fh, '>', "$temp_test_dir/$filename"
            or die "Could not open file '$filename': $!";
        print $fh $content;
        close $fh;
    }
    return $temp_test_dir;
}



# Confirms the content of a file matches the expected content
sub confirm_content {
    my ($filename, $expected) = @_;
    open my $fh, '<', "$temp_test_dir/$filename"
        or die "Could not open file $filename: $!"; 
    my $content = do { local $/; <$fh> };
    return 1 if $content eq $expected;
    return 0;   
}



sub import {

    my $pkg = caller;

    # Check if the $temp_dir exists. Create it if it doesn't.
    unless (-d $temp_dir) {
        mkdir $temp_dir or die "Could not create directory $temp_dir: $!";
    }

    # Check if $temp_test_dir exists. Create it if it doesn't.
    unless (-d $temp_test_dir) {
        mkdir $temp_test_dir 
            or die "Could not create directory $temp_test_dir: $!";
    }

    {
        no strict 'refs';
        *{"$pkg" . "::create_files"} = \&create_files;
        *{"$pkg" . "::confirm_content"} = \&confirm_content;
    }
}

1;