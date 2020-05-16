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

my $declarations = "";                                      # Save declarations here as we find them
my $code_blocks = "";                                       # Save code blocks here.

my $var = qr/[a-zA-Z_][a-zA-Z0-9_]*/;                       # Regex for recognizing variable names
my $assignment = qr/($var)\s*=\s*(["'`])([^\2]+?)\2/;       # Match assignment with of the 3 allowed quotes


# Read all lines from all files passed as arguments from the command line
while(<>) {


    # Match of the 3 versions of assignment (in declaration)
    if(/^\s*$assignment\s*$/) {
        $declarations .= "my \$$1 = qq$2$3$2;\n";
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

    

    {
        # Match all 4 types of bracketed assignments
        # These are done thus:
        # $<...>, $(...), $[...], ${...}
        if(s/\$\{\s*$assignment\s*\}/\$$1/gc) {
            $declarations .= "my \$$1 = qq$2$3$2;\n";
            redo;
        }
        if(s/\$\[\s*$assignment\s*\]/\$$1/gc) {
            $declarations .= "my \$$1 = qq$2$3$2;\n";
            redo;
        }
        if(s/\$\(\s*$assignment\s*\)/\$$1/gc) {
            $declarations .= "my \$$1 = qq$2$3$2;\n";
            redo;
        }
        if(s/\$<\s*$assignment\s*>/\$$1/gc) {
            $declarations .= "my \$$1 = qq$2$3$2;\n";
            redo;
        }

        # Match evaluating Perl code.
        # Evaluating code can be done with one of the following
        # %(...), %{...}, %(...), %[...] The perl code
        # goes between the brackets.
        if(s/%\{([^\}]+?)\}/eval $1/egc) {
            redo;
        }
        if(s/%\[([^\]]+?)\]/eval $1/egc) {
            redo;
        }
        if(s/%\(([^\)]+?)\)/eval $1/egc) {
            redo;
        }
        if(s/%<([^>]+?)>/eval $1/egc) {
            redo;
        }
    }

    print;
}

print $declarations;