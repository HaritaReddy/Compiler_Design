%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
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
		char type[10];
	} ;
extern struct node* symtable[53];
extern struct node* constable[53];
extern struct node* ptr;
extern int linecount;


void inserttype(char* type,char* name) //Inserts the token in symbol table
	{
		int pos=poscalc(name);
		

			int flag=0;
			struct node* check=symtable[pos];
			while(check!=NULL&&check->name!=name)
			{
				check=check->next;
			}
			
			strcpy(symtable[pos]->type,type);
	}

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

S: statement
|unaryst
;

ifelse :  IF '(' conditions ')' '{' code '}'
| IF '(' conditions ')'  S ';'
| IF '(' conditions ')' '{' code '}' ELSE '{' code '}'
|IF '(' conditions ')' S ';'  ELSE '{' code '}'
|IF '(' conditions ')' '{' code '}' ELSE A 
|IF '(' conditions ')' S ';' ELSE A
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
| TYPE ID  { inserttype($1,$2);}
| TYPE ID'='E { inserttype($1,$2);}
| STRUCT ID '{' declarations '}'
| STATEKW
| TYPE '*' ID {
				char point[20];
				strcpy(point,$1); strcat(point," pointer"); inserttype(point,$3);}
| TYPE '*' '*' ID {
				char point[20];
				strcpy(point,$1); strcat(point," double pointer"); inserttype(point,$4);}
| TYPE '*' ID '=' E {
				char point[20];
				strcpy(point,$1); strcat(point," pointer"); inserttype(point,$3);}
| TYPE '*' '*' ID '=' E {
				char point[20];
				strcpy(point,$1); strcat(point," double pointer"); inserttype(point,$4);}
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
	
	// set lex to read from it
	yyin = myfile;
	
	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));

	int j;
	printf("\n\n\n");
	printf("--SYMBOL TABLE--\n"); //Printing Symbol Table
	printf("\t\tName       Class         \t\tCount\tDataType\n\n");
	for(j=0;j<53;j++)
	{
		
		ptr=symtable[j];
		if(ptr==NULL)
		continue;
		printf("Position: %d\t",j);
		while(ptr!=NULL)
		{

			printf("%-10s %-15s\t\t%-2d\t",ptr->name,ptr->class,ptr->count);
			if(strlen(ptr->type)!=0)
			printf("%-20s",ptr->type);
			else
			printf("\t\t  ");
			printf("\t|");
			ptr=ptr->next;
		}
		printf("\n");
	}


	printf("\n\n");
	printf("--CONSTANT TABLE--\n"); //Printing Constant Table
	printf("\t\tConstant   Datatype\t\t\tCount\n\n");

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
