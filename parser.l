%{
	#include "y.tab.h"
	#include<stdlib.h>
	extern int yylval;
%}

letter [a-zA-Z]
digit [0-9]
scomment [/][/].*[\n]
WHILE "while"
PREPRO [#].+
MAIN ("main")
RETURN ("return")
kw ("auto")|("break")|("case")|("const")|("continue")|("default")|("do")|("double")|("else")|("enum")|("extern")|("for")|("goto")|("if")|("long")|("register")|("short")|("signed")|("sizeof")|("static")|("struct")|("switch")|("typedef")|("union")|("unsigned")|("void")|("volatile")
DEC ("float")|("char")
INT ("int")
ID [a-zA-Z][a-zA-Z0-9_]*
NUM (([0-9]+)|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)
CHARCONST [\'][a-zA-Z][\']
COMPARE [<>]|"<="|">="|"=="


%%
[\n\t ] ;
{scomment} ;
{WHILE} {return WHILE;}
{PREPRO} {printf("%-20s : Preprocessor directive: \n",yytext); 
          return PREPRO;}
{MAIN} {return MAIN;}
{RETURN} {return RETURN;}
{kw} {printf("%s:Keyword\n",yytext);}
{DEC} {return DEC;}
{INT} {return INT;}
{ID} {yylval = strdup(yytext);
return ID;}
{NUM} {yylval=strdup(yytext);
   return NUM;}
{CHARCONST} {return CHARCONST;}
{COMPARE} {return COMPARE;}
. return yytext[0];

%%  
