%{
	#include "y.tab.h"
	#include<stdlib.h>
	extern int yylval;
%}

letter [a-zA-Z]
digit [0-9]
WHILE "while"
DEC ("float")|("char")|("int")
ID [a-zA-Z][a-zA-Z0-9_]*
NUM {digit}+
CHARCONST [\'][a-zA-Z][\']



%%
[\n\t ] ;
{WHILE} {return WHILE;}
{DEC} {return DEC;}
{ID} {yylval = strdup(yytext);
return ID;}
{NUM} {yylval=strdup(yytext);
   return NUM;}
{CHARCONST} {return CHARCONST;}
. return yytext[0];

%%  
