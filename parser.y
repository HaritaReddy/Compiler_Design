%token ID NUM
%left '+' '-'
%left '*' '/'
%{
	#include<stdio.h>
%}
%%
ED:E { printf("Valid Expression\n ");}
;
E : E'+'E {printf("Addition: %s  %s\n",$1,$3);}
|E'-'E {printf("s: %s  %s\n",$1,$3);}
|E'*'E {printf("m: %s  %s\n",$1,$3);}
|E'/'E {printf("d: %s  %s\n",$1,$3);}
|'('E')'
|ID 
|NUM
;
%%
void yyerror()
{
	printf("Invalid Expression\n");
}
int main()
{
	printf("Enter Expression:");
	//yylex();
    yyparse();
    return 0;
}
