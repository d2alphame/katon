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

my $declarations = "";                                  # Save declarations here as we find them
my $code_blocks = "";                                   # Save code blocks here.
my $var = qr/[a-zA-Z_][a-zA-Z0-9_]*/;                   # Regex for recognizing variable names
my $assign = qr/$var\s*=\s*(['"`]).+?\1/;               # Match assigning values


# Read all lines from all files passed as arguments from the command line
while(<>) {

    # Match, for example:
    # x = 'My val' or 
    # x = `My val`
    if(/^\s*($var)\s*=\s*(['`])([^\2]+?)\2\s*$/) {
        $declarations .= 'my $' . "$1 = qq$2$3$2;\n";
        next;
    }
    # Match assigning with double-quotes character
    # Matches e.g. $x = "My Value"
    elsif(/^\s*($var)\s*=\s*["]([^"]+?)"\s*$/) {
        $declarations .= 'my $' . qq($1 = "$2";\n);
        next;
    }


    # Match for code-fence. Code fences are blocks of
    # literal Perl code
    if(/^\s*```\s*$/) {
        while(<>) {
           last if /^\s*```\s*$/;
           $declarations .= $_;
        }
        next;
    }


    # Match declare-and-assign inside a body of text
    # This is done with $(...), $<...>, $[...], ${...}
    # Any of the 4 brackets can be used and the assignment
    # goes between them
    if(/\$([\({<\[])/) {
        my $left_bracket = $1;
        my $right_bracket;
        if      ($1 eq '(') { $right_bracket = ')' }
        elsif   ($1 eq '<') { $right_bracket = '>' }
        elsif   ($1 eq '[') { $right_bracket = ']' }
        elsif   ($1 eq '{') { $right_bracket = '}' }

        if(/\$$left_bracket([^$right_bracket]+?)$right_bracket/) {
            
        }
    }

}

print $declarations;
