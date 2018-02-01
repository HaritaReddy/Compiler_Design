%{
#include <stdio.h>
struct treenode{
	char data[25];
	struct treenode* left;
	struct treenode* middle;
	struct treenode* right;
}tree[10];
%}

%token ID NUM WHILE
%left '+' '-'
%left '*' '/'


%%
ED: whileloop { printf("WHILE LOOP\n ");}
;
whileloop : WHILE '(' E ')' '{' statement ';' '}'
|WHILE '(' statement ')' '{' statement ';' '}'
;

statement : statement ';' F
|F
;

F:ID'='E
|  { printf("Statement\n "); }
;

E : E'+'E {printf("Addition: %s  %s\n",$1,$3); }
|E'-'E {printf("s: %s  %s\n",$1,$3);}
|E'*'E {printf("m: %s  %s\n",$1,$3);}
|E'/'E {printf("d: %s  %s\n",$1,$3);}
|'('E')'
|ID 
|NUM
;
%%
#include <stdio.h>


extern int yylex();
extern int yyparse();
extern FILE *yyin;

main() {
	// open a file handle to a particular file:
	FILE *myfile = fopen("test.txt", "r");
	// make sure it is valid:
	
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
	
}

void yyerror(char *s) {
	printf("invalid\n");
}
