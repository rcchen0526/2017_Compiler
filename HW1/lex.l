%{
#define LIST               strcat(buf, yytext)
#define token(t)           {LIST; if (Opt_T) printf("<%s>\n", #t);}
#define tokenChar(t)       {LIST; if (Opt_T) printf("<%c>\n", (t));}
#define tokenInteger(t, i) {LIST; if (Opt_T) printf("<%s: %d>\n", #t, (i));}
#define tokenString(t, s)  {LIST; if (Opt_T) printf("<%s: %s>\n", #t, (s));}
#define tokenElse(t, s)      {LIST; if (Opt_T) printf("<%s: %s>\n", #t, (s));}
#define MAX_LINE_LENG      256

int Opt_S = 1;
int Opt_T = 1;
int linenum = 1;
char buf[MAX_LINE_LENG];
%}

letter    [a-zA-Z]
digit     [0-9]
oct       [0-7]+
int       0|[-]?[1-9][0-9]*
space     [ \t]+
id            {letter}({letter}|{digit})*
float         ({digit}+\.{digit}+)
scientific    (({digit}+|{float})[eE][+-]?{digit}+)

%Start COM
%%

"//&S+".*    {LIST; Opt_S=1; }
"//&S-".*    {LIST; Opt_S=0; }
"//&T+".*    {LIST; Opt_T=1; }
"//&T-".*    {LIST; Opt_T=0; }

<INITIAL>","          { tokenChar(','); }
<INITIAL>";"          { tokenChar(';'); }
<INITIAL>":"          { tokenChar(':'); }
<INITIAL>"("          { tokenChar('('); }
<INITIAL>")"          { tokenChar(')'); }
<INITIAL>"["          { tokenChar('['); }
<INITIAL>"]"          { tokenChar(']'); }
<INITIAL>"+"          { token(+); }
<INITIAL>"-"          { token(-); }
<INITIAL>"*"          { token(*); }
<INITIAL>"/"          { token(/); }
<INITIAL>"mod"        { token(mod); }
<INITIAL>":="         { token(:=); }
<INITIAL>"<"          { token(<); }
<INITIAL>"<="         { token(<=); }
<INITIAL>"<>"         { token(<>); }
<INITIAL>">="         { token(>=); }
<INITIAL>">"          { token(>); }
<INITIAL>"="          { token(=); }
<INITIAL>"and"        { token(and); }
<INITIAL>"or"         { token(or); }
<INITIAL>"not"        { token(not); }
<INITIAL>"array"      { token(KWarray); }
<INITIAL>"begin"      { token(KWbegin); }
<INITIAL>"boolean"    { token(KWboolean); }
<INITIAL>"def"        { token(KWdef); }
<INITIAL>"do"         { token(KWdo); }
<INITIAL>"else"       { token(KWelse); }
<INITIAL>"end"        { token(KWend); }
<INITIAL>"false"      { token(KWfalse); }
<INITIAL>"for"        { token(KWfor); }
<INITIAL>"integer"    { token(KWinteger); }
<INITIAL>"if"         { token(KWif); }
<INITIAL>"of"         { token(KWof); }
<INITIAL>"print"      { token(KWprint); }
<INITIAL>"read"       { token(KWread); }
<INITIAL>"real"       { token(KWbegin); }
<INITIAL>"string"     { token(KWstring); }
<INITIAL>"then"       { token(KWthen); }
<INITIAL>"to"         { token(KWto); }
<INITIAL>"true"       { token(KWtrue); }
<INITIAL>"return"     { token(KWreturn); }
<INITIAL>"var"        { token(KWvar); }
<INITIAL>"while"      { token(KWwhile); }
<INITIAL>{space}      {LIST; }
<INITIAL>"//".*       {LIST; }
<INITIAL>{id}            {tokenElse(id, yytext)}
<INITIAL>{int}           {tokenInteger(integer, atoi(yytext))}
<INITIAL>{float}         {tokenElse(float, yytext)}
<INITIAL>{oct}           {tokenElse(oct_integer, yytext)}
<INITIAL>{scientific}    {tokenElse(scientific, yytext)}
<INITIAL>\"([^\"|^"\n"]|\"{2}|\")*\"  {
  LIST;
  char s[yyleng];
  int i=0, j=0;
  for(;i<yyleng;++i){
    s[i]=yytext[i+j];
    if(yytext[i]=='\"'&&yytext[i+1]=='\"')
      ++j;
  }
  s[yyleng-1]='\0';
  char *outs=&s[1];
  tokenString(string,outs);
  buf[strlen(buf)-yyleng]='\0';
}
<INITIAL>.                {
  printf("error at line %d: bad character \"%s\"\n",linenum,yytext);
  exit(-1);
}
<INITIAL>"/*"        {LIST; BEGIN COM;}
<COM>.             {LIST; }
<COM>"*/"        {LIST; BEGIN INITIAL;}

<INITIAL>"\n"      {
          LIST;
          if (Opt_S)
            printf("%d: %s\n", linenum, buf);
          linenum++;
          buf[0] = '\0';
        }
<COM>"\n"      {
          LIST;
          if (Opt_S)
            printf("%d: %s\n", linenum, buf);
          linenum++;
          buf[0] = '\0';
        }

%%
int main( int argc, char **argv )
{
  if( argc != 2 ) {
    fprintf( stderr, "Usage: ./scanner [filename]\n" );
    exit(0);
  }
	
  FILE *fp = fopen( argv[1], "r" );
  if( fp == NULL ) {
    fprintf( stderr, "Open file error\n" );
    exit(-1);
  }
	
  yyin = fp;

  yylex();

  exit(0);
}
