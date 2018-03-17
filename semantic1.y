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

%token ID NUM WHILE TYPE CHARCONST COMPARE PREPRO MAIN INT RETURN IF ELSE STRUCT UNARYOP STATEKW STRING CC CO FLOAT CHAR STATIC AND OR
%left '+' '-'
%left '*' '/'
%%
ED: program { printf("Parsing Completed\n"); }
;

program : declarationlist
;

declarationlist : declarationlist declaration 
|declaration
;

declaration : vardeclaration
|fundeclaration
;

vardeclaration : typespecifier vardeclist   {printf("vardeclaration : %s %s\n",$1,$2);}
;

scopedvardeclaration : scopedtypespecifier vardeclist
;

vardeclist : vardeclist ',' vardecinitialize  
|vardecinitialize   {printf("vardeclist : %s\n",$1);}
;

vardecinitialize : vardecid   {printf("vardecinitialize : %s\n",$1);}
;

vardecid : ID   {printf("vardecid : %s\n",$1);}
|ID '[' NUM ']'
;

scopedtypespecifier : STATIC typespecifier
|typespecifier
;

typespecifier : returntypespecifier   {printf("typespeicifier : %s\n",$1);}
;

returntypespecifier: INT   {printf("\nreturntypespecifier : %s\n",$1);}
|FLOAT
|CHAR
;

fundeclaration: typespecifier ID '(' params ')' statement 
|ID '(' params ')' statement
;


params : paramlist
|
;

paramlist : paramlist ';' paramtypelist 
|paramtypelist
;

paramtypelist : typespecifier paramidlist
;

paramidlist: paramidlist ',' paramid
|paramid
;

paramid:ID
|ID '[' ']'
;

statement: expressionst
|compoundst
|selectionst
|iterationst
|returnst
|breakst
;

compoundst: CO localdeclarations statementlist CC
;

localdeclarations: localdeclarations scopedvardeclaration
|
;

statementlist: statementlist statement
|
;

expressionst: expression ';' 
|';'
;

selectionst: IF '(' simpleexpression ')' statement 
|IF '(' simpleexpression ')' statement ELSE statement
;

iterationst: WHILE '(' simpleexpression ')' statement
;

returnst: RETURN ';'
|RETURN expression ';'
;

breakst: STATEKW ';'
;

expression: mutable '=' expression
|mutable UNARYOP
|simpleexpression
;

simpleexpression: simpleexpression OR andexpression
|andexpression
;

andexpression: andexpression AND unaryrelexpression
|unaryrelexpression
;

unaryrelexpression: '!' unaryrelexpression
|relexpression
;

relexpression: sumexpression relop sumexpression
|sumexpression
;

relop : COMPARE
;

sumexpression: sumexpression sumop term
|term
;

sumop: '+'
|'-'
;

term: term mulop unaryexpression
|unaryexpression
;

mulop: '/'
|'*'
|'%'
;

unaryexpression: unaryop unaryexpression
|factor
;

unaryop: '-'
|'*'
|'?'
;

factor: mutable
|immutable
;

mutable: ID
|mutable '[' expression ']'
|mutable '.' ID
;

immutable: '(' expression ')' 
|call
|constant
;

call: ID '(' args ')'
;

args: arglist
;

arglist: arglist ',' expression
|expression
;

constant: NUM
|CHARCONST
|STRING
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
