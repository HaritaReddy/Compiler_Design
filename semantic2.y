%{
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
	return 1;
	if((temp->type)&&strcmp(temp->type,"int")!=0)
	return 0;

	printf("so %s has type %s\n",name,temp->type);
	return 1;
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
	return 1;
	if(strcmp(temp->type,"int")!=0)
	{
	return 0;
	}
	return 1;
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
%}

%token ID NUM WHILE TYPE CHARCONST COMPARE PREPRO INT RETURN IF ELSE STRUCT UNARYOP STATEKW STRING CC CO FLOAT VOID CHAR STATIC AND OR BREAK NEG 
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

vardeclaration: typespecifier ID '=' simpleexpression  { printf("Declaration Done\n"); if(intindex==1) 
printf("%d Error: Expression on RHS must be of the type int!\n",linecount+1);
intindex=0;int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n\n%d Error: Duplicate declaration of %s\n\n",linecount+1,$2); printsym();}

|typespecifier ID 			{ printf("declaration done\n"); int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n\n%d Error: Duplicate declaration of %s\n\n",linecount+1,$2); printsym();}

|typespecifier ID '[' simpleexpression ']' '=' simpleexpression {if(intindex==1) 
printf("%d Error: Expression must be of the type int!\n",linecount+1);
intindex=0;insertarray($1,$2,$4); printsym();}

|typespecifier ID '[' simpleexpression ']'   { printf("\n\narray detected %s\n\n",$1);if(intindex==1) 
printf("%d Error: Expression in subscript must be of the type int!\n",linecount+1);
intindex=0; insertarray($1,$2,$4); printf("\n\narray ddetected\n\n");printsym();}

|typespecifier ID '[' ']' {printf("%d Error: Array has no subscript!\n",linecount+1);}

;




statement: ID '=' simpleexpression ';'	{  
printf("Intindex: %d\n",intindex);
if(intindex==1) 
printf("%d Error: Expression on RHS must be of the type int!\n",linecount+1);
intindex=0;
int p=checkifidisarray($1); 
if(p==0)
printf("%d Error: Array Identifier has no subscript!!\n",linecount+1);
else
{
if(checkid($1)==-1)
printf("%d Error: %s Undeclared!\n",linecount+1,$1);
}
}
|ID '[' NUM ']' '=' simpleexpression ';'		
{
if(intindex==1) 
printf("%d Error: Expression on RHS must be of the type int!\n",linecount);
intindex=0;
int c=checkidarray($1); 
if(c==0)
	printf("\n\nError : %s Undeclared\n\n\n",$1);
else if(c==-1)
printf("%d Error: Non array variable %s has a subscript!\n",linecount,$1);
}
|compoundst
|breakst
|whileloop
|call ';'
|error
;

fundeclaration: typespecifier ID '(' params1 ')' ';'  { printf("Function Declaration\n"); 
if(checkdupfunc($2)==1)
	printf("%d Error: Duplicate Declaration of Function %s!\n",linecount+1,$2);
else 
{ 
insertfunc($1,$2,0);
}
argindex=0;
}
|typespecifier ID '('  ')' ';'    { printf("\nFunction Declaration\n"); 
if(checkdupfunc($2)==1)
	printf("%d Error: Duplicate Declaration of Function %s!\n",linecount+1,$2);
else 
{ 
insertfunc($1,$2,0);
}
argindex=0;

}
;

fundefinition: typespecifier ID '(' params1 ')' CO declarationlist returnst CC   { printf("\nI Function Definition\n");  printf("returnst : %s\n",$8);  
int flag=0;
printf("typespecifier : %s\n",$1);
if($8){
	printf("enntered to check\n");

	if(strcmp($1,"void")==0)
		{
			printf("enntered to check2\n");

			printf("%d Error:Non void return type for void function\n",linecount);
			flag=1;
		}
} 

else
{
	if(strcmp($1,"int")==0)
		{
			printf("%d Error: Void return type for non void function\n",linecount);
			flag=1;
		}
}

if(flag==0)
{
if(checkdupfuncdefinition($2)==1)
	printf("%d Error: Duplicate Definition of Function %d!\n",linecount+1,$2);
else if(checkdupfuncdefinition($2)==0)
	 	;
else if(checkdupfuncdefinition($2)==-1)
{ 
insertfunc($1,$2,1);
}
}
argindex=0;
}

|typespecifier ID '(' ')' CO  declarationlist returnst CC   { printf("\nFunction Definition\n");     printf("returnst : %s\n",$7); 
int flag=0;
printf("typespecifier : %s\n",$1);

if($7)
{	
	printf("enntered to check\n");
	if(strcmp($1,"void")==0)
		{
				printf("enntered to check2\n");

			printf("%d Error:Non void return type for void function\n",linecount+1);
			flag=1;
		}
} 

else
{
	if(strcmp($1,"int")==0)
		{
			printf("%d Error: Void return type for non void function\n",linecount+1);
			flag=1;
		}
}

if(flag==0)
{
if(checkdupfuncdefinition($2)==1)
	printf("\nError : Duplicate definition of function %s\n",$2);
else if(checkdupfuncdefinition($2)==0)
	 	;
else if(checkdupfuncdefinition($2)==-1)
{ 
insertfunc($1,$2,1);
printf("Function INSERTED\n");
}
}
argindex=0;
}
|typespecifier ID '(' params1 ')' CO returnst CC   { printf("\nI Function Definition\n");  printf("returnst : %s\n",$8);  
int flag=0;
printf("typespecifier : %s\n",$1);
if($8){
	printf("enntered to check\n");

	if(strcmp($1,"void")==0)
		{
			printf("enntered to check2\n");

			printf("%d Error:Non void return type for void function\n",linecount);
			flag=1;
		}
} 

else
{
	if(strcmp($1,"int")==0)
		{
			printf("%d Error: Void return type for non void function\n",linecount);
			flag=1;
		}
}

if(flag==0)
{
if(checkdupfuncdefinition($2)==1)
	printf("%d Error: Duplicate Definition of Function %d!\n",linecount+1,$2);
else if(checkdupfuncdefinition($2)==0)
	 	;
else if(checkdupfuncdefinition($2)==-1)
{ 
insertfunc($1,$2,1);
}
}
argindex=0;
}

;


params1: typespecifier ID ',' params1   {insertparams($1,$2); printf("%s %s\n", $1,$2);intindex=0;}
|typespecifier ID  { insertparams($1,$2);printf("%s %s\n", $1,$2);intindex=0;}
;



typespecifier: INT
|FLOAT
|CHAR
|VOID
;

selectionst: matchedst
|unmatchedst
;

matchedst: IF '(' simpleexpression ')' statement ELSE matchedst { 
if(intindex==1) 
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);
intindex=0;
}
|IF '(' simpleexpression ')' statement ELSE statement { 
if(intindex==1) 
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);
intindex=0;
}
;

unmatchedst: IF '(' simpleexpression ')' statement { 
if(intindex==1) 
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);
intindex=0;
}
|IF '(' simpleexpression ')' matchedst ELSE unmatchedst { 
if(intindex==1) 
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);
intindex=0;
}
|IF '(' simpleexpression ')' statement ELSE unmatchedst{ 
if(intindex==1) 
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);
intindex=0;
}
;

whileloop: WHILE '(' simpleexpression ')' compoundst { 
if(intindex==1) 
printf("%d Error: Expression in while must be of the type int!\n",linecount+1);
intindex=0;
}
;

breakst:BREAK ';'
;

returnst: RETURN ';'     { $$=0; printf("$$ = %d\n",$$); printf("\nRETURN\n");}
|RETURN  simpleexpression  ';'    {$$=$3; printf("$$  : %s $3:%s\n",$$,$3);intindex=0;}
|    {$$=0;}
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

relexpression: sumexpression COMPARE sumexpression   
|sumexpression   
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

mutable: ID {{ if(checkid($1)==-1)
					printf("%d Error: %s Undeclared!\n",linecount+1,$1);
								if(checkid($1)==-1)
									printf("%d Error: %s Undeclared!\n",linecount+1,$1);}
									printf("Before checktype: %s\n",$1);int c=checktype($1); if(c==0) intindex=1;}
|mutable '[' sumexpression ']' {int c=checkidarray($1); 
if(c==0)
printf("%d Error: %s Undeclared!\n",linecount+1,$1);
else if(c==-1)
printf("%d Error: Non array variable %s has a subscript!\n",linecount+1,$1);
}  
;

immutable: '(' sumexpression ')' 
|constant   
|call {printf("Call $1 is %s\n",$1); int c=checktype($1); printf("intindex before call : %d\n",intindex); if(c==0) intindex=1;  printf("intindex after call : %d\n",intindex);}
;


call: ID '(' args ')' 
{ int f=checkfuncdef($1);
  printf("\n\nf=%d\n\n",f);
  if(f==0) 
  	printf("%d Error: Function %s not defined! Illegal Call!\n",linecount+1,$1);
  else 
  	if(f==-1) printf("%d Error: %s is not a function\n",linecount+1,$1);
else   
if(checknumarg($1)==0)				//Checking if number of parameters and arguments match
{
printf("%d Error: Number of arguments in the function call don't match with definition!\n",linecount+1);

}

else 
{
	printf("Before passing: %s\n",$1);
	if(checktypearg($1)==-1)
	printf("%d Error: Type of Arguments Passed and Parameters don't match for %s!\n",linecount+1,$1);
}
callargcount=0;
argindex=0;

}
;

args: arglist
|
;

arglist: arglist ',' simple   {   callargcount++;}
|simple { callargcount++;}
;

simple: NUM    {insertargs("",$1);}
|ID           {insertargs("",$1);  }
;

constant: NUM   
{
printconst();
printf("\n\n");
int c=checkconsttype($1); 
printf("before constant %s intindex : %d\n",$1,intindex);
if(c==0) 
intindex=1;
printf("after constant intindex : %d\n",intindex);

$$=$1;

}  
|CHARCONST {intindex=1; $$=$1;}
|STRING {intindex=1; $$=$1;}
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
