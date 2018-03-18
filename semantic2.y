%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
struct node
	{
		char name[50];
		char class[50];
		struct node* next;
		char type[10];
		int scope;
		char size[20];
		int defflag;
		char *arg[5];
		char *argtype[5];
		int argcount;
	} ;
extern struct node* symtable[53];
extern struct node* constable[53];
extern struct node* ptr;
extern int linecount;
extern int globalscope=0;
char *arglist[5];
char *argtypelist[5];
int argindex=0;
int callargcount=0;

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

int checkidarray(char* name)
{
	int pos=poscalc(name);
	
	struct node *temp=symtable[pos];
	while(temp!=NULL)
	{
		if(strcmp(temp->name,name)==0&&globalscope>=temp->scope&&strcmp(temp->class,"array")==0)
		{
			return 1;    //1=declared
		}
		else if(strcmp(temp->name,name)==0&&globalscope>=temp->scope&&strcmp(temp->class,"array")!=0)
		return -1; //Normal identifier has subscript
		temp=temp->next;
	}

	return 0;   //0=undeclared

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
	int n=argindex;
	printf("insertfunction entered\n");
		int pos=poscalc(name);

		printf("posiiton calculated\n");
		struct node *temp=symtable[pos];
		int i;
		if(symtable[pos]==NULL)
			{	
				symtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(symtable[pos]->name,name);
				strcpy(symtable[pos]->type,type);
				strcpy(symtable[pos]->class,"function");
				symtable[pos]->scope=globalscope;
				symtable[pos]->defflag=defflag;
				for(i=n-1;i>=0;i--)
				{
					symtable[pos]->arg[n-1-i] = (char *)malloc(strlen(arglist[i])*sizeof(char));
					strcpy(symtable[pos]->arg[n-1-i],arglist[i]);
					symtable[pos]->argtype[n-1-i] = (char *)malloc(strlen(argtypelist[i])*sizeof(char));
					strcpy(symtable[pos]->argtype[n-1-i],argtypelist[i]);
				}
				symtable[pos]->argcount=n;
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
				temp->next->defflag=defflag;
				for(i=n-1;i>=0;i--)
				{
					temp->next->arg[n-1-i] = (char *)malloc(strlen(arglist[i])*sizeof(char));
					temp->next->argtype[n-1-i] = (char *)malloc(strlen(argtypelist[i])*sizeof(char));
					strcpy(temp->next->arg[n-1-i],arglist[i]);
					strcpy(temp->next->argtype[n-1-i],argtypelist[i]);
				}
				temp->next->argcount=n;
				temp->next->next=NULL;
}

int checkdupfunc(char *name)
{
	int pos=poscalc(name);

	struct node *temp=symtable[pos];
	while(temp!=NULL)
	{
		if(strcmp(temp->name,name)==0&&globalscope==temp->scope)
		{
			return 1;    			//1=duplicate declaration
		}
		temp=temp->next;
	}

	return 0;   					//0=okay to declaare and insert

}

int checkdupfuncdefinition(char *name)
{
	int pos=poscalc(name);

	struct node *temp=symtable[pos];
	while(temp!=NULL)
	{
		if(strcmp(temp->name,name)==0&&globalscope==temp->scope&&temp->defflag==1)
		{
			return 1;    			//1=duplicate declaration
		}
		else if(strcmp(temp->name,name)==0&&globalscope==temp->scope&&temp->defflag==0)
		{
			temp->defflag=1;
			return 0;    			//0=declared but not defined
		}
		temp=temp->next;
	}

	return -1;   					//-1=okay to declaare and insert

}



void insertparams(char *paramtype, char *param)
{
	arglist[argindex]=(char *)malloc(strlen(param)*sizeof(char));
	argtypelist[argindex]=(char *)malloc(strlen(paramtype)*sizeof(char));
	strcpy(arglist[argindex],param);
	strcpy(argtypelist[argindex],paramtype);
	argindex++;
}

int checkfuncdef(char* name)
{
	int pos=poscalc(name);
	struct node* temp=symtable[pos];
	int flag=0;
	if(symtable[pos]==NULL)
	return 0;
	while(strcmp(temp->name,name)!=0)
	{
	
	temp=temp->next;
	}
	if(temp==NULL)
	return 0;	
	if(strcmp(temp->class,"function")!=0)
	return -1;
	if(temp->defflag!=1)
	return 0;
	return 1;
}

int checknumarg(char* name)
{
	int pos=poscalc(name);
	struct node* temp=symtable[pos];
	int flag=0;
	if(symtable[pos]==NULL)
	return 0;
	while(strcmp(temp->name,name)!=0)
	{
	temp=temp->next;
	}	
	if(temp==NULL)
	return 0;
	if(strcmp(temp->class,"function")!=0||temp->defflag!=1)
	return 0;
	printf("Argument Count: %d\n",temp->argcount);
	if(temp->argcount!=callargcount)
	return 0;
	return 1;
	
}

void printsym()
{
	printf("\n\n\n");
	int j;
	int i;
	printf("--------------SYMBOL TABLE-----------------\n"); //Printing Symbol Table
	for(j=0;j<53;j++)
	{
		
		ptr=symtable[j];
		if(ptr==NULL)
		continue;
		printf("Position: %d\t",j);
		while(ptr!=NULL)
		{

			printf("Name:%s Class:%s",ptr->name,ptr->class);
			if(strlen(ptr->type)!=0)
			printf(" Type:%s ",ptr->type);
			if(strlen(ptr->size)!=0)
				printf(" Size%s",ptr->size);
			if(ptr->scope>=0)
				printf(" Scope:%d",ptr->scope);
			if(ptr->size)
				printf(" Size:%s",ptr->size);
			if(ptr->arg[0])
			{
				printf("Arguments : ");
				for(i=0;i<ptr->argcount;i++)
				{
					printf("%s %s, ",ptr->argtype[i],ptr->arg[i]);
				}
			}
			printf("|\t\t");
			ptr=ptr->next;
		}
		printf("\n");
	}

	printf("------------SYMBOL TABLE ENDED-----------------\n\n");
}



%}

%token ID NUM WHILE TYPE CHARCONST COMPARE PREPRO INT RETURN IF ELSE STRUCT UNARYOP STATEKW STRING CC CO FLOAT CHAR STATIC AND OR BREAK NEG
%left '+' '-'
%left '*' '/'

%%
ED: program
;

program: prepro declarationlist
;

prepro: prepro PREPRO
|
;

declarationlist: declarationlist declaration
|declaration
;

declaration: vardeclaration ';'
|statement 
|selectionst
|fundeclaration
|fundefinition
;

vardeclaration: typespecifier ID '=' simpleexpression  { printf("declaration done\n"); int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n\nDuplicate declaration of %s\n\n",$2); printsym();}

|typespecifier ID 			{ printf("declaration done\n"); int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n\nDuplicate declaration of %s\n\n",$2); printsym();}

|typespecifier ID '[' simpleexpression ']' '=' simpleexpression   { printf("$4 : %s\n\n",$4);insertarray($1,$2,$4); printf("\n\narray ddetected\n\n");printsym();}

|typespecifier ID '[' simpleexpression ']'   { printf("$4= %s $5 : %s  \n\n",$4,$5);insertarray($1,$2,$4); printf("\n\narray ddetected\n\n");printsym();}

| TYPE ID '[' ']' {printf("Semantic Error! Array has no subscript.\n");}

;




statement: ID '=' simpleexpression ';'			{ if(checkid($1)==-1)
									printf("\n\nError : %s Undeclared\n\n\n",$1);}
|ID '[' NUM ']' '=' simpleexpression ';'		
{int c=checkidarray($1); 
if(c==0)
	printf("\n\nError : %s Undeclared\n\n\n",$1);
else if(c==-1)
printf("Non array variable %s has a subscript!\n",$1);
}
|compoundst
|returnst
|breakst
|whileloop
|call ';'
|error
;

fundeclaration: typespecifier ID '(' params1 ')' ';'  { printf("I CAME TO FUNCDECLARATION\n"); 
if(checkdupfunc($2)==1)
	printf("\nError : Duplicate declaration of function %s\n",$2);
else 
{ 
insertfunc($1,$2,0);
}
argindex=0;
}
|typespecifier ID '('  ')' ';'    { printf("\nI CAME TO FUNCDECLARATION\n"); 
if(checkdupfunc($2)==1)
	printf("\nError : Duplicate declaration of function %s\n",$2);
else 
{ 
insertfunc($1,$2,0);
}
argindex=0;

}
;

fundefinition: typespecifier ID '(' params1 ')' CO declarationlist CC   { printf("\nI CAME TO FUNCDEFINITION\n"); 
if(checkdupfuncdefinition($2)==1)
	printf("\nError : Duplicate definition of function %s\n",$2);
else if(checkdupfuncdefinition($2)==0)
	 	;
else if(checkdupfuncdefinition($2)==-1)
{ 
insertfunc($1,$2,1);
}
argindex=0;
}
|typespecifier ID '(' ')' CO  declarationlist CC   { printf("\nI CAME TO FUNCDEFINITION\n"); 
if(checkdupfuncdefinition($2)==1)
	printf("\nError : Duplicate definition of function %s\n",$2);
else if(checkdupfuncdefinition($2)==0)
	 	;
else if(checkdupfuncdefinition($2)==-1)
{ 
insertfunc($1,$2,1);
}
argindex=0;
}
;


params1: typespecifier ID ',' params1   {printf("I CAME TO PARAMS1\n"); insertparams($1,$2); printf("%s %s\n", $1,$2);}
|typespecifier ID  {printf("I CAME TO PARAMS1\n"); insertparams($1,$2);printf("%s %s\n", $1,$2);}
;



typespecifier: INT
|FLOAT
|CHAR
;

selectionst: matchedst
|unmatchedst
;

matchedst: IF '(' simpleexpression ')' statement ELSE matchedst
|IF '(' simpleexpression ')' statement ELSE statement
;

unmatchedst: IF '(' simpleexpression ')' statement
|IF '(' simpleexpression ')' matchedst ELSE unmatchedst
|IF '(' simpleexpression ')' statement ELSE unmatchedst
;

whileloop: WHILE '(' simpleexpression ')' compoundst 
;

breakst:BREAK ';'
;

returnst: RETURN ';'     {printf("\nRETURN\n");}
|RETURN NUM ';'
|RETURN '(' simpleexpression ')' ';'
;

compoundst: CO declarationlist CC
| CO CC
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

relexpression: sumexpression COMPARE sumexpression   { if(checkid($1)==-1)
									printf("\n\nError : %s Undeclared\n\n\n",$1);
								if(checkid($3)==-1)
									printf("\n\nError : %s Undeclared\n\n\n",$3);}
|sumexpression   { if(checkid($1)==-1)
			printf("\n\nError : %s Undeclared\n\n\n",$1);}
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
|mutable '[' sumexpression ']' {int c=checkidarray($1); 
if(c==0)
	printf("\n\nError : %s Undeclared\n\n\n",$1);
else if(c==-1)
printf("Non array variable %s has a subscript!\n",$1);
}  
;

immutable: '(' sumexpression ')' 
|constant
|call
;


call: ID '(' args ')' { int f=checkfuncdef($1); printf("\n\nf=%d\n\n",f);
			if(f==0) printf("Error: Function %s not defined! Illegal Call!\n",$1);
			else if(f==-1) printf("Error: %s is not a function\n",$1);
else 
{
//Checking if number of parameters and arguments match
int c=checknumarg($1);
if(c==0)
printf("Error: Number of arguments in the function call don't match with definition!\n");
printf("Callargcount: %d\n",callargcount);
callargcount=0;
}
}
;

args: arglist
|
;

arglist: arglist ',' simpleexpression   {callargcount++;}
|simpleexpression {callargcount++;}
;


constant: NUM     
|CHARCONST
|STRING
;

%%

extern int yylex();
extern int yyparse();
extern FILE* yyin;

int main()
{
	
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
	printsym();

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
