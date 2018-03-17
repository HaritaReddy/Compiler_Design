%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct node
	{
		char name[50];
		char class[50];
		struct node* next;
		char type[10];
		int scope;
		char size[20];
		int defflag;
	} ;
extern struct node* symtable[53];
extern struct node* constable[53];
extern struct node* ptr;
extern int linecount;
extern int globalscope=0;

void insertvar(char* type,char* name) //Inserts the token in symbol table
	{
	printf("insertvar entered\n");
		int pos=poscalc(name);

		printf("posiiton calculated\n");
		struct node *temp=symtable[pos];

		if(symtable[pos]==NULL)
			{	
				symtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(symtable[pos]->name,name);
				strcpy(symtable[pos]->type,type);
				strcpy(symtable[pos]->class,"identifier");
				symtable[pos]->scope=globalscope;
				symtable[pos]->next=NULL;
				return;
			}
		while(temp->next!=NULL)
		{
			temp=temp->next;
		}

		  temp->next=(struct node*)malloc(sizeof(struct node));
				strcpy(temp->next->name,name);
				strcpy(temp->next->type,type);
				strcpy(temp->next->class,"identifier");
				temp->next->scope=globalscope;
				temp->next->next=NULL;
		
	}

int checkvar(char *name)
{
printf("checkvar entered\n");
	int pos=poscalc(name);
	
	struct node *temp=symtable[pos];
	while(temp!=NULL)
	{
		if(strcmp(temp->name,name)==0&&globalscope==temp->scope)
		{
			return 1;    //1=duplicate var
		}
		temp=temp->next;
	}

	return 0;   //0=no problem

}


int checkid(char *name)
{
	printf("checkid entered\n");
	int pos=poscalc(name);
	
	struct node *temp=symtable[pos];
	while(temp!=NULL)
	{
		if(strcmp(temp->name,name)==0&&globalscope>=temp->scope)
		{
			return 1;    //1=declared
		}
		temp=temp->next;
	}

	return -1;   //0=undeclared

}

void insertarray(char* type, char* name, char *size)
{

	printf("\n\nname: %s, TYPE : %s , size : %s \n\n",name, type, size);
	if(checkvar(name)==1)
	{
		printf("Array identifier already declared\n\n");
		return;
	}
	else
	{

		//Checking for array size less than 1
		if(size[0]=='0'|| size[0]=='-')
		{
			printf("Array Size is Less Than 1! Illegal Size\n");
			return;
		}

		int pos=poscalc(name);

		printf("posiiton calculated\n");
		struct node *temp=symtable[pos];

		if(symtable[pos]==NULL)
			{	
				symtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(symtable[pos]->name,name);
				strcpy(symtable[pos]->type,type);
				strcpy(symtable[pos]->class,"array");
				strcpy(symtable[pos]->size,size);
				symtable[pos]->scope=globalscope;
				symtable[pos]->next=NULL;
				printf("size at the pos: %s\n",symtable[pos]->size);
				return;
			}
		while(temp->next!=NULL)
		{
			temp=temp->next;
		}

		  temp->next=(struct node*)malloc(sizeof(struct node));
				strcpy(temp->next->name,name);
				strcpy(temp->next->type,type);
				strcpy(temp->next->class,"array");
				strcpy(temp->next->size,size);
				temp->next->scope=globalscope;
				temp->next->next=NULL;


	}
}

void insertfunc(char *type, char *name,int defflag)
{

	printf("insertfunction entered\n");
		int pos=poscalc(name);

		printf("posiiton calculated\n");
		struct node *temp=symtable[pos];

		if(symtable[pos]==NULL)
			{	
				symtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(symtable[pos]->name,name);
				strcpy(symtable[pos]->type,type);
				strcpy(symtable[pos]->class,"function");
				symtable[pos]->scope=globalscope;
				symtable[pos]->defflag=defflag;
				symtable[pos]->next=NULL;
				return;
			}
		while(temp->next!=NULL)
		{
			temp=temp->next;
		}

		  temp->next=(struct node*)malloc(sizeof(struct node));
				strcpy(temp->next->name,name);
				strcpy(temp->next->type,type);
				strcpy(temp->next->class,"function");
				temp->next->scope=globalscope;
				symtable[pos]->defflag=defflag;

				temp->next->next=NULL;
}

int checkdupfunc(char *name)
{
	int pos=poscalc(name);

	struct node *temp=symtable[pos];
	while(temp!=NULL)
	{
		if(strcmp(temp->name,name)==0&&globalscope==temp->scope&&temp->defflag==1)
		{
			return 1;    			//1=declared
		}
		temp=temp->next;
	}

	return -1;   					//-1=undeclared

}

void printsym()
{
	printf("\n\n\n");
	int j;
	printf("--SYMBOL TABLE--\n"); //Printing Symbol Table
	printf("\t\tName       Class         \t\tDataType\t\tSize\n\n");
	for(j=0;j<53;j++)
	{
		
		ptr=symtable[j];
		if(ptr==NULL)
		continue;
		printf("Position: %d\t",j);
		while(ptr!=NULL)
		{

			printf("%-10s %-15s\t\t",ptr->name,ptr->class);
			if(strlen(ptr->type)!=0)
			printf("%-20s",ptr->type);
			if(strlen(ptr->size)!=0)
					printf("%-10s",ptr->size);
			else
			printf("\t\t  ");
			printf("\t|");
			ptr=ptr->next;
		}
		printf("\n");
	}
}


%}
%token ID NUM WHILE TYPE CHARCONST COMPARE PREPRO MAIN INT RETURN IF ELSE STRUCT UNARYOP STATEKW STRING CC CO
%left '+' '-'
%left '*' '/'
%%
ED: program { printf("\n\n\n----------------------\t\t\t\tPARSING COMPLETED!\n"); }
;

program : PREPRO code main 
|main
;

main: TYPE MAIN '(' ')' compoundst
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
|compoundst 
;

compoundst: CO code CC
;

whileloop : WHILE '(' E ')' CO code CC  
|WHILE '(' statement ')' CO code CC
|WHILE '(' E COMPARE E ')' CO code CC 
;

conditions : E
|statement
|E COMPARE E
;

S: statement
|unaryst
;

ifelse :  IF '(' conditions ')' compoundst
| IF '(' conditions ')'  S ';'
| IF '(' conditions ')' compoundst ELSE compoundst
|IF '(' conditions ')' S ';'  ELSE compoundst
;

arguments: arguments ',' D   
|D
|
;

D: TYPE ID   
|ID
|TYPE
;

function : TYPE ID '(' arguments ')' CO code return CC  
| ID '(' arguments ')' ';'    
|TYPE ID '(' arguments ')' ';' {printf("\n\nARGUMENT LIST : %s %s\n\n",$4,$5);}  
;

statement :ID'='E  { if(checkid($1)==-1)
						printf("\n\n%s Undeclared\n\n\nm",$1);}
| TYPE ID  { printf("declaration done\n"); int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n\nDuplicate declaration of %s\n\n",$2); printsym();}
| TYPE ID'='E {if(checkvar($2)==0) insertvar($1,$2); else printf("\n\nDuplicate declaration of %s\n\n",$2); printsym(); }
| STRUCT ID CO declarations CC
| STATEKW
| TYPE ID '[' E ']' { printf("$4 : %s\n\n",$4);insertarray($1,$2,$4); printf("\n\narray ddetected\n\n");printsym();}
| TYPE ID '[' ']' {printf("Semantic Error! Array has no subscript.\n");}
;

declarations: declarations B
|B 
;

B: TYPE ID ';'  { printf("declaration done\n"); int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n\nDuplicate declaration of %s\n\n",$2);}
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
	FILE *myfile = fopen("test.c", "r");
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
	printf("\t\tName       Class         \t\tDataType\t\tSize\n\n");
	for(j=0;j<53;j++)
	{
		
		ptr=symtable[j];
		if(ptr==NULL)
		continue;
		printf("Position: %d\t",j);
		while(ptr!=NULL)
		{

			printf("%-10s %-15s\t\t",ptr->name,ptr->class);
			if(strlen(ptr->type)!=0)
			printf("%-20s",ptr->type);
			if(strlen(ptr->size)!=0)
					printf("%-10s",ptr->size);
			else
			printf("\t\t  ");
			printf("\t|");
			ptr=ptr->next;
		}
		printf("\n");
	}


	printf("\n\n");
	printf("--CONSTANT TABLE--\n"); //Printing Constant Table
	printf("\t\tConstant   Datatype\n\n");

	for(j=0;j<53;j++)
	{
		
		ptr=constable[j];
		if(ptr==NULL)
		continue;
		printf("Position: %d\t",j);
		while(ptr!=NULL)
		{

			printf("%-10s %-15s|\t",ptr->name,ptr->class);
			ptr=ptr->next;
		}
		printf("\n");
	}
	
}
yyerror(char *s) {
	printf("Parsing Unsuccessful\n");
	printf("Error in line: %d\n",linecount+1);
}
