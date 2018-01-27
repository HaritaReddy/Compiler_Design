%{
	#include<stdio.h>
	#include<string.h>
%}
%token ID NUM
%left '+' '-'
%left '*' '/'

%%
ED:E { printf("Valid Expression\n ");}
;
E : E '+' E {printf("Expression: %d + %d\n",$1,$3);
 			}
| E'-'E {printf("Expression: %d - %d\n",$1,$3); }
| E'*'E {printf("Expression: %d * %d\n",$1,$3) ;}
| E'/'E {printf("Expression: %d / %d\n",$1,$3) ;}
| '('E')' {printf("Expression: ( %s )\n",$1,$2,$3); } 
| NUM
| ID
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

