# HW1

In this assignment, we need to write a scanner for the P language in lex.

We are also required to write Makefile.

# Character Set

P programs are formed from ASCII characters. Control characters are not used in the language’s definition except ‘\n’ (new line) and ‘\t’ (horizontal tab).

# Lexical Definition

1.Tokens That Will Be Passed to the Parser

Example:

 comma , 
 
 semicolon ; 
 
 colon :
 
 parentheses ()
 
 square brackets []
 
2.Tokens That Will Be Discarded

Example:

C-style is text surrounded by “/*” and “*/” delimiters, which may span more than one line; 

C++-style is text following a “//” delimiter running up to the end of the line.

3.Each of these operators should be passed back to the parser as a token.

# How to Build and Execute?

% make

% ./scanner [input file]

# Platform : ubuntu 16.04
