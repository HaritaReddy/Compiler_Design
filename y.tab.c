/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "semantic4.y" /* yacc.c:339  */

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct treenode
{
	char nodeitem[20];
	char* children[20];
	int num_of_children;
};

struct treenode* root=NULL;

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
extern struct node* finalsymtable[53];
extern struct node* ptr;
extern int linecount;
extern int globalscope=0;
char *arglist[5];
char *argtypelist[5];
int argindex=0;
int callargcount=0;
int intindex=0;
int floatindex=0;
int charindex=0;

void insertvar(char* type,char* name) //Inserts the token in symbol table
	{
	printf("insertvar entered\n");
		int pos=poscalc(name);

		struct node *temp=symtable[pos];
		struct node *temp1=finalsymtable[pos];
		if(symtable[pos]==NULL)
			{	
				symtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(symtable[pos]->name,name);
				strcpy(symtable[pos]->type,type);
				strcpy(symtable[pos]->class,"identifier");
				symtable[pos]->scope=globalscope;
				symtable[pos]->next=NULL;
			}

		else 
		{
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

			if(finalsymtable[pos]==NULL)
			{	
				finalsymtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(finalsymtable[pos]->name,name);
				strcpy(finalsymtable[pos]->type,type);
				strcpy(finalsymtable[pos]->class,"identifier");
				finalsymtable[pos]->scope=globalscope;
				finalsymtable[pos]->next=NULL;
				return;
			}
		
		while(temp1->next!=NULL)
		{
			temp1=temp1->next;
		}
		  temp1->next=(struct node*)malloc(sizeof(struct node));
				strcpy(temp1->next->name,name);
				strcpy(temp1->next->type,type);
				strcpy(temp1->next->class,"identifier");
				temp1->next->scope=globalscope;
				temp1->next->next=NULL;
		
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

	printf("\n\n Array name: %s, TYPE : %s , size : %s \n\n",name, type, size);
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
			printf("%d Error: Array Size is Less Than 1! Illegal Size\n",linecount+1);
			return;
		}

		int pos=poscalc(name);

		struct node *temp=symtable[pos];
		struct node *temp1=finalsymtable[pos];
		if(symtable[pos]==NULL)
			{	
				symtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(symtable[pos]->name,name);
				strcpy(symtable[pos]->type,type);
				strcpy(symtable[pos]->class,"array");
				strcpy(symtable[pos]->size,size);
				symtable[pos]->scope=globalscope;
				symtable[pos]->next=NULL;
				printf("size at the pos (in symtable): %s\n",symtable[pos]->size);
			}
		else
		{
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
			if(finalsymtable[pos]==NULL)
			{	
				finalsymtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(finalsymtable[pos]->name,name);
				strcpy(finalsymtable[pos]->type,type);
				strcpy(finalsymtable[pos]->class,"array");
				strcpy(finalsymtable[pos]->size,size);
				finalsymtable[pos]->scope=globalscope;
				finalsymtable[pos]->next=NULL;
				printf("size at the pos(in finalsymtable): %s\n",finalsymtable[pos]->size);
				return;
			}
		
		while(temp1->next!=NULL)
		{
			temp1=temp1->next;
		}

		  temp1->next=(struct node*)malloc(sizeof(struct node));
				strcpy(temp1->next->name,name);
				strcpy(temp1->next->type,type);
				strcpy(temp1->next->class,"array");
				strcpy(temp1->next->size,size);
				temp1->next->scope=globalscope;
				temp1->next->next=NULL;



	}
}

void insertfunc(char *type, char *name,int defflag)
{
	int n=argindex;
	printf("insertfunction entered\n");
		int pos=poscalc(name);

		printf("posiiton calculated\n");
		struct node *temp=symtable[pos];
		struct node *temp1=finalsymtable[pos];
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
			}
		else
		{
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
		if(finalsymtable[pos]==NULL)
			{	
				finalsymtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(finalsymtable[pos]->name,name);
				strcpy(finalsymtable[pos]->type,type);
				strcpy(finalsymtable[pos]->class,"function");
				finalsymtable[pos]->scope=globalscope;
				finalsymtable[pos]->defflag=defflag;
				for(i=n-1;i>=0;i--)
				{
					finalsymtable[pos]->arg[n-1-i] = (char *)malloc(strlen(arglist[i])*sizeof(char));
					strcpy(finalsymtable[pos]->arg[n-1-i],arglist[i]);
					finalsymtable[pos]->argtype[n-1-i] = (char *)malloc(strlen(argtypelist[i])*sizeof(char));
					strcpy(finalsymtable[pos]->argtype[n-1-i],argtypelist[i]);
				}
				finalsymtable[pos]->argcount=n;
				finalsymtable[pos]->next=NULL;
				return;
			}
		
		while(temp1->next!=NULL)
		{
			temp1=temp1->next;
		}

		  temp1->next=(struct node*)malloc(sizeof(struct node));
				strcpy(temp1->next->name,name);
				strcpy(temp1->next->type,type);
				strcpy(temp1->next->class,"function");
				temp1->next->scope=globalscope;
				temp1->next->defflag=defflag;
				for(i=n-1;i>=0;i--)
				{
					temp1->next->arg[n-1-i] = (char *)malloc(strlen(arglist[i])*sizeof(char));
					temp1->next->argtype[n-1-i] = (char *)malloc(strlen(argtypelist[i])*sizeof(char));
					strcpy(temp1->next->arg[n-1-i],arglist[i]);
					strcpy(temp1->next->argtype[n-1-i],argtypelist[i]);
				}
				temp1->next->argcount=n;
				temp1->next->next=NULL;
}

void insertfuncvar(char *name,char *type)
{
	printf("insertvar entered\n");
		int pos=poscalc(name);

		printf("posiiton calculated\n");
		struct node *temp=symtable[pos];
		struct node *temp1=finalsymtable[pos];
		if(symtable[pos]==NULL)
			{	
				symtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(symtable[pos]->name,name);
				strcpy(symtable[pos]->type,type);
				strcpy(symtable[pos]->class,"identifier");
				symtable[pos]->scope=globalscope+1;
				symtable[pos]->next=NULL;
			}

		else 
		{
			while(temp->next!=NULL)
		{
			temp=temp->next;
		}
		temp->next=(struct node*)malloc(sizeof(struct node));
				strcpy(temp->next->name,name);
				strcpy(temp->next->type,type);
				strcpy(temp->next->class,"identifier");
				temp->next->scope=globalscope+1;
				temp->next->next=NULL;
		}

			if(finalsymtable[pos]==NULL)
			{	
				finalsymtable[pos]=(struct node*)malloc(sizeof(struct node));
				strcpy(finalsymtable[pos]->name,name);
				strcpy(finalsymtable[pos]->type,type);
				strcpy(finalsymtable[pos]->class,"identifier");
				finalsymtable[pos]->scope=globalscope+1;
				finalsymtable[pos]->next=NULL;
				return;
			}
		
		while(temp1->next!=NULL)
		{
			temp1=temp1->next;
		}
		  temp1->next=(struct node*)malloc(sizeof(struct node));
				strcpy(temp1->next->name,name);
				strcpy(temp1->next->type,type);
				strcpy(temp1->next->class,"identifier");
				temp1->next->scope=globalscope+1;
				temp1->next->next=NULL;
			
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
	insertfuncvar(param,paramtype);
	strcpy(argtypelist[argindex],paramtype);
	argindex++;
}

void insertargs(char *paramtype, char *param)
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

int checkifidisarray(char* name)
{
	int pos=poscalc(name);
	struct node* temp=symtable[pos];
	int flag=0;
	if(symtable[pos]==NULL)
	return 1;
	while(strcmp(temp->name,name)!=0)
	{
	temp=temp->next;
	}	
	if(temp==NULL)
	return 1;
	if(strcmp(temp->class,"array")==0)
	return 0;
	return 1;
}

int checktype(char* name)
{
	int pos=poscalc(name);
	struct node* temp=symtable[pos];
	int flag=0;
	if(symtable[pos]==NULL)
	return 1;
	while(strcmp(temp->name,name)!=0)
	{
	temp=temp->next;
	}	
	if(temp==NULL)
	return -1;
	if((temp->type)&&strcmp(temp->type,"int")==0)
	return 0;                                              //0=int
	else if((temp->type)&&strcmp(temp->type,"float")==0)
	return 1;											   //1=float	
	else if((temp->type)&&strcmp(temp->type,"char")==0)
	return 2;											// 2=char

	printf("so %s has type %s\n",name,temp->type);
	return 5;
}



int checkconsttype(char* name)
{
	int pos=poscalc(name);
	struct node* temp=constable[pos];
	int flag=0;
	if(constable[pos]==NULL)
	return 1;
	while(strcmp(temp->name,name)!=0)
	{
	temp=temp->next;
	}	
	if(temp==NULL)
	return -1;
	if((temp->type)&&strcmp(temp->type,"int")==0)
	return 0;
	else if((temp->type)&&strcmp(temp->type,"float")==0)
	return 1;
	else if((temp->type)&&strcmp(temp->type,"char")==0)
	return 2;
	return 5;
}

int checknofunctions()
{
	struct node *temp;
	int i;

	for(i=0;i<53;i++)
	{
		temp=finalsymtable[i];
		while(temp)
		{
			if(strcmp(temp->class,"function")==0)
				return 1;                                //1=at least 1 function defined
			else temp=temp->next;
		}
	}

	return 0;          //0=NO functions defined

}

int checktypearg(char* name)
{
 	printsym();
	int pos = poscalc(name);

	struct node *temp = symtable[pos];
	while(temp)
	{
		if(strcmp(temp->name,name)==0&&strcmp(temp->class,"Constant")!=0)
		{
			break;
		}
		else temp=temp->next;
	}
	int n = temp->argcount;
	int p;
	int i;
	for(i=0;i<n;i++)
	{
		p=poscalc(arglist[i]);
		struct node *temp1 = symtable[p];
		while(temp1)
		{
			if(strcmp(temp1->name,arglist[i])==0)
			{
				break;
			}
			else temp1=temp1->next;
		}

		struct node *temp2=constable[0];


		if(temp1==NULL)
		{
		printf("Entering constant table check\n");
		printconst();
			p=poscalc(arglist[i]);
			temp1 = constable[p];
			while(temp1)
			{
				if(strcmp(temp1->name,arglist[i])==0)
				{
					break;
				}
				else temp1=temp1->next;
			}
		}

		strcpy(argtypelist[i],temp1->type);
	}

	for(i=0;i<n;i++)
	{
		if(strcmp(argtypelist[i],temp->argtype[i])!=0)
			return -1;
	}
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

			printf("Name : %s, Class:%s",ptr->name,ptr->class);
			if(strlen(ptr->type)!=0)
			printf(" Type : %s ",ptr->type);
			
			if(ptr->scope>=0)
				printf(", Nesting level : %d",ptr->scope);
			if(strlen(ptr->size)!=0)
				printf(", Array dimension : %s",ptr->size);
			if(ptr->arg[0])
			{
				printf(", Arguments : ");
				for(i=0;i<ptr->argcount;i++)
				{
					printf(" %s %s, ",ptr->argtype[i],ptr->arg[i]);
				}
			}
			if(ptr->defflag)
				printf(", Definition flag : %d",ptr->defflag);
			printf("\t|\t");
			ptr=ptr->next;
		}
		printf("\n\n");
	}

	printf("------------SYMBOL TABLE ENDED-----------------\n\n");
}

void printconst()
{
int j;
printf("-------CONSTANT TABLE-------\n"); //Printing Constant Table
	printf("\t\tConstant   Datatype\n\n");

	for(j=0;j<53;j++)
	{
		
		ptr=constable[j];
		if(ptr==NULL)
		continue;
		printf("Position: %d\t",j);
		while(ptr!=NULL)
		{

			printf("%-10s %-15s|\t",ptr->name,ptr->type);
			ptr=ptr->next;
		}
		printf("\n");
	}
	printf("-------------------CONSTANT TABLE ENDED-------------\n");
}

void printfinalsym()
{
	printf("\n\n\n");
	int j;
	int i;
	printf("--------------FINAL SYMBOL TABLE-----------------\n"); //Printing Symbol Table
	for(j=0;j<53;j++)
	{
		
		ptr=finalsymtable[j];
		if(ptr==NULL)
		continue;
		printf("Position: %d\t",j);
		while(ptr!=NULL)
		{

			printf("Name : %s, Class:%s",ptr->name,ptr->class);
			if(strlen(ptr->type)!=0)
			printf(", Type : %s ",ptr->type);
			
			if(ptr->scope>=0)
				printf(", Nesting level : %d",ptr->scope);
			if(strlen(ptr->size)!=0)
				printf(", Array dimension : %s",ptr->size);
			if(ptr->arg[0])
			{
				printf(", Arguments : ");
				for(i=0;i<ptr->argcount;i++)
				{
					printf(", %s %s ",ptr->argtype[i],ptr->arg[i]);
				}
			}
			if(ptr->defflag)
				printf(", Definition flag : %d",ptr->defflag);
			printf("\t|\t");
			ptr=ptr->next;
		}
		printf("\n\n");
	}

	printf("------------FINAL SYMBOL TABLE ENDED-----------------\n\n");
}

#line 812 "y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ID = 258,
    NUM = 259,
    WHILE = 260,
    TYPE = 261,
    CHARCONST = 262,
    COMPARE = 263,
    PREPRO = 264,
    INT = 265,
    RETURN = 266,
    IF = 267,
    ELSE = 268,
    STRUCT = 269,
    UNARYOP = 270,
    STATEKW = 271,
    STRING = 272,
    CC = 273,
    CO = 274,
    FLOAT = 275,
    VOID = 276,
    CHAR = 277,
    STATIC = 278,
    AND = 279,
    OR = 280,
    BREAK = 281,
    NEG = 282
  };
#endif
/* Tokens.  */
#define ID 258
#define NUM 259
#define WHILE 260
#define TYPE 261
#define CHARCONST 262
#define COMPARE 263
#define PREPRO 264
#define INT 265
#define RETURN 266
#define IF 267
#define ELSE 268
#define STRUCT 269
#define UNARYOP 270
#define STATEKW 271
#define STRING 272
#define CC 273
#define CO 274
#define FLOAT 275
#define VOID 276
#define CHAR 277
#define STATIC 278
#define AND 279
#define OR 280
#define BREAK 281
#define NEG 282

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 917 "y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   265

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  42
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  37
/* YYNRULES -- Number of rules.  */
#define YYNRULES  90
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  162

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   282

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    39,     2,     2,     2,    40,     2,     2,
      36,    37,    30,    28,    38,    29,     2,    31,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    32,
       2,    33,     2,    41,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    34,     2,    35,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   752,   752,   755,   758,   759,   762,   763,   766,   767,
     768,   769,   770,   773,   796,   798,   802,   807,   811,   816,
     823,   844,   854,   855,   856,   857,   858,   861,   870,   882,
     920,   959,  1000,  1001,  1006,  1007,  1008,  1009,  1012,  1013,
    1016,  1022,  1030,  1036,  1042,  1050,  1056,  1059,  1060,  1061,
    1064,  1065,  1069,  1072,  1078,  1079,  1082,  1083,  1086,  1090,
    1093,  1094,  1097,  1098,  1101,  1102,  1105,  1106,  1107,  1110,
    1111,  1114,  1115,  1116,  1119,  1120,  1125,  1134,  1142,  1143,
    1146,  1150,  1192,  1193,  1196,  1197,  1200,  1201,  1204,  1216,
    1217
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "ID", "NUM", "WHILE", "TYPE",
  "CHARCONST", "COMPARE", "PREPRO", "INT", "RETURN", "IF", "ELSE",
  "STRUCT", "UNARYOP", "STATEKW", "STRING", "CC", "CO", "FLOAT", "VOID",
  "CHAR", "STATIC", "AND", "OR", "BREAK", "NEG", "'+'", "'-'", "'*'",
  "'/'", "';'", "'='", "'['", "']'", "'('", "')'", "','", "'!'", "'%'",
  "'?'", "$accept", "ED", "program", "prepro", "declarationlist",
  "declaration", "vardeclaration", "statement", "fundeclaration",
  "fundefinition", "params1", "typespecifier", "selectionst", "matchedst",
  "unmatchedst", "whileloop", "breakst", "returnst", "compoundst",
  "simpleexpression", "andexpression", "unaryrelexpression",
  "relexpression", "sumexpression", "sumop", "term", "mulop",
  "unaryexpression", "unaryop", "factor", "mutable", "immutable", "call",
  "args", "arglist", "simple", "constant", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,    43,    45,
      42,    47,    59,    61,    91,    93,    40,    41,    44,    33,
      37,    63
};
# endif

#define YYPACT_NINF -116

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-116)))

#define YYTABLE_NINF -50

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -116,    10,  -116,   182,  -116,  -116,    98,    -8,  -116,  -116,
      -2,   195,  -116,  -116,  -116,     4,   147,  -116,    35,  -116,
    -116,  -116,    88,  -116,  -116,  -116,  -116,  -116,  -116,    73,
      43,   115,   173,    43,    43,  -116,   217,  -116,  -116,  -116,
     176,  -116,    92,  -116,  -116,  -116,  -116,  -116,   113,    43,
    -116,    33,    83,  -116,  -116,    48,   144,  -116,   113,  -116,
      99,  -116,  -116,  -116,   101,  -116,  -116,   108,   100,  -116,
      -5,    24,  -116,    43,    13,     2,    46,  -116,    43,  -116,
      43,   113,  -116,  -116,   113,  -116,  -116,  -116,   113,  -116,
     113,   107,  -116,   173,   132,    84,   133,   127,   129,  -116,
       6,   151,   190,  -116,    83,  -116,   161,   144,  -116,    71,
      43,  -116,  -116,   159,   184,   186,   178,   191,   239,  -116,
      12,   168,  -116,    70,    43,   134,   207,    43,    43,   160,
     160,  -116,   103,  -116,    41,  -116,  -116,  -116,   187,  -116,
     133,   133,    23,   208,   160,   210,  -116,    85,    43,  -116,
      76,  -116,   212,  -116,   218,    56,  -116,  -116,    84,    84,
     219,   207
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       5,     0,     2,     0,     1,    26,     0,     0,     4,    34,
       0,     0,    35,    37,    36,     0,     0,     7,     0,     9,
      11,    12,     0,    10,    38,    39,    24,    23,    22,     0,
       0,     0,    83,     0,     0,    51,     0,    46,     6,     8,
      14,    25,    76,    88,    89,    90,    71,    72,     0,     0,
      73,     0,    53,    55,    57,    59,    61,    65,     0,    70,
      74,    75,    80,    79,     0,    87,    86,     0,    82,    85,
       0,     0,    50,     0,     0,     0,     0,    56,     0,    20,
       0,     0,    62,    63,     0,    67,    66,    68,     0,    69,
       0,     0,    81,     0,     0,     0,    13,     0,     0,    19,
       0,     0,     0,    78,    52,    54,    58,    60,    64,     0,
       0,    84,    45,     0,    42,     0,    18,    16,     0,    28,
       0,    33,    77,     0,     0,     0,     0,     0,     0,     0,
       0,    27,     0,    21,     0,    41,    40,    44,     0,    43,
      17,    15,     0,     0,     0,     0,    32,     0,     0,    47,
       0,    30,     0,    31,     0,     0,    48,    29,     0,     0,
      42,     0
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -116,  -116,  -116,  -116,    -9,   -15,  -116,   -90,  -116,  -116,
      93,   -69,  -116,   -88,  -107,  -116,  -116,  -115,   139,   -30,
     156,   -35,  -116,   -39,  -116,   157,  -116,   -47,  -116,  -116,
    -116,  -116,    -3,  -116,  -116,   152,  -116
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     3,    16,    17,    18,    19,    20,    21,
     101,    22,    23,    24,    25,    26,    27,   143,    28,    51,
      52,    53,    54,    55,    84,    56,    88,    57,    58,    59,
      60,    61,    62,    67,    68,    69,    63
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      29,    38,    36,    70,    71,   114,   102,   115,    29,    76,
       4,    89,     9,    29,    77,   145,    97,    98,   137,   139,
      78,    38,    12,    13,    14,   118,    42,    43,    33,   152,
      44,   130,    94,    29,    34,   135,    37,   136,   119,   100,
      45,   108,   106,    96,   131,   105,    42,    43,    99,    78,
      44,   109,    46,    47,   137,   149,    81,   154,    78,    48,
      45,    95,    49,   102,    50,    79,    78,    39,   135,   160,
     136,   115,    46,    47,    82,    83,    82,    83,   147,    48,
     123,    78,    49,   103,    50,     5,     5,     6,     6,     7,
       7,    40,    29,   159,   134,    78,   113,   140,   141,    82,
      83,    78,   133,    11,    11,    41,   122,    80,   156,   129,
      15,    15,   150,     9,    38,    29,    42,    43,   155,    64,
      44,   144,    29,    12,    13,    14,    29,    29,    32,    38,
      45,    30,    31,    90,    32,     5,    91,     6,    93,     7,
     110,    29,    46,    47,    29,    92,    10,    -3,     5,    48,
       6,    11,     7,    11,    50,    29,    29,     9,    78,    10,
      15,     5,   116,     6,   117,     7,    11,    12,    13,    14,
       9,   142,    10,    15,    85,    86,    65,    66,   -49,    11,
      12,    13,    14,     5,    87,     6,    15,     7,   120,    82,
      83,     8,     9,   121,    10,   124,     5,   125,     6,   126,
       7,    11,    12,    13,    14,     9,   132,    10,    15,    73,
      74,   127,    75,    35,    11,    12,    13,    14,     5,   138,
       6,    15,     7,   148,   128,   146,   151,     9,   153,    10,
     157,   158,   161,   112,   104,    72,    11,    12,    13,    14,
       5,   107,     6,    15,     7,   111,     0,     0,     0,     9,
       0,    10,     0,     0,     0,     0,     0,     0,    11,    12,
      13,    14,     0,     0,     0,    15
};

static const yytype_int16 yycheck[] =
{
       3,    16,    11,    33,    34,    95,    75,    95,    11,    48,
       0,    58,    10,    16,    49,   130,     3,     4,   125,   126,
      25,    36,    20,    21,    22,    19,     3,     4,    36,   144,
       7,    19,    37,    36,    36,   125,    32,   125,    32,    37,
      17,    88,    81,    73,    32,    80,     3,     4,    35,    25,
       7,    90,    29,    30,   161,    32,     8,   147,    25,    36,
      17,    37,    39,   132,    41,    32,    25,    32,   158,   159,
     158,   159,    29,    30,    28,    29,    28,    29,    37,    36,
     110,    25,    39,    37,    41,     1,     1,     3,     3,     5,
       5,     3,    95,    37,   124,    25,    12,   127,   128,    28,
      29,    25,    32,    19,    19,    32,    35,    24,    32,   118,
      26,    26,   142,    10,   129,   118,     3,     4,   148,     4,
       7,   130,   125,    20,    21,    22,   129,   130,    36,   144,
      17,    33,    34,    34,    36,     1,    35,     3,    38,     5,
      33,   144,    29,    30,   147,    37,    12,     0,     1,    36,
       3,    19,     5,    19,    41,   158,   159,    10,    25,    12,
      26,     1,    35,     3,    35,     5,    19,    20,    21,    22,
      10,    11,    12,    26,    30,    31,     3,     4,    18,    19,
      20,    21,    22,     1,    40,     3,    26,     5,    37,    28,
      29,     9,    10,     3,    12,    36,     1,    13,     3,    13,
       5,    19,    20,    21,    22,    10,    38,    12,    26,    33,
      34,    33,    36,    18,    19,    20,    21,    22,     1,    12,
       3,    26,     5,    36,    33,   132,    18,    10,    18,    12,
      18,    13,    13,    94,    78,    18,    19,    20,    21,    22,
       1,    84,     3,    26,     5,    93,    -1,    -1,    -1,    10,
      -1,    12,    -1,    -1,    -1,    -1,    -1,    -1,    19,    20,
      21,    22,    -1,    -1,    -1,    26
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    43,    44,    45,     0,     1,     3,     5,     9,    10,
      12,    19,    20,    21,    22,    26,    46,    47,    48,    49,
      50,    51,    53,    54,    55,    56,    57,    58,    60,    74,
      33,    34,    36,    36,    36,    18,    46,    32,    47,    32,
       3,    32,     3,     4,     7,    17,    29,    30,    36,    39,
      41,    61,    62,    63,    64,    65,    67,    69,    70,    71,
      72,    73,    74,    78,     4,     3,     4,    75,    76,    77,
      61,    61,    18,    33,    34,    36,    65,    63,    25,    32,
      24,     8,    28,    29,    66,    30,    31,    40,    68,    69,
      34,    35,    37,    38,    37,    37,    61,     3,     4,    35,
      37,    52,    53,    37,    62,    63,    65,    67,    69,    65,
      33,    77,    60,    12,    49,    55,    35,    35,    19,    32,
      37,     3,    35,    61,    36,    13,    13,    33,    33,    46,
      19,    32,    38,    32,    61,    49,    55,    56,    12,    56,
      61,    61,    11,    59,    46,    59,    52,    37,    36,    32,
      61,    18,    59,    18,    49,    61,    32,    18,    13,    37,
      49,    13
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    42,    43,    44,    45,    45,    46,    46,    47,    47,
      47,    47,    47,    48,    48,    48,    48,    48,    48,    48,
      49,    49,    49,    49,    49,    49,    49,    50,    50,    51,
      51,    51,    52,    52,    53,    53,    53,    53,    54,    54,
      55,    55,    56,    56,    56,    57,    58,    59,    59,    59,
      60,    60,    61,    61,    62,    62,    63,    63,    64,    64,
      65,    65,    66,    66,    67,    67,    68,    68,    68,    69,
      69,    70,    70,    70,    71,    71,    72,    72,    73,    73,
      73,    74,    75,    75,    76,    76,    77,    77,    78,    78,
      78
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     2,     0,     2,     1,     2,     1,
       1,     1,     1,     4,     2,     7,     5,     7,     5,     4,
       4,     7,     1,     1,     1,     2,     1,     6,     5,     9,
       8,     8,     4,     2,     1,     1,     1,     1,     1,     1,
       7,     7,     5,     7,     7,     5,     2,     2,     3,     0,
       3,     2,     3,     1,     3,     1,     2,     1,     3,     1,
       3,     1,     1,     1,     3,     1,     1,     1,     1,     2,
       1,     1,     1,     1,     1,     1,     1,     4,     3,     1,
       1,     4,     1,     0,     3,     1,     1,     1,     1,     1,
       1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 13:
#line 773 "semantic4.y" /* yacc.c:1646  */
    { printf("Declaration Done\n"); 
int type;
if(strcmp((yyvsp[-3]),"int")==0)
type=0; 
else if(strcmp((yyvsp[-3]),"float")==0)
type=1; 
else if(strcmp((yyvsp[-3]),"char")==0)
type=2;

printf("vardeclaration $4 : %d \n",(yyvsp[0]));
if(type==0&&((yyvsp[0])==1||(yyvsp[0])==2))
printf("%d Error: Expression on RHS must be of the type int!\n",linecount+1);
else if(type==1&&(yyvsp[0])==2)
printf("%d Error: Expression on RHS must be of the type float!\n",linecount+1);
else if(type==1&&((yyvsp[0])==0))
printf("%d Error: Expression on RHS contains INT type but type conversion happens to float!\n",linecount+1);
else if(type==2&&((yyvsp[0])==0||(yyvsp[0])==1))
printf("%d Error: Expression on RHS must be of the type char!\n",linecount+1);
intindex=0;
floatindex=0;
charindex=0;
int c; if(checkvar((yyvsp[-2]))==0) insertvar((yyvsp[-3]),(yyvsp[-2])); else printf("\n\n%d Error: Duplicate declaration of %s\n\n",linecount+1,(yyvsp[-2])); printsym();}
#line 2154 "y.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 796 "semantic4.y" /* yacc.c:1646  */
    { printf("declaration done\n"); int c; if(checkvar((yyvsp[0]))==0) insertvar((yyvsp[-1]),(yyvsp[0])); else printf("\n\n%d Error: Duplicate declaration of %s\n\n",linecount+1,(yyvsp[0])); printsym();}
#line 2160 "y.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 798 "semantic4.y" /* yacc.c:1646  */
    { if(checkconsttype((yyvsp[-3]))!=0) 
printf("%d Error: Expression must be of the type int!\n",linecount+1);
intindex=0;insertarray((yyvsp[-6]),(yyvsp[-5]),(yyvsp[-3])); printsym();}
#line 2168 "y.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 802 "semantic4.y" /* yacc.c:1646  */
    { printf("\n\narray detected %s\n\n",(yyvsp[-4]));
if(checkconsttype((yyvsp[-1]))!=0)  
printf("%d Error: Expression in subscript must be of the type int!\n",linecount+1);
intindex=0; insertarray((yyvsp[-4]),(yyvsp[-3]),(yyvsp[-1])); printf("\n\narray ddetected\n\n");printsym();}
#line 2177 "y.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 807 "semantic4.y" /* yacc.c:1646  */
    {if(checktype((yyvsp[-3]))!=0) 
printf("%d Error: Expression must be of the type int!\n",linecount+1);
intindex=0;insertarray((yyvsp[-6]),(yyvsp[-5]),(yyvsp[-3])); printsym();}
#line 2185 "y.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 811 "semantic4.y" /* yacc.c:1646  */
    { printf("\n\narray detected %s\n\n",(yyvsp[-4]));
if(checktype((yyvsp[-1]))!=0) 
printf("%d Error: Expression in subscript must be of the type int!\n",linecount+1);
intindex=0; insertarray((yyvsp[-4]),(yyvsp[-3]),(yyvsp[-1])); printf("\n\narray ddetected\n\n");printsym();}
#line 2194 "y.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 816 "semantic4.y" /* yacc.c:1646  */
    {printf("%d Error: Array has no subscript!\n",linecount+1);}
#line 2200 "y.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 823 "semantic4.y" /* yacc.c:1646  */
    {  
int type=checktype((yyvsp[-3])); 
printf("Type: %d\n",type);
if(type==0&&((yyvsp[-1])==1||(yyvsp[-1])==2))
	printf("%d Error: Expression on RHS must be of the type int! hshshssh\n",linecount+1);
else if(type==1&&((yyvsp[-1])==0||(yyvsp[-1])==2))
		printf("%d Error: Expression on RHS must be of the type float!\n",linecount+1);
else if(type==1&&((yyvsp[-1])==0))
		printf("%d Error: Expression on RHS contains INT type but type conversion happens to float!\n",linecount+1);
else if(type==2&&((yyvsp[-1])==1||(yyvsp[-1])==0))
		printf("%d Error: Expression on RHS must be of the type char!\n",linecount+1);

int p=checkifidisarray((yyvsp[-3])); 
if(p==0)
printf("%d Error: Array Identifier has no subscript!!\n",linecount+1);
else
{
if(checkid((yyvsp[-3]))==-1)
printf("%d Error: %s Undeclared!\n",linecount+1,(yyvsp[-3]));
}
}
#line 2226 "y.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 845 "semantic4.y" /* yacc.c:1646  */
    {
if((yyvsp[-1])==1||(yyvsp[-1])==2) 
printf("%d Error: Expression on RHS must be of the type int!\n",linecount);
int c=checkidarray((yyvsp[-6])); 
if(c==0)
	printf("\n\nError : %s Undeclared\n\n\n",(yyvsp[-6]));
else if(c==-1)
printf("%d Error: Non array variable %s has a subscript!\n",linecount,(yyvsp[-6]));
}
#line 2240 "y.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 861 "semantic4.y" /* yacc.c:1646  */
    { printf("Function Declaration\n"); 
if(checkdupfunc((yyvsp[-4]))==1)
	printf("%d Error: Duplicate Declaration of Function %s!\n",linecount+1,(yyvsp[-4]));
else 
{ 
insertfunc((yyvsp[-5]),(yyvsp[-4]),0);
}
argindex=0;
}
#line 2254 "y.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 870 "semantic4.y" /* yacc.c:1646  */
    { printf("\nFunction Declaration\n"); 
if(checkdupfunc((yyvsp[-3]))==1)
	printf("%d Error: Duplicate Declaration of Function %s!\n",linecount+1,(yyvsp[-3]));
else 
{ 
insertfunc((yyvsp[-4]),(yyvsp[-3]),0);
}
argindex=0;

}
#line 2269 "y.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 882 "semantic4.y" /* yacc.c:1646  */
    { printf("\nI Function Definition\n");  printf("returnst : %s\n",(yyvsp[-1]));  
int flag=0;
printf("typespecifier : %s\n",(yyvsp[-8]));
if((yyvsp[-1])){
	printf("enntered to check\n");

	if(strcmp((yyvsp[-8]),"void")==0)
		{
			printf("enntered to check2\n");

			printf("%d Error:Non void return type for void function\n",linecount);
			flag=1;
		}
} 

else
{
	if(strcmp((yyvsp[-8]),"int")==0)
		{
			printf("%d Error: Void return type for non void function\n",linecount);
			flag=1;
		}
}

if(flag==0)
{
if(checkdupfuncdefinition((yyvsp[-7]))==1)
	printf("%d Error: Duplicate Definition of Function %d!\n",linecount+1,(yyvsp[-7]));
else if(checkdupfuncdefinition((yyvsp[-7]))==0)
	 	;
else if(checkdupfuncdefinition((yyvsp[-7]))==-1)
{ 
insertfunc((yyvsp[-8]),(yyvsp[-7]),1);
}
}
argindex=0;
}
#line 2311 "y.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 920 "semantic4.y" /* yacc.c:1646  */
    { printf("\nFunction Definition\n");     printf("returnst : %s\n",(yyvsp[-1])); 
int flag=0;
printf("typespecifier : %s\n",(yyvsp[-7]));

if((yyvsp[-1]))
{	
	printf("enntered to check\n");
	if(strcmp((yyvsp[-7]),"void")==0)
		{
				printf("enntered to check2\n");

			printf("%d Error:Non void return type for void function\n",linecount+1);
			flag=1;
		}
} 

else
{
	if(strcmp((yyvsp[-7]),"int")==0)
		{
			printf("%d Error: Void return type for non void function\n",linecount+1);
			flag=1;
		}
}

if(flag==0)
{
if(checkdupfuncdefinition((yyvsp[-6]))==1)
	printf("\nError : Duplicate definition of function %s\n",(yyvsp[-6]));
else if(checkdupfuncdefinition((yyvsp[-6]))==0)
	 	;
else if(checkdupfuncdefinition((yyvsp[-6]))==-1)
{ 
insertfunc((yyvsp[-7]),(yyvsp[-6]),1);
printf("Function INSERTED\n");
}
}
argindex=0;
}
#line 2355 "y.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 959 "semantic4.y" /* yacc.c:1646  */
    { printf("\nI Function Definition\n");  printf("returnst : %s\n",(yyvsp[0]));  
int flag=0;
printf("typespecifier : %s\n",(yyvsp[-7]));
if((yyvsp[0])){
	printf("enntered to check\n");

	if(strcmp((yyvsp[-7]),"void")==0)
		{
			printf("enntered to check2\n");

			printf("%d Error:Non void return type for void function\n",linecount);
			flag=1;
		}
} 

else
{
	if(strcmp((yyvsp[-7]),"int")==0)
		{
			printf("%d Error: Void return type for non void function\n",linecount);
			flag=1;
		}
}

if(flag==0)
{
if(checkdupfuncdefinition((yyvsp[-6]))==1)
	printf("%d Error: Duplicate Definition of Function %d!\n",linecount+1,(yyvsp[-6]));
else if(checkdupfuncdefinition((yyvsp[-6]))==0)
	 	;
else if(checkdupfuncdefinition((yyvsp[-6]))==-1)
{ 
insertfunc((yyvsp[-7]),(yyvsp[-6]),1);
}
}
argindex=0;
}
#line 2397 "y.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 1000 "semantic4.y" /* yacc.c:1646  */
    {insertparams((yyvsp[-3]),(yyvsp[-2])); printf("%s %s\n", (yyvsp[-3]),(yyvsp[-2]));intindex=0;charindex=0; floatindex=0;}
#line 2403 "y.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 1001 "semantic4.y" /* yacc.c:1646  */
    { insertparams((yyvsp[-1]),(yyvsp[0]));printf("%s %s\n", (yyvsp[-1]),(yyvsp[0]));intindex=0;charindex=0; floatindex=0;}
#line 2409 "y.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 1016 "semantic4.y" /* yacc.c:1646  */
    { 

if((yyvsp[-4])==1||(yyvsp[-4])==2)
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);

}
#line 2420 "y.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 1022 "semantic4.y" /* yacc.c:1646  */
    { 

if((yyvsp[-4])==1||(yyvsp[-4])==2)
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);

}
#line 2431 "y.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 1030 "semantic4.y" /* yacc.c:1646  */
    { 

if((yyvsp[-2])==1||(yyvsp[-2])==2)
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);

}
#line 2442 "y.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 1036 "semantic4.y" /* yacc.c:1646  */
    { 

if((yyvsp[-4])==1||(yyvsp[-4])==2)
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);

}
#line 2453 "y.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 1042 "semantic4.y" /* yacc.c:1646  */
    { 

if((yyvsp[-4])==1||(yyvsp[-4])==2)
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);

}
#line 2464 "y.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 1050 "semantic4.y" /* yacc.c:1646  */
    { 
if((yyvsp[-2])==1||(yyvsp[-2])==2) 
printf("%d Error: Expression in while must be of the type int!\n",linecount+1);
}
#line 2473 "y.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 1059 "semantic4.y" /* yacc.c:1646  */
    { (yyval)=0; printf("$$ = %d\n",(yyval)); printf("\nRETURN\n");}
#line 2479 "y.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 1060 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]); printf("$$  : %s $3:%s\n",(yyval),(yyvsp[0]));intindex=0;}
#line 2485 "y.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 1061 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=0;}
#line 2491 "y.tab.c" /* yacc.c:1646  */
    break;

  case 52:
#line 1069 "semantic4.y" /* yacc.c:1646  */
    {printf("Simple Expression encountered in line %d\n",linecount+1);  
				(yyval)=(yyvsp[0]);
				}
#line 2499 "y.tab.c" /* yacc.c:1646  */
    break;

  case 53:
#line 1072 "semantic4.y" /* yacc.c:1646  */
    {printf("andexpression type : %d\n",(yyval));
 (yyval)=(yyvsp[0]); 
 printf("andexpression type : %d\n",(yyval));
printf("Simple Expression encountered in line %d\n",linecount+1);}
#line 2508 "y.tab.c" /* yacc.c:1646  */
    break;

  case 54:
#line 1078 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]);}
#line 2514 "y.tab.c" /* yacc.c:1646  */
    break;

  case 55:
#line 1079 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]);}
#line 2520 "y.tab.c" /* yacc.c:1646  */
    break;

  case 57:
#line 1083 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]); printf("%d relexpression type : %d\n",linecount,(yyval));}
#line 2526 "y.tab.c" /* yacc.c:1646  */
    break;

  case 58:
#line 1086 "semantic4.y" /* yacc.c:1646  */
    {	printf("%d relexpression type : $1: %d , $3 : %d\n",linecount,(yyvsp[-2]),(yyvsp[0]));
														if((yyvsp[-2])==0&&(yyvsp[0])==0)
															(yyval)=0;
													  else (yyval)=(yyvsp[-2]);}
#line 2535 "y.tab.c" /* yacc.c:1646  */
    break;

  case 59:
#line 1090 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]);}
#line 2541 "y.tab.c" /* yacc.c:1646  */
    break;

  case 60:
#line 1093 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]);}
#line 2547 "y.tab.c" /* yacc.c:1646  */
    break;

  case 61:
#line 1094 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]);}
#line 2553 "y.tab.c" /* yacc.c:1646  */
    break;

  case 64:
#line 1101 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]);}
#line 2559 "y.tab.c" /* yacc.c:1646  */
    break;

  case 65:
#line 1102 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]);}
#line 2565 "y.tab.c" /* yacc.c:1646  */
    break;

  case 70:
#line 1111 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]);}
#line 2571 "y.tab.c" /* yacc.c:1646  */
    break;

  case 74:
#line 1119 "semantic4.y" /* yacc.c:1646  */
    {(yyval)=(yyvsp[0]);}
#line 2577 "y.tab.c" /* yacc.c:1646  */
    break;

  case 75:
#line 1120 "semantic4.y" /* yacc.c:1646  */
    {
				(yyval)=(yyvsp[0]);
				}
#line 2585 "y.tab.c" /* yacc.c:1646  */
    break;

  case 76:
#line 1125 "semantic4.y" /* yacc.c:1646  */
    {{ if(checkid((yyvsp[0]))==-1)
					printf("%d Error: %s Undeclared!\n",linecount+1,(yyvsp[0]));
								if(checkid((yyvsp[0]))==-1)
									printf("%d Error: %s Undeclared!\n",linecount+1,(yyvsp[0]));}
									printf("Before checktype: %s\n",(yyvsp[0]));
									int c=checktype((yyvsp[0])); 
									if(c==0) (yyval)=0; 
									else if(c==1) (yyval)=1 ;
									else if(c==2) (yyval)=2;}
#line 2599 "y.tab.c" /* yacc.c:1646  */
    break;

  case 77:
#line 1134 "semantic4.y" /* yacc.c:1646  */
    {int c=checkidarray((yyvsp[-3])); 
if(c==0)
printf("%d Error: %s Undeclared!\n",linecount+1,(yyvsp[-3]));
else if(c==-1)
printf("%d Error: Non array variable %s has a subscript!\n",linecount+1,(yyvsp[-3]));
}
#line 2610 "y.tab.c" /* yacc.c:1646  */
    break;

  case 79:
#line 1143 "semantic4.y" /* yacc.c:1646  */
    {	
				(yyval)=(yyvsp[0]);				
		    }
#line 2618 "y.tab.c" /* yacc.c:1646  */
    break;

  case 80:
#line 1146 "semantic4.y" /* yacc.c:1646  */
    { printf("call done : \n"); (yyval)=(yyvsp[0]);}
#line 2624 "y.tab.c" /* yacc.c:1646  */
    break;

  case 81:
#line 1151 "semantic4.y" /* yacc.c:1646  */
    { int f=checkfuncdef((yyvsp[-3]));
  int glag=0;
  printf("\n\nf=%d\n\n",f);
  if(f==0) 
  	{ 	glag=1;
       printf("%d Error: Function %s not defined! Illegal Call!\n",linecount+1,(yyvsp[-3]));
      }
  else 
  	if(f==-1) { glag=1;
                 printf("%d Error: %s is not a function\n",linecount+1,(yyvsp[-3]));
                }
else   
if(checknumarg((yyvsp[-3]))==0)				//Checking if number of parameters and arguments match
{
printf("%d Error: Number of arguments in the function call don't match with definition!\n",linecount+1);
	glag=1;

}

else 
{
	printf("Before passing: %s\n",(yyvsp[-3]));
	if(checktypearg((yyvsp[-3]))==-1)
	printf("%d Error: Type of Arguments Passed and Parameters don't match for %s!\n",linecount+1,(yyvsp[-3]));
	glag=1;
}
callargcount=0;
argindex=0;

if(glag==0)
{
if(checktype((yyvsp[-3]))==0)
	(yyval)=0;
else if(checktype((yyvsp[-3]))==1)
	(yyval)=1;
else if(checktype((yyvsp[-3]))==2)
	(yyval)=2;
}
}
#line 2668 "y.tab.c" /* yacc.c:1646  */
    break;

  case 84:
#line 1196 "semantic4.y" /* yacc.c:1646  */
    {   callargcount++;}
#line 2674 "y.tab.c" /* yacc.c:1646  */
    break;

  case 85:
#line 1197 "semantic4.y" /* yacc.c:1646  */
    { callargcount++;}
#line 2680 "y.tab.c" /* yacc.c:1646  */
    break;

  case 86:
#line 1200 "semantic4.y" /* yacc.c:1646  */
    {insertargs("",(yyvsp[0]));}
#line 2686 "y.tab.c" /* yacc.c:1646  */
    break;

  case 87:
#line 1201 "semantic4.y" /* yacc.c:1646  */
    {insertargs("",(yyvsp[0]));  }
#line 2692 "y.tab.c" /* yacc.c:1646  */
    break;

  case 88:
#line 1205 "semantic4.y" /* yacc.c:1646  */
    {
printconst();
printf("\n\n");
int c=checkconsttype((yyvsp[0])); 
printf("before constant %s typeindex : %d\n",(yyvsp[0]),(yyval));
if(c==0) 
(yyval)=0;
else if(c==1)
(yyval)=1;
printf("after constant %s typeindex : %d\n",(yyvsp[0]),(yyval));
}
#line 2708 "y.tab.c" /* yacc.c:1646  */
    break;

  case 89:
#line 1216 "semantic4.y" /* yacc.c:1646  */
    { (yyval)=2;}
#line 2714 "y.tab.c" /* yacc.c:1646  */
    break;

  case 90:
#line 1217 "semantic4.y" /* yacc.c:1646  */
    { (yyval)=(yyvsp[0]);}
#line 2720 "y.tab.c" /* yacc.c:1646  */
    break;


#line 2724 "y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 1220 "semantic4.y" /* yacc.c:1906  */


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
	j=checknofunctions();
	if(j==0)
	{
		printf("Error: No functions defined\n");
	}
	printf("\n\n");
	
	printf("\n\nFINAL SYMBOL TABLE\n\n\n\n");
	printfinalsym();
	
}
yyerror(char *s) {
	printf("Parsing Unsuccessful\n");
	printf("Error in line: %d\n",linecount+1);
}
