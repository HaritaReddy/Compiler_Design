%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

char codestack[100][10];
char i_[3]="0";
int tnum=0;
char temp[2]="t";
int retindex=0;
int i=1;
int top=0,label[20],labelnum=0,labeltop=0;
void pushonstack(char *a)
{
	strcpy(codestack[++top],a);
}
void selection1()
{
	labelnum++;
	strcpy(temp,"t");
	snprintf (i_, sizeof(i_), "%d",tnum);
	strcat(temp,i_);
	printf("%s = not %s\n",temp,codestack[top]);
 	printf("if %s goto L%d\n",temp,labelnum);
	tnum++;
	label[++labeltop]=labelnum;	
	
}
void selection2()
{
	labelnum++;
	printf("goto L%d\n",labelnum);
	printf("L%d: \n",label[labeltop--]);
	label[++labeltop]=labelnum;
}
void selection3()
{
	printf("L%d:\n",label[labeltop--]);
}
void functionbegin(char* funcname)
{
	printf("function begin %s:\n",funcname);
}
void whilekeyword()
{
	labelnum++;
	label[++labeltop]=labelnum;
	printf("L%d:\n",labelnum);
}
void arr1(char *arrayname, int size)
{
	tnum++;
	char temp1[3];
	snprintf(temp1,3,"%d",tnum);
	strcat(temp,temp1);
	printf("t%d = %s + %s*%d",tnum,arrayname,codestack[top--],size);
	strcpy(codestack[top++],temp);
}
void assignment_codearray(char *name)
{
	printf("%s[%s] = %s\n",name,codestack[top-2],codestack[top]);
	top-=2;
}
void afterexpression()
{
	labelnum++;
	strcpy(temp,"t");
	snprintf (i_, sizeof(i_), "%d",tnum);
	strcat(temp,i_);
	printf("%s = not %s\n",temp,codestack[top--]);
 	printf("if %s goto L%d\n",temp,labelnum);
	tnum;
	label[++labeltop]=labelnum;
}
void endofwhile()
{
	int y=label[labeltop--];
	printf("goto L%d\n",label[labeltop--]);
	printf("L%d:\n",y);
}

void code_3addr()
{
	strcpy(temp,"t");
	snprintf (i_, sizeof(i_), "%d",tnum);
	strcat(temp,i_);
	printf("%s = %s %s %s\n",temp,codestack[top-2],codestack[top-1],codestack[top]);
	top-=2;
	strcpy(codestack[top],temp);
	tnum++;
}

void assignment_code()
{
	printf("%s = %s\n",codestack[top-2],codestack[top]);
	top-=2;
}

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

	
	if(checkvar(name)==1)
	{
		
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
	
		int pos=poscalc(name);

	
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
	
		int pos=poscalc(name);

		
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
	
	if(temp->argcount!=callargcount)
	return 0;
	return 1;
	
}
int countfuncargs(char* name)
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
	return temp->argcount;
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
	return 0;
	else if((temp->type)&&strcmp(temp->type,"float")==0)
	return 1;
	else if((temp->type)&&strcmp(temp->type,"char")==0)
	return 2;

	
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

%token ID NUM WHILE TYPE CHARCONST LE GT GE LT EE NE PREPRO INT RETURN IF ELSE STRUCT UNARYOP STATEKW STRING CC CO FLOAT VOID CHAR STATIC AND OR BREAK NEG 
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
|fundeclaration
|fundefinition
;

vardeclaration: typespecifier ID {pushonstack($2);} '=' {strcpy(codestack[++top],"=");} simpleexpression  {  assignment_code();
int type;
if(strcmp($1,"int")==0)
type=0; 
else if(strcmp($1,"float")==0)
type=1; 
else if(strcmp($1,"char")==0)
type=2;
/*
if(type==0&&(floatindex==1||charindex==1))
printf("%d Error: Expression on RHS must be of the type int!\n",linecount+1);
else if(type==1&&charindex==1)
printf("%d Error: Expression on RHS must be of the type float!\n",linecount+1);
else if(type==1&&charindex==0&&intindex==1)
printf("%d Error: Expression on RHS contains INT type but type conversion happens to float!\n",linecount+1);
else if(type==2&&(intindex==1||charindex==1))
printf("%d Error: Expression on RHS must be of the type char!\n",linecount+1);
*/
intindex=0;
floatindex=0;
charindex=0;
int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n\n%d Error: Duplicate declaration of %s\n\n",linecount+1,$2); }

|typespecifier ID 			{  int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n\n%d Error: Duplicate declaration of %s\n\n",linecount+1,$2);}

|typespecifier ID '[' simpleexpression ']' '=' simpleexpression {if(intindex==1) 
printf("%d Error: Expression must be of the type int!\n",linecount+1);
intindex=0;insertarray($1,$2,$4); }

|typespecifier ID '[' simpleexpression ']'   { /*if(intindex==1) 
printf("%d Error: Expression in subscript must be of the type int!\n",linecount+1);*/
intindex=0; insertarray($1,$2,$4); ;}

|typespecifier ID '[' ']' {printf("%d Error: Array has no subscript!\n",linecount+1);}

;




statement: ID{pushonstack($1);} '=' {strcpy(codestack[++top],"=");}simpleexpression {assignment_code();}';'	{  
int type=checktype($1);
if(type==0&&(floatindex==1||charindex==1))
printf("%d Error: Expression on RHS must be of the type int!\n",linecount+1);
else if(type==1&&charindex==1)
printf("%d Error: Expression on RHS must be of the type float!\n",linecount+1);
else if(type==1&&charindex==0&&intindex==1)
printf("%d Error: Expression on RHS contains INT type but type conversion happens to float!\n",linecount+1);
else if(type==2&&(intindex==1||charindex==1))
printf("%d Error: Expression on RHS must be of the type char!\n",linecount+1);
intindex=0;
floatindex=0;
charindex=0;
int p=checkifidisarray($1); 
if(p==0)
printf("%d Error: Array Identifier has no subscript!!\n",linecount+1);
else
{
if(checkid($1)==-1)
printf("%d Error: %s Undeclared!\n",linecount+1,$1);
}
}
|ID '[' simpleexpression ']' '='  {int val=checktype($1); 
int size;
if(val==0) size=4;else if(val==1) size=4; else size=2; 
arr1($1,size); 
} simpleexpression {assignment_codearray($1);} ';'		
{/*
if(intindex==1) 
printf("%d Error: Expression on RHS must be of the type int!\n",linecount);*/
intindex=0;
int c=checkidarray($1); 
if(c==0)
	printf("\n\nError : %s Undeclared\n\n\n",$1);
else if(c==-1)
printf("%d Error: Non array variable %s has a subscript!\n",linecount,$1);

}
|compoundst
|selectionst
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
|typespecifier ID '('  ')' ';'    { 
if(checkdupfunc($2)==1)
	printf("%d Error: Duplicate Declaration of Function %s!\n",linecount+1,$2);
else 
{ 
insertfunc($1,$2,0);
}
argindex=0;

}
;

fundefinition: typespecifier ID '(' params1 ')' CO {functionbegin($2);} declarationlist returnst CC   {   printf("function end %s\n",$2);printf("\n\n");
int flag=0;
if(strcmp($1,"void")==0&&retindex==1)
{
	printf("%d Error:Non void return type for void function\n",linecount);
		flag=1;
		retindex=0;
}
if(strcmp($1,"int")==0&&retindex==0)
{
	printf("%d Error: Void return type for non void function\n",linecount);
			flag=1;
		retindex=0;
}

/*if($8!=0){
	

	if(strcmp($1,"void")==0)
		{
			

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
*/
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

|typespecifier ID '(' ')' CO {functionbegin($2);} declarationlist returnst CC   {     printf("function end %s\n",$2);printf("\n\n");

int flag=0;
if(strcmp($1,"void")==0&&retindex==1)
{
	printf("%d Error:Non void return type for void function\n",linecount);
		flag=1;
		retindex=0;
}
if(strcmp($1,"int")==0&&retindex==0)
{
	printf("%d Error: Void return type for non void function\n",linecount);
			flag=1;
		retindex=0;
}
/*
if($7!=0)
{	
	
	if(strcmp($1,"void")==0)
		{
				

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
*/
if(flag==0)
{
if(checkdupfuncdefinition($2)==1)
	printf("\nError : Duplicate definition of function %s\n",$2);
else if(checkdupfuncdefinition($2)==0)
	 	;
else if(checkdupfuncdefinition($2)==-1)
{ 
insertfunc($1,$2,1);
}
}
argindex=0;
}
|typespecifier ID '(' params1 ')' CO {functionbegin($2);}returnst CC   {   printf("function end %s\n",$2);printf("\n\n");
int flag=0;
if(strcmp($1,"void")==0&&retindex==1)
{
	printf("%d Error:Non void return type for void function\n",linecount);
		flag=1;
		retindex=0;
}
if(strcmp($1,"int")==0&&retindex==0)
{
	printf("%d Error: Void return type for non void function\n",linecount);
			flag=1;
		retindex=0;
}
/*
if($8!=0){
	
	if(strcmp($1,"void")==0)
		{
			

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
*/
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


params1: typespecifier ID ',' params1   {insertparams($1,$2); intindex=0;charindex=0; floatindex=0;}
|typespecifier ID  { insertparams($1,$2);intindex=0;charindex=0; floatindex=0;}
;



typespecifier: INT
|FLOAT
|CHAR
|VOID
;


selectionst : IF '(' simpleexpression ')' {selection1();} statement {selection2();} else
;
else : ELSE statement {selection3();}
;


whileloop: WHILE {whilekeyword();}'(' simpleexpression ')' {afterexpression();} compoundst { endofwhile();
if(floatindex==1||charindex==1) 
printf("%d Error: Expression in while must be of the type int!\n",linecount+1);
intindex=0;
floatindex=0;
charindex=0;
}
;

breakst:BREAK ';'
;

returnst: RETURN ';'     { $$=0; retindex=0;}
|RETURN  simpleexpression  ';'    {$$=$3; intindex=0;retindex=1;}
|    {$$=0;retindex=0;}
;

compoundst: CO declarationlist CC
| CO CC
;


simpleexpression: simpleexpression OR andexpression {}
|andexpression {}
;

andexpression: andexpression AND unaryrelexpression
|unaryrelexpression
;

unaryrelexpression: '!' unaryrelexpression
|relexpression
;

relexpression: sumexpression LE {strcpy(codestack[++top],"<=");} sumexpression  {code_3addr();}
|sumexpression GE {strcpy(codestack[++top],">=");} sumexpression   {code_3addr();}
|sumexpression EE {strcpy(codestack[++top],"==");} sumexpression {code_3addr();}
|sumexpression LT {strcpy(codestack[++top],"<");} sumexpression   {code_3addr();}
|sumexpression GT {strcpy(codestack[++top],">");} sumexpression   {code_3addr();}
|sumexpression NE {strcpy(codestack[++top],"!=");} sumexpression {code_3addr();}
|sumexpression  
;


sumexpression: sumexpression '+' {strcpy(codestack[++top],"+");} term {code_3addr();}
|sumexpression '-' {strcpy(codestack[++top],"-");} term {code_3addr();}
|term
;



term: term '*' { strcpy(codestack[++top],"*");} unaryexpression {code_3addr();}
|term '/' { strcpy(codestack[++top],"/");} unaryexpression {code_3addr();}
|unaryexpression
;



unaryexpression:factor      
;



factor: mutable
|immutable   
;

mutable: ID {{ if(checkid($1)==-1)
					printf("%d Error: %s Undeclared!\n",linecount+1,$1);
								if(checkid($1)==-1)
									printf("%d Error: %s Undeclared!\n",linecount+1,$1);}
									int c=checktype($1); if(c==0) intindex=1; else if(c==1) floatindex=1 ;else if(c==2)charindex=1;pushonstack($1);}
|mutable '[' sumexpression ']' {int c=checkidarray($1); 
if(c==0)
printf("%d Error: %s Undeclared!\n",linecount+1,$1);
else if(c==-1)
printf("%d Error: Non array variable %s has a subscript!\n",linecount+1,$1);

}  
;

immutable: '(' sumexpression ')' 
|constant   
|call { int c=checktype($1);  if(c==0) intindex=1; else if(c==1) floatindex=1 ;else if(c==2)charindex=1;}
;


call: ID '(' args ')' 
{ int f=checkfuncdef($1);
 
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
	
	if(checktypearg($1)==-1)
	printf("%d Error: Type of Arguments Passed and Parameters don't match for %s!\n",linecount+1,$1);
}
callargcount=0;
argindex=0;
int farg=countfuncargs($1);
printf("call %s, number of arguments - %d\n",$1,farg);

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
printf("\n\n");
int c=checkconsttype($1); 
if(c==1) 
floatindex=1;
else if(c==0)
intindex=1;
pushonstack($1);
$$=$1;

}  
|CHARCONST {charindex=1; $$=$1;pushonstack($1);}
|STRING { $$=$1;pushonstack($1);}
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
	/*j=checknofunctions();
	if(j==0)
	{
		printf("Error: No functions defined\n");
	}
	printf("\n\n");
	*/
	printf("\n\nFINAL SYMBOL TABLE\n\n\n\n");
	printfinalsym();
	
}
yyerror(char *s) {
	printf("Parsing Unsuccessful\n");
	printf("Error in line: %d\n",linecount+1);
}
