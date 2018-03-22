%{
	#include "y.tab.h"
	#include<stdlib.h>
	extern int yylval;
%}
WHILE "while"
ALPHA [A-Za-z]
DIGIT [0-9]
ID  {ALPHA}({ALPHA}|{DIGIT})*
%%
{WHILE} {return WHILE;}
{ID}   {yylval = strdup(yytext); return ID;}
{DIGIT}+ {yylval=atoi(yytext); return NUM;}
[ \t]  ;
\n     ;
.      return yytext[0];
%%