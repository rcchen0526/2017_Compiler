%{
#include <stdio.h>
#include <stdlib.h>

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */
%}

%token SEMICOLON END IDENT
%token ',' ':' ')' '(' '[' ']' ASSIGN ARRAY BG TYPE DEF DO ELSE FALSE FOR 
%token IF OF PRINT READ THEN TO TURE RETURN VAR WHILE OCT INT FLOAT SCI STRING


%left OR
%left AND
%left NOT
%left  '<' LE '=' GE '>' NE
%left '+' '-'
%left '*' '/' MOD
%%
