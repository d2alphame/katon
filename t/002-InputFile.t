use v5.34;
use strict;
use warnings;

use Test::More;
use Test::Exception;

use FindBin;
use lib "$FindBin::Bin";
use KatonTestUtils;



my $out;
my $file1 = "input1.txt";
my $file2 = "input2.txt";
my $file3 = "input3.txt";

my $str1 = "Sample text string 1";
my $str2 = "Another example string 2\nWith a newline";
my $str3 = "Sample with final newline\n";

my $base_dir = create_files
    $file1 => $str1,
    $file2 => $str2,
    $file3 => $str3;


lives_ok {  $out = `bin/katon $base_dir/$file1`;
            die "$!" if $? >> 8;  } 
        'Runs when given a file argument and does not die';

ok confirm_content($file1, $out), 
        'Echoes input file to stdout when no destination file is given';

dies_ok {   $out = `bin/katon non_existent_file.txt` ; 
            die "$!" if($? >> 8) }
        'Dies when given a non-existent file argument';

dies_ok { }
    'Dies when '


done_testing;