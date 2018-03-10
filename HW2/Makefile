parser: lex.yy.c y.tab.c
	gcc -o parser lex.yy.c y.tab.c -ly -lfl
lex.yy.c: lex.l
	lex lex.l
y.tab.c: parser.y
	yacc -v -d -t parser.y
