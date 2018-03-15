%{
	#include "y.tab.h"
	#include<stdlib.h>
	extern int yylval;
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
	struct node* symtable[53],*constable[53];
	struct node* ptr;
	int linecount=0;
	int poscalc(char* name) //Calculates position of token in symbol table( hash function)
	{ 
		int i,pos=0;
		for(i=0;i<strlen(name);i++)
		{
			pos=pos+name[i]; //ASCII values of chacacters added
		}
		pos=pos%53;
		return pos; //returns hash value

	}

	void insert(char* name,char* class) //Inserts the token in symbol table
	{
		int pos=poscalc(name);
		if(symtable[pos]==NULL) //If there is no element already at that index
		{
			symtable[pos]=(struct node*)malloc(sizeof(struct node));
			strcpy(symtable[pos]->name,name);

			strcpy(symtable[pos]->class,class);
			symtable[pos]->next=NULL;
		}
		else //Chaining is required
		{	
			int flag=0;
			struct node* check=symtable[pos];
			while(check!=NULL)
			{
				if(strcmp(check->name,name)==0) 
				{
				flag=1;
				break;
			}
				check=check->next;
			}
			if(flag==1)
			return;
			struct node* ptr=(struct node*)malloc(sizeof(struct node));
			strcpy(ptr->name,symtable[pos]->name);
			strcpy(ptr->class,symtable[pos]->class);
			ptr->next=symtable[pos]->next;
			strcpy(symtable[pos]->name,name);
			strcpy(symtable[pos]->class,class);
			symtable[pos]->next=ptr;

		}
	}

		int poscalccons(char* name) //Calculates position of constant in constant table( hash function)
		{
			int i,pos=0;
			for(i=0;i<strlen(name);i++)
			{
				pos=pos+name[i]; //ASCII values of chacacters added
			}
			pos=pos%53;
			return pos; //returns hash value

		}


	void insertincons(char* name,char* class) //Inserts token into constant table
	{
		int pos=poscalc(name);
		if(constable[pos]==NULL) //If there is no element already at that index
		{
			constable[pos]=(struct node*)malloc(sizeof(struct node));
			strcpy(constable[pos]->name,name);

			strcpy(constable[pos]->class,class);
			constable[pos]->next=NULL;
		}
		else //Chaining is required
		{	
			int flag=0;
			struct node* check=constable[pos];
			while(check!=NULL)
			{
				if(strcmp(check->name,name)==0) 
				{
				flag=1;
				break;
			}
				check=check->next;
			}
			if(flag==1)
			return;
			struct node* ptr=(struct node*)malloc(sizeof(struct node));
			strcpy(ptr->name,constable[pos]->name);
			strcpy(ptr->class,constable[pos]->class);
			ptr->next=constable[pos]->next;
			strcpy(constable[pos]->name,name);
			strcpy(constable[pos]->class,class);
			constable[pos]->next=ptr;
		}
	}
	int globalscope;

	void deleteoutofscope()
	{
		int i=0;
		for(i=0;i<53;i++)
		{

			struct node* temp=symtable[i];
			if(temp==NULL)
			continue;

			struct node* prev=temp;
			while(temp!=NULL)
			{
				if(temp->scope==globalscope&&temp==symtable[i])
				{
				symtable[i]=temp->next;
				free(temp);
				temp=symtable[i];
				}
				else if(temp->scope==globalscope)
				{
					prev->next=temp->next;
					struct node* temp1=temp;
					temp=temp->next;
					free(temp1);
				}
				else 
				{
					prev=temp;
					temp=temp->next;
				}
			}
		}
	}

	void printsymtable()
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

letter [a-zA-Z]
digit [0-9]
scomment [/][/].*[\n]
mcommentstart [/][*](.|\n)*[*][/]
WHILE "while"
PREPRO [#].+
MAIN ("main")
RETURN ("return")
IF ("if")
ELSE ("else")
STRUCT ("struct")
kw ("auto")|("case")|("const")|("default")|("do")|("double")|("enum")|("extern")|("for")|("goto")|("long")|("register")|("short")|("signed")|("sizeof")|("switch")|("typedef")|("union")|("unsigned")|("void")|("volatile")
STATEKW ("break")|("continue")
STATIC ("static")
FLOAT ("float")
CHAR ("char")
INT ("int")
ID [a-zA-Z][a-zA-Z0-9_]*
NUM (([0-9]+)|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)
CHARCONST [\'][a-zA-Z][\']
CO "{"
CC "}"
COMPARE [<>]|"<="|">="|"=="|"!="
UNARYOP "++"|"--"
STRING ["].*["]
AND "&&"
OR "||"



%%
[\t ] ;
[\n] {linecount++;}
{scomment} {linecount++;}
{mcommentstart} ;
{WHILE} { insert(yytext,"Keyword"); return WHILE;}
{PREPRO} {return PREPRO;}
{MAIN} {insert(yytext,"Keyword"); return MAIN;}
{RETURN} { insert(yytext,"Keyword"); return RETURN;}
{IF} {insert(yytext,"Keyword");return IF;}
{ELSE} {insert(yytext,"Keyword");return ELSE;}
{STRUCT} {insert(yytext,"Keyword");return STRUCT;}
{kw} {insert(yytext,"Keyword");printf("%s:Keyword\n",yytext);}
{STATEKW} {insert(yytext,"Keyword"); return STATEKW;}
{STATIC} {return STATIC;}
{INT} {return INT;}
{FLOAT} {return FLOAT;}
{CHAR} {return CHAR;}
{ID} { printf("id %s detected\n",yytext); yylval = strdup(yytext); return ID;}
{NUM} { insert(yytext,"Constant");
int isfloat=0; int i;
	for(i=0;i<yyleng;i++)
	{
		if(yytext[i]=='.')
		{
			isfloat=1;
			break;
		}
	}
	if(isfloat==1)
	insertincons(yytext,"float");
	else
	insertincons(yytext,"int");
yylval=strdup(yytext);
return NUM;}
{CHARCONST} {insert(yytext,"Character Constant");
insertincons(yytext,"character");
return CHARCONST;}
{CO} {globalscope++;
			printf("globalscope = %d\n",globalscope);
			printf("%s detected\n",yytext);
			printsymtable();return CO;}
{CC} {deleteoutofscope();
			printf("%s detected\n",yytext);

			 globalscope--;
			 printf("globalscope = %d\n",globalscope);
			 printsymtable(); return CC;}
{COMPARE} {//insert(yytext,"Comparison Operator");
			return COMPARE;}
{UNARYOP} {//insert(yytext,"Unary Operator");
			  return UNARYOP;}
{AND} {return AND;}
{OR} {return OR;}
{STRING} {insert(yytext,"String Constant");
insertincons(yytext,"string");return STRING; }
. return yytext[0];

%%  
