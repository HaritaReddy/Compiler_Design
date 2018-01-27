%{
	#include "y.tab.h"
	#include<stdlib.h>
	extern int yylval;
%}

letter [a-zA-Z]
digit [0-9]
ID {letter}({letter}|{digit})*
NUM {digit}+
OP [+]

%%
{ID} {yylval = strdup(yytext);
return ID;}
{OP} {yylval = strdup(yytext);
return OP;}
{NUM} {yylval=strdup(yytext);
   return NUM;}
. return yytext[0];
\n return 0;
%%  


