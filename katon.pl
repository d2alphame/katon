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

my $quot_assign = qr/$var\s*=\s*"[^"]+?"/;              # Match assignment with quotes
my $apos_assign = qr/$var\s*=\s*'[^']+?'/;              # Match assignment with apostrophe
my $tick_assign = qr/$var\s*=\s*`[^`]+?`/;              # Match assignment with ticks

# Match any of the 3 quote assignments
my $any_quote_assign = qr/$quot_assign|$apos_assign|$tick_assign/;

my $brace_assign = qr/\$\{\s*$any_quote_assign\s*\}/;   # Match assignment with braces
my $squar_assign = qr/\$\[\s*$any_quote_assign\s*\]/;   # Match assignment with square brackets
my $angle_assign = qr/\$<\s*$any_quote_assign\s*>/;     # Match assignment with angular brackets
my $paren_assign = qr/\$\(\s*$any_quote_assign\s*\)/;   # Match assignment with parentheses

# Match any of the 4 bracket assignments
my $bracket_assign = qr/$brace_assign|$squar_assign|$angle_assign|$paren_assign/;


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


    if(/($bracket_assign)/) {
        print;
    }


}


# Sub routine for matching a variable name
sub match_var_name {

}


# Sub routine for matching declare-assign
sub match_declare_assign {

}
