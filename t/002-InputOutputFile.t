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

my $outf1 = "output1.txt";
my $outf2 = "output2.txt";
my $outf3 = "output3.txt";

my $str1 = "Sample text string 1";
my $str2 = "Another example string 2\nWith a newline";
my $str3 = "Sample with final newline\n";

my $base_dir = create_files
    $file1 => $str1,
    $file2 => $str2,
    $file3 => $str3;


lives_ok {  $out = `bin/katon $base_dir/$file1`;
            die "$!" if $? >> 8;  } 
        'Runs without dying when given a file argument';

ok confirm_content($file1, $out), 
        'Echoes input file to stdout when no destination file is given';

dies_ok {   $out = `bin/katon non_existent_file.txt`; 
            die "$!" if($? >> 8) }
        'Dies when given a non-existent file argument';

dies_ok {  $out = `bin/katon $base_dir/$file1 -o`;
            die "$!" if($? >> 8) }
        'Dies when -o is given without destination file name';

dies_ok {  $out = `bin/katon $base_dir/$file1 --out`;
            die "$!" if($? >> 8) }
        'Dies when --out is given without destination file name';

lives_ok {  $out = `bin/katon $base_dir/$file2 --out $base_dir/$outf1`;
            die "$!" if $? >> 8;  }
        'Does not die when --out is given with destination file name';

lives_ok {  $out = `bin/katon $base_dir/$file3 -o $base_dir/$outf2`;
            die "$!" if $? >> 8;  }
        'Does not die when -o is given with destination file name';

done_testing;