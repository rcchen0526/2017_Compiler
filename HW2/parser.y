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
program		: programname SEMICOLON programbody END IDENT
		;

programname	: identifier
		;

identifier	: IDENT
		;

programbody	: var_list fun_list com
		;

var_list	: 
			| nonEmpVar
			;

nonEmpVar	: nonEmpVar varible
			| varible
			;

fun_list	: 
			| nonEmpFun
			;

nonEmpFun	: nonEmpFun function
			| function
			;

function	: IDENT '(' argument ')' opt_type SEMICOLON com END IDENT
			;

opt_type 	: ':' TYPE_ALL
			| 
			;

TYPE_ALL 	: TYPE
			| array_type
			;

argument 	: 
			| nonEmpArg
			;

nonEmpArg 	: nonEmpArg SEMICOLON arg
			| arg
			;

arg			: id_list ':' TYPE_ALL
			;

id_list 	: 
			| nonEmpId
			;

nonEmpId 	: nonEmpId ',' IDENT
			| IDENT
			;

varible 	: VAR id_list ':' TYPE SEMICOLON
			| VAR id_list ':' array_type SEMICOLON
			| VAR id_list ':' literal SEMICOLON
			;

array_type  : ARRAY INT TO INT OF TYPE_ALL
			;
num 		: OCT
			| INT
			| FLOAT
			| SCI
			;

bool 		: TURE
			| FALSE
			;

literal 	: num
			| '-' num
			| STRING
			| bool
			;

com 		:BG var_list statment_c END
			;

statment_c 	: 
			| nonEmpStat
			;

nonEmpStat 	: nonEmpStat statment
			| statment
			;

statment 	: com
			| simple
			| cond
			| while
			| for
			| return
			| function_in
			;

simple 		: var_ref ASSIGN bool_expre SEMICOLON
			| PRINT var_ref SEMICOLON
			| PRINT bool_expre SEMICOLON
			| READ var_ref SEMICOLON
			;

var_ref 	: IDENT 
			| array_ref
			;

array_ref 	: 
			|  array_ref '[' int_expre ']'
			;

bool_expre 	: bool_expre opraterB int_expre
			| int_expre
			;

opraterB 	: OR
			| AND
			| NOT
			| '>'
			| '<'
			| '='
			| NE
			| LE
			| GE
			;

int_expre 	: int_expre opraterI term
			| term
			;

opraterI 	: '+'
			| '-'
			| '*'
			| '/'
			| MOD
			;

term 		: var_ref
			| '-' var_ref
			| '(' bool_expre ')'
			| '-' '(' bool_expre ')'
			| IDENT '(' expre_list ')'
			| '-' IDENT '(' expre_list ')'
			| literal
			;

function_in : IDENT '(' expre_list ')' SEMICOLON
			;

expre_list  : expre_list ',' bool_expre
			| bool_expre
			;

cond 		: IF bool_expre THEN statment_c cond_tmp END IF
			;

cond_tmp 	: ELSE statment_c
			|
			;

while 		: WHILE bool_expre DO statment_c END DO
			;

for 		: FOR IDENT ASSIGN INT TO INT DO statment_c END DO
			;

return 		: RETURN bool_expre SEMICOLON
			;

%%

int yyerror( char *msg )
{
        fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
	fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
	fprintf( stderr, "|\n" );
	fprintf( stderr, "| Unmatched token: %s\n", yytext );
        fprintf( stderr, "|--------------------------------------------------------------------------\n" );
        exit(-1);
}
