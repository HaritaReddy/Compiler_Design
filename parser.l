%{
	#include "y.tab.h"
	#include<stdlib.h>
	extern int yylval;
%}

letter [a-zA-Z]
digit [0-9]
WHILE "while"
PREPRO [#].+
kw ("auto")|("break")|("case")|("const")|("continue")|("main")|("default")|("do")|("double")|("else")|("enum")|("extern")|("for")|("goto")|("if")|("long")|("register")|("return")|("short")|("signed")|("sizeof")|("static")|("struct")|("switch")|("typedef")|("union")|("unsigned")|("void")|("volatile")
DEC ("float")|("char")|("int")
ID [a-zA-Z][a-zA-Z0-9_]*
NUM {digit}+
CHARCONST [\'][a-zA-Z][\']
COMPARE [<>]|"<="|">="|"=="


%%
[\n\t ] ;
{WHILE} {return WHILE;}
{PREPRO} {printf("%-20s : Preprocessor directive: \n",yytext); 
          return PREPRO;}
{kw} {printf("%s:Keyword\n",yytext);}
{DEC} {return DEC;}
{ID} {yylval = strdup(yytext);
return ID;}
{NUM} {yylval=strdup(yytext);
   return NUM;}
{CHARCONST} {return CHARCONST;}
{COMPARE} {return COMPARE;}
. return yytext[0];

%%  
