%token ID NUM OP
%{
	#include<stdio.h>
%}
%%
ED:E { printf("Valid Expression\n ");}
;
E : E OP E {printf("Addition: %s %s %s\n",$1,$2,$3);}
|E'-'E
|E'*'E
|E'/'E
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

