%{
#include <stdio.h>
struct treenode{
	char data[25];
	struct treenode* left;
	struct treenode* middle;
	struct treenode* right;
}tree[10];
struct node
	{
		char name[50];
		char class[50];
		int count;
		struct node* next;
	} ;
extern struct node* symtable[53];
extern struct node* constable[53];
extern struct node* ptr;
extern int linecount;
%}
%token ID NUM WHILE TYPE CHARCONST COMPARE PREPRO MAIN INT RETURN IF ELSE STRUCT UNARYOP STATEKW STRING 
%left '+' '-'
%left '*' '/'
%%
ED: program { printf("Parsing Successfully Completed (No error)\n"); }
;

program : PREPRO code main 
|main
;

main: TYPE MAIN '(' ')' '{' code return '}' 
;

return: RETURN '(' NUM ')' ';'
|RETURN  ';'
|RETURN  NUM ';'
|RETURN ID ';'
|
;

code: code A
|
;

A: whileloop 
|statement ';'
|ifelse
|function
|unaryst ';'
;

whileloop : WHILE '(' E ')' '{' code '}'
|WHILE '(' statement ')' '{' code '}'
|WHILE '(' E COMPARE E ')' '{' code '}' 
;

conditions : E
|statement
|E COMPARE E
;

ifelse : IF '(' conditions ')' '{' code '}'
| IF '(' conditions ')'  statement ';'
| IF '(' conditions ')' '{' code '}' ELSE '{' code '}'
|IF '(' conditions ')' statement ';'  ELSE '{' code '}'
|IF '(' conditions ')' '{' code '}' ELSE statement ';'
|IF '(' conditions ')' statement ';' ELSE statement ';'
;

arguments: arguments ',' D
|D
|
;

D: TYPE ID
|ID
;

function : TYPE ID '(' arguments ')' '{' code return '}'
| ID '(' arguments ')' ';'
|TYPE ID '(' arguments ')' ';'
;

statement :ID'='E
| TYPE ID
| TYPE ID'='E 
| STRUCT ID '{' declarations '}'
| STATEKW
| TYPE '*' ID
| TYPE '*' '*' ID
| TYPE '*' ID '=' E
| TYPE '*' '*' ID '=' E
;

declarations: declarations B
|B
;

B: TYPE ID ';'
;

unaryst: UNARYOP ID 
| ID UNARYOP
;


E : E'+'E 
|E'-'E 
|E'*'E 
|E'/'E 
|'('E')'
|ID 
|NUM
|CHARCONST
|STRING
|ID '(' arguments ')' 
| UNARYOP ID 
| ID UNARYOP
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

	int j;
	printf("\n\n\n");
	printf("--SYMBOL TABLE--\n"); //Printing Symbol Table
	for(j=0;j<53;j++)
	{
		
		ptr=symtable[j];
		if(ptr==NULL)
		continue;
		printf("Position: %d\t",j);
		while(ptr!=NULL)
		{

			printf("%-10s %-15s\t\t%-2d|\t",ptr->name,ptr->class,ptr->count);
			ptr=ptr->next;
		}
		printf("\n");
	}


	printf("\n\n");
	printf("--CONSTANT TABLE--\n"); //Printing Constant Table
	for(j=0;j<53;j++)
	{
		
		ptr=constable[j];
		if(ptr==NULL)
		continue;
		printf("Position: %d\t",j);
		while(ptr!=NULL)
		{

			printf("%-10s %-15s\t\t%-2d|\t",ptr->name,ptr->class,ptr->count);
			ptr=ptr->next;
		}
		printf("\n");
	}
	
}
yyerror(char *s) {
	printf("Parsing Unsuccessful Due to Syntax Error\n");
	printf("Error in line: %d\n",linecount+1);
}