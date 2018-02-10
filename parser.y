%{
#include <stdio.h>
struct treenode{
	char data[25];
	struct treenode* left;
	struct treenode* middle;
	struct treenode* right;
}tree[10];
%}

%token ID NUM WHILE DEC CHARCONST COMPARE PREPRO MAIN INT RETURN
%left '+' '-'
%left '*' '/'

%%
ED: program { printf("Program Started\n"); }
;

program : PREPRO main 
|main
;

main: INT MAIN '(' ')' '{' code return '}' { printf("Main Loop\n");}
;

return: RETURN '(' NUM ')' ';'
|RETURN  ';'
|RETURN  NUM ';'
|
;

code: code A
|
; 

A: whileloop 
|statement ';'
;

whileloop : WHILE '(' E ')' '{' code '}'
|WHILE '(' statement ')' '{' code '}'
|WHILE '(' E COMPARE E ')' '{' code '}' {printf("Comparison inside while\n");}
;



statement :ID'='E
| DEC ID
| DEC ID'='E { printf("Statement\n "); }
| INT ID
| INT ID'='E { printf("Statement\n "); }
;

E : E'+'E {printf("Addition: %s  %s\n",$1,$3); }
|E'-'E {printf("Subtraction: %s  %s\n",$1,$3);}
|E'*'E {printf("Multiplication: %s  %s\n",$1,$3);}
|E'/'E {printf("Division: %s  %s\n",$1,$3);}
|'('E')'
|ID 
|NUM
|CHARCONST
;
%%
#include <stdio.h>


extern int yylex();
extern int yyparse();
extern FILE *yyin;

main() {
	// open a file handle to a particular file:
	FILE *myfile = fopen("program.txt", "r");
	// make sure it is valid:
	
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
	
}

yyerror(char *s) {
	printf("invalid\n");
}
