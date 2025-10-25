use v5.34;
use strict;
use warnings;

use Test::More;
use Test::Exception;

# Setup
my $temp_dir = "/tmp/katon";
my $temp_test_dir = "$temp_dir/test";

# Check if the $temp_dir exists. Create it if it doesn't.
unless (-d $temp_dir) {
    mkdir $temp_dir or die "Could not create directory $temp_dir: $!";
}

# Check if $temp_test_dir exists. Create it if it doesn't.
unless (-d $temp_test_dir) {
    mkdir $temp_test_dir or die "Could not create directory $temp_test_dir: $!";
}

{
    my $out; 

    lives_ok { $out = `bin/katon` }
                    'Does not die';

    like $out, qr/(K|k)aton text replacement macroprocessor/,
                    'Displays summary when no arguments are given';

    lives_ok { $out = `bin/katon --help` }
                    'Does not die when --help is given';

    ok $out, 'Has output when --help is given';

    lives_ok { $out = `bin/katon -h` }
                    'Does not die when -h is given';

    ok $out, 'Has output when -h is given';
}

done_testing;


# Utility function to generate random strings
sub generate_random_string {
    my $len = shift;
    $len ||= 12;
    my $str = '';
    my @chars = ('a' .. 'z', 'A' .. 'Z', '0' .. '9');
    $str .=  $chars[ int(rand(@chars))] for(1..$len);
    return $str;
}


END {
    # Clean up here
}