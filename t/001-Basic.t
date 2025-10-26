use v5.34;
use strict;
use warnings;

use Test::More;
use Test::Exception;

use FindBin;
use lib "$FindBin::Bin";
use KatonTestUtils;


my $out; 

lives_ok { $out = `bin/katon` }
                'Does not die';

like $out, qr/(K|k)aton is a text replacement macroprocessor/,
                'Displays summary when no arguments are given';

lives_ok { $out = `bin/katon --help` }
                'Does not die when --help is given';

ok $out, 'Has output when --help is given';

lives_ok { $out = `bin/katon -h` }
                'Does not die when -h is given';

ok $out, 'Has output when -h is given';


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