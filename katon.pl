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
# open(my $tmp, "+>", undef) or die "Could not create temporary file";

my $code_blocks = "";                                       # Save code blocks here.
my %placeholders;
my $var = qr/[a-zA-Z_][a-zA-Z0-9_]*/;                       # Regex for recognizing variable names
my $assignment = qr/($var)\s*=\s*(["'`])([^\2]+?)\2/;       # Match assignment with of the 3 allowed quotes


# Read all lines from all files passed as arguments from the command line
while(<>) {

    # Match of the 3 versions of assignment (in declaration)
    if(/^\s*$assignment\s*$/) {
        $placeholders{$1} = $3;
        next;
    }


    # Match for code-fence. Code fences are blocks of
    # literal Perl code
    if(/^\s*```\s*$/) {
        while(<>) {
           last if /^\s*```\s*$/;
        }
        next;
    }


    # Match blocks of raw text
    if(/^\s*'''\s*$/) {
        while(<>) {
            last if /^\s*'''\s*$/;
            print;
        }
        next;
    } 

    # Match dollar-substitution for place holders
    s/\$($var)/$placeholders{$1}/g;

    print;
}

