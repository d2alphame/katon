#!/bin/perl
BEGIN {
    # Ensure we're using perl at least version 5.26
    if($] < 5.026) {
        print "Perl version at least 5.26 is required\n";
        return;
    }
}

use v5.26;          # Use Perl of at least this version

# Open a file handle to a temporary, anonymous file
open(my $tmp, "+>", undef) or die "Could not create temporary file";


my $var = qr/[a-zA-Z_][a-zA-Z0-9_]*/;                   # Regex for recognizing variable names
# my $quote = qr/"|'|`/;                                  # Regex for recognizing any of the 3 quoting characters

# Read all lines from all files passed as arguments from the command line
while(<>) {

    # Match, for example:
    # $x = 'My val' or 
    # $x = `My val`
    if(/^\s*(\$$var)\s*=\s*(['`])([^\2]+?)\2\s*$/) {
        say "my $1 = qq$2$3$2;";
        next;
    }
    # Match assigning with double-quotes character
    elsif(/^\s*(\$$var)\s*=\s*["]([^"]+?)"/) {
        say qq(my $1 = "$2";);
        next 
    }

}
