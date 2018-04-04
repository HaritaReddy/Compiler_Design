%{
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

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


struct exprType{

  char *addr;
  char *code;
  int dtype;

};

int n=1;
int nl = 1;
char *var;
char num_to_concatinate[10];
char num_to_concatinate_l[10];
char *ret;
char *temp;

char *label;
char *label2;
char *check;

char *begin;

char *b1;
char *b2;

char *s1;
char *s2;

struct exprType *to_return_expr;

char * newTemp(){
  
  char *newTemp = (char *)malloc(20);
  strcpy(newTemp,"t");
  snprintf(num_to_concatinate, 10,"%d",n);
  strcat(newTemp,num_to_concatinate);
  printf("NewTemp: %s\n",newTemp);  
  n++;
  return newTemp;
}

char * newLabel(){
  
  char *newLabel = (char *)malloc(20);
  strcpy(newLabel,"L");
  snprintf(num_to_concatinate_l, 10,"%d",nl);
  strcat(newLabel,num_to_concatinate_l);
    
  nl++;
  return newLabel;
}
void insertvar(char* type,char* name) //Inserts the token in symbol table
  {
  //printf("insertvar entered\n");
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
//printf("checkvar entered\n");
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
  //printf("checkid entered\n");
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

  //printf("\n\n Array name: %s, TYPE : %s , size : %s \n\n",name, type, size);
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
        //printf("size at the pos (in symtable): %s\n",symtable[pos]->size);
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
        //printf("size at the pos(in finalsymtable): %s\n",finalsymtable[pos]->size);
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
  //printf("insertfunction entered\n");
    int pos=poscalc(name);

    //printf("posiiton calculated\n");
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
  //printf("insertvar entered\n");
    int pos=poscalc(name);

  //  printf("posiiton calculated\n");
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
      return 1;         //1=duplicate declaration
    }
    temp=temp->next;
  }

  return 0;             //0=okay to declaare and insert

}

int checkdupfuncdefinition(char *name)
{
  int pos=poscalc(name);

  struct node *temp=symtable[pos];
  while(temp!=NULL)
  {
    if(strcmp(temp->name,name)==0&&globalscope==temp->scope&&temp->defflag==1)
    {
      return 1;         //1=duplicate declaration
    }
    else if(strcmp(temp->name,name)==0&&globalscope==temp->scope&&temp->defflag==0)
    {
      temp->defflag=1;
      return 0;         //0=declared but not defined
    }
    temp=temp->next;
  }

  return -1;            //-1=okay to declaare and insert

}



void insertparams(char *paramtype, char *param)
{
  if(strcmp(paramtype,"void")==0)
    {
      printf("Error : Void type parameter for function\n");
      return;
    }
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
  if(strcmp(temp->class,"array")==0||strcmp(temp->class,"function")==0)
  return 5;
  if((temp->type)&&strcmp(temp->type,"int")==0)
  return 0;                                              //0=int
  else if((temp->type)&&strcmp(temp->type,"float")==0)
  return 1;                        //1=float  
  else if((temp->type)&&strcmp(temp->type,"char")==0)
  return 2;                     // 2=char

  //printf("so %s has type %s\n",name,temp->type);
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

      printf("Name:%s, Class:%s",ptr->name,ptr->class);
      if(strlen(ptr->type)!=0)
      printf(", Type:%s ",ptr->type);
      
      if(ptr->scope>=0)
        printf(", Nesting level:%d",ptr->scope);
      if(strlen(ptr->size)!=0)
        printf(", Array dimension:%s",ptr->size);
      if(ptr->arg[0])
      {
        printf(", Arguments: ");
        for(i=0;i<ptr->argcount;i++)
        {
          printf(", %s %s ",ptr->argtype[i],ptr->arg[i]);
        }
      }
      if(strcmp(ptr->class,"function")==0)
        printf(", Definition flag:%d",ptr->defflag);
      printf("|\t");
      ptr=ptr->next;
    }
    printf("\n\n");
  }

  printf("------------FINAL SYMBOL TABLE ENDED-----------------\n\n");
}
%}


%union {
  int ival;
  float fval;
  char *sval;
  struct exprType *EXPRTYPE;
}

%token <sval> ID NUM WHILE TYPE CHARCONST COMPARE PREPRO INT RETURN IF ELSE STRUCT UNARYOP STATEKW STRING CC CO FLOAT VOID CHAR STATIC AND OR BREAK NEG 
%type <EXPRTYPE> sumexpression term unaryexpression andexpression unaryrelexpression  simpleexpression statement vardeclaration call whileloop compoundst constant mutable immutable factor fundefinition fundeclaration typespecifier returnst relexpression sumop breakst mulop program ED declaration declarationlist prepro
%left '+' '-'
%left '*' '/'

%%
ED: program   {s1 = $1->code;
      label = newLabel();
      printf("i reached program\n");
      check = strstr (s1,"NEXT");
      
      while(check!=NULL){
        strncpy (check,label,strlen(label));
        strncpy (check+strlen(label),"    ",(4-strlen(label)));
        check = strstr (s1,"NEXT");
        }
            printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1->addr);
    printf("\n\n\nto_return_expr->code = %s; \n\n\n",$1->code);

      ret = (char *)malloc(strlen(s1)+10);
      ret[0] = 0;

      strcat(ret,s1);
      strcat(ret,"\n");
      strcat(ret,label);
      strcat(ret," : END OF THREE ADDRESS CODE !!!!!\n");
      
      printf("\n----------  FINAL THREE ADDRESS CODE ----------\n");
      puts(ret);

      $$ = ret;
      }
;

program: prepro declarationlist   { printf("i reached program prepro declarationlist\n"); 
s1 = $1;
      s2 = $2;

      printf("$1 - %s $2--%s\n",$1->code,$2->code);
      label = newLabel();

      check = strstr (s1,"NEXT");
      printf("check -- %s\n",check);
      while(check!=NULL){
        strncpy (check,label,strlen(label));
        strncpy (check+strlen(label),"    ",(4-strlen(label)));
        check = strstr (s1,"NEXT");
        }

      ret = (char *)malloc(strlen($1)+strlen($2)+4);
      ret[0] = 0;
      strcat(ret,$1->code);
      strcat(ret,"\n");
      strcat(ret,label);
      strcat(ret," : ");
      strcat(ret,$2->code);

      printf("ret ---- ");
      puts(ret);
      strcpy($$->code,ret); }
;

prepro: prepro PREPRO   { printf("i reached prepro\n"); to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1);
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    $$ = to_return_expr; }
| { to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = 0;
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    $$ = to_return_expr;}
;

declarationlist: declarationlist declaration  { printf("i reached declarationlost\n");
ret = (char *)malloc(strlen($1)+strlen($2->code)+4);
      ret[0] = 0;
printf("$1->code : %s $2->code : %s\n",$1->code,$2->code);
      if($1->code)
        {strcat(ret,$1->code);
        strcat(ret,"\n");}
      strcat(ret,$2->code);
    
      printf("Inside declarationlist \n");
      puts(ret);
      strcpy($$->code,ret);
      printf("declraartion list ka $$->code ---- %s\n",$$->code);
    printf("im exiting declarataionlist\n");}

|declaration   { printf("i reached declaration\n");
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1->addr);
    to_return_expr->code = (char *)malloc(100);
    strcpy(to_return_expr->code,$1->code);
    $$ = to_return_expr;
    printf("declarataion ka $$->code : %s\n",$$->code);}
;

declaration: vardeclaration ';'   { printf("i reached vardeclaration\n");
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1);
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    
    $$ = to_return_expr;
    }
|statement   { printf("i reached statmenet %s\n",$1->addr);
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1->addr);
    to_return_expr->code = (char *)malloc(100);
    strcpy(to_return_expr->code,$1->code);
    $$ = to_return_expr;
    printf("statement ka $$->code : %s\n",$$->code);
}
|selectionst   { printf("i reached selectionst\n");}
|fundeclaration   { printf("i reached fundeclaration\n");}
|fundefinition    { printf("i reached fundefinition\n");}
;

vardeclaration: typespecifier ID '=' simpleexpression  { 
int type;
if(strcmp($1,"int")==0)
type=0; 
else if(strcmp($1,"float")==0)
type=1; 
else if(strcmp($1,"char")==0)
type=2;

if(type==0&&($4->dtype==1||$4->dtype==2))
printf("\n%d Error: Expression on RHS must be of the type int!\n",linecount+1);
else if(type==1&&$4->dtype==2)
printf("\n%d Error: Expression on RHS must be of the type float!\n",linecount+1);
else if(type==1&&($4->dtype==0))
printf("\n%d Error: Expression on RHS contains INT type but type conversion happens to float!\n",linecount+1);
else if(type==2&&($4->dtype==0||$4->dtype==1))
printf("\n%d Error: Expression on RHS must be of the type char!\n",linecount+1);
intindex=0;
floatindex=0;
charindex=0;
int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n%d Error: Duplicate declaration of %s\n",linecount+1,$2);}

|typespecifier ID       {  int c; if(checkvar($2)==0) insertvar($1,$2); else printf("\n%d Error: Duplicate declaration of %s\n",linecount+1,$2);
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1);
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    
    $$ = to_return_expr;
}

|typespecifier ID '[' NUM ']' '=' simpleexpression { if(checkconsttype($4)!=0) 
printf("\n%d Error: Expression must be of the type int!\n",linecount+1);
intindex=0;insertarray($1,$2,$4); }

|typespecifier ID '[' NUM ']'   { 
if(checkconsttype($4)!=0)  
printf("\n%d Error: Expression in subscript must be of the type int!\n",linecount+1);
intindex=0; insertarray($1,$2,$4); }

|typespecifier ID '[' ID ']' '=' simpleexpression {if(checktype($4)!=0) 
printf("\n%d Error: Expression must be of the type int!\n",linecount+1);
intindex=0;insertarray($1,$2,$4);}

|typespecifier ID '[' ID ']'   {
if(checktype($4)!=0) 
printf("\n%d Error: Expression in subscript must be of the type int!\n",linecount+1);
intindex=0; insertarray($1,$2,$4); }

|typespecifier ID '[' ']' {printf("\n%d Error: Array has no subscript!\n",linecount+1);}

;




statement: ID '=' simpleexpression ';'  {  
int type=checktype($1); 
if(type==0&&($3->dtype==1||$3->dtype==2))
  printf("\n%d Error: Expression on RHS must be of the type int! hshshssh\n",linecount+1);
else if(type==1&&($3->dtype==0||$3->dtype==2))
    printf("\n%d Error: Expression on RHS must be of the type float!\n",linecount+1);
else if(type==1&&($3->dtype==0))
    printf("\n%d Error: Expression on RHS contains INT type but type conversion happens to float!\n",linecount+1);
else if(type==2&&($3->dtype==1||$3->dtype==0))
    printf("\n%d Error: Expression on RHS must be of the type char!\n",linecount+1);

int p=checkifidisarray($1); 
if(p==0)
printf("\n%d Error: Array Identifier has no subscript!!\n",linecount+1);
else
{
if(checkid($1)==-1)
printf("\n%d Error: %s Undeclared!\n",linecount+1,$1);
}

printf("Assignment statement \n");
printf("$3-->addr %s\n",$3->addr);
printf("$3-->code %s\n",$3->code);

    to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = newTemp();
    
    ret = (char *)malloc(20);
    ret[0] = 0;
    strcat(ret,$1);

    strcat(ret,"=");
        printf("assignment statement %s\n",$3->addr);

    strcat(ret,$3->addr);
    printf("RET  = ");
    puts(ret);

    temp = (char *)malloc(strlen($3->code)+strlen(ret)+6);

    temp[0] = 0;
    
    if ($3->code[0]!=0){
      strcat(temp,$3->code);
      strcat(temp,"\n");
      }
    strcat(temp,ret);
    printf("TEMP = \n");

    puts(temp);

    to_return_expr->code = temp;

            $$ = to_return_expr;
      
      
    printf(" temp  --->   %s \n",$$->addr);
          

}
|ID '[' NUM ']' '=' simpleexpression ';'    
{
if($6->dtype==1||$6->dtype==2) 
printf("\n%d Error: Expression on RHS must be of the type int!\n",linecount);
int c=checkidarray($1); 
if(c==0)
  printf("\n\nError : %s Undeclared\n\n\n",$1);
else if(c==-1)
printf("\n%d Error: Non array variable %s has a subscript!\n",linecount,$1);
}
|compoundst
|breakst   {}
|whileloop
|call ';'
|error {}
;

fundeclaration: typespecifier ID '(' params1 ')' ';'  { 
if(checkdupfunc($2)==1)
  printf("\n%d Error: Duplicate Declaration of Function %s!\n",linecount+1,$2);
else 
{ 
insertfunc($1,$2,0);
}
argindex=0;
}
|typespecifier ID '('  ')' ';'    {  
if(checkdupfunc($2)==1)
  printf("\n%d Error: Duplicate Declaration of Function %s!\n",linecount+1,$2);
else 
{ 
insertfunc($1,$2,0);
}
argindex=0;

}
;

fundefinition: typespecifier ID '(' params1 ')' CO declarationlist returnst CC   { 
int flag=0;
if($8->dtype!=-1){

  if(strcmp($1,"void")==0)
    {

      printf("\n%d Error:Non void return type for void function\n",linecount);
      flag=1;
    }
} 

else
{
  if(strcmp($1,"int")==0)
    {
      printf("\n%d Error: Void return type for non void function\n",linecount);
      flag=1;
    }
}

if(flag==0)
{
if(checkdupfuncdefinition($2)==1)
  printf("\n%d Error: Duplicate Definition of Function %d!\n",linecount+1,$2);
else if(checkdupfuncdefinition($2)==0)
    ;
else if(checkdupfuncdefinition($2)==-1)
{ 
insertfunc($1,$2,1);
}
}
argindex=0;
}

|typespecifier ID '(' ')' CO  declarationlist returnst CC   { 
int flag=0;

if($7->dtype!=-1)
{ 
  if(strcmp($1,"void")==0)
    {
      printf("\n%d Error:Non void return type for void function\n",linecount+1);
      flag=1;
    }
} 

else
{
  if(strcmp($1,"int")==0)
    {
      printf("\n%d Error: Void return type for non void function\n",linecount+1);
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
}
}
argindex=0;
}
|typespecifier ID '(' params1 ')' CO returnst CC   {    
int flag=0;
if($7->dtype!=-1){

  if(strcmp($1,"void")==0)
    {

      printf("\n%d Error:Non void return type for void function\n",linecount);
      flag=1;
    }
} 

else
{
  if(strcmp($1,"int")==0)
    {
      printf("\n%d Error: Void return type for non void function\n",linecount);
      flag=1;
    }
}

if(flag==0)
{
if(checkdupfuncdefinition($2)==1)
  printf("\n%d Error: Duplicate Definition of Function %d!\n",linecount+1,$2);
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


params1: typespecifier ID ',' params1   {insertparams($1,$2);  intindex=0;charindex=0; floatindex=0;}
|typespecifier ID  { insertparams($1,$2); intindex=0;charindex=0; floatindex=0;}
;



typespecifier: INT {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1);
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    
    $$ = to_return_expr;}

|FLOAT {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1);
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    
    $$ = to_return_expr;}

|CHAR {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1);
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    
    $$ = to_return_expr;}

|VOID {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    printf("\n\n\nto_return_expr->addr = %s; \n\n\n",$1);
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    
    $$ = to_return_expr;}
;

selectionst: matchedst
|unmatchedst
;

matchedst: IF '(' simpleexpression ')' statement ELSE matchedst { 

if($3->dtype==1||$3->dtype==2)
printf("%d Error: Expression in if must be of the type int!\n",linecount+1);

}
|IF '(' simpleexpression ')' statement ELSE statement { 

if($3->dtype==1||$3->dtype==2)
printf("\n%d Error: Expression in if must be of the type int!\n",linecount+1);

}
;

unmatchedst: IF '(' simpleexpression ')' statement { 

if($3->dtype==1||$3->dtype==2)
printf("\n%d Error: Expression in if must be of the type int!\n",linecount+1);

}
|IF '(' simpleexpression ')' matchedst ELSE unmatchedst { 

if($3->dtype==1||$3->dtype==2)
printf("\n%d Error: Expression in if must be of the type int!\n",linecount+1);

}
|IF '(' simpleexpression ')' statement ELSE unmatchedst{ 

if($3->dtype==1||$3->dtype==2)
printf("\n%d Error: Expression in if must be of the type int!\n",linecount+1);

}
;

whileloop: WHILE '(' simpleexpression ')' compoundst { 
if($3->dtype==1||$3->dtype==2) 
printf("\n%d Error: Expression in while must be of the type int!\n",linecount+1);
}
;

breakst:BREAK ';'  {}
;

returnst: RETURN ';'     { 
    to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    
    to_return_expr->dtype = -1;
    
    $$ = to_return_expr;
   }
|RETURN  simpleexpression  ';'    { if(($2->dtype)>2) printf("\n%d Error: Invalid Return Type!\n",linecount+1); intindex=0;}
|    {$$->dtype=-1;}
;

compoundst: CO declarationlist CC  {}
| CO CC  {}
;


simpleexpression: simpleexpression OR andexpression {  to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $3->addr;
    to_return_expr->dtype = $3->dtype;
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    $$ = to_return_expr; }

|andexpression { to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    to_return_expr->dtype = $1->dtype;
    to_return_expr->code = (char *)malloc(100);
     strcpy(to_return_expr->code,$1->code);
    $$ = to_return_expr; }
;

andexpression: andexpression AND unaryrelexpression      {
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $3->addr;
    to_return_expr->dtype = $3->dtype;
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    $$ = to_return_expr; }
|unaryrelexpression {
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    to_return_expr->dtype = $1->dtype;
    to_return_expr->code = (char *)malloc(100);
    strcpy(to_return_expr->code,$1->code);
    $$ = to_return_expr;
    printf("unaryrelexpression ka $$->code--- %s\n",$$->code);
}
;

unaryrelexpression: '!' unaryrelexpression  {}
|relexpression               {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
printf("relexpression ka $1->code--- %s\n",$1->code);
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    to_return_expr->dtype = $1->dtype;
  to_return_expr->code = (char *)malloc(100);
    strcpy(to_return_expr->code,$1->code);
    $$ = to_return_expr;
    printf("relexpression ka toreturnexpr->code--- %s\n",to_return_expr ->code);

        printf("relexpression ka $$ -- > %s\n",$$->code); 
}
;

relexpression: sumexpression COMPARE sumexpression   {
        to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
  to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
                            if($1==0&&$3==0)
                                  to_return_expr->dtype = 0;

                            else    to_return_expr->dtype = $1->dtype;
                      $$ = to_return_expr;  
;}
|sumexpression   {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    to_return_expr->dtype = $1->dtype;
  to_return_expr->code = (char *)malloc(100);
    strcpy(to_return_expr->code,$1->code);
    $$ = to_return_expr; 
    printf("sumexpression ka $$ -- > %s\n",$$->code);
     }
;

sumexpression: sumexpression sumop term    {

    printf("Addition : ");
      to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = newTemp();

    to_return_expr->dtype = $3->dtype;

    ret = (char *)malloc(20);
    ret[0] = 0;
    printf("\n\nin addition/subtraction : %s\n\n",$1);

    strcat(ret,to_return_expr->addr);

    strcat(ret,"=");
    strcat(ret,$1->addr);
    strcat(ret,$2->addr);
    strcat(ret,$3->addr);
    printf("RET  = ");
    puts(ret);
    printf("temp initaialised\n");
    printf("all codes : %d %d %d\n",strlen($1->code),strlen($3->code),strlen(ret));
    temp = (char *)malloc(strlen($1->code)+strlen($3->code)+strlen(ret)+6);
    printf("temp initaialised\n");
    temp[0] = 0;
    
    if ($1->code[0]!=0){
      strcat(temp,$1->code);
      strcat(temp,"\n");
      }
    if ($3->code[0]!=0){
      strcat(temp,$3->code);
      strcat(temp,"\n");
      }

    strcat(temp,ret);
        printf("temp cooncatenated with ret\n");

    printf("TEMP = \n");

    puts(temp);

    to_return_expr->code = temp;
    $$ = to_return_expr;  
    printf(" add/sub $$ assigned!!\n");
  }
|term        {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    to_return_expr->dtype = $1->dtype;
    to_return_expr->code = (char *)malloc(100);
    strcpy(to_return_expr->code,$1->code);
    $$ = to_return_expr; printf("Term Done\n"); }
;

sumop: '+'   {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    strcpy(to_return_expr->addr,"+");
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    printf("in sumop sending %s\n ",to_return_expr->addr);
    $$ = to_return_expr;}
|'-'   {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    strcpy(to_return_expr->addr,"-");
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    printf("in sumop sending %s\n ",to_return_expr->addr);
    $$ = to_return_expr;}
;

term: term mulop unaryexpression    {
  
    printf("Multipictaoon : ");
      to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = newTemp();

    to_return_expr->dtype = $3->dtype;

    ret = (char *)malloc(20);
    ret[0] = 0;
    printf("\n\nin multi/divi : %s\n\n",$3->code);

    strcat(ret,to_return_expr->addr);

    strcat(ret,"=");
    strcat(ret,$1->addr);
    strcat(ret,$2->addr);
    strcat(ret,$3->addr);
    printf("RET  = ");
    puts(ret);
    printf("temp initaialised\n");
    printf("all codes : %d %d %d\n",strlen($1->code),strlen($3->code),strlen(ret));
    temp = (char *)malloc(strlen($1->code)+strlen($3->code)+strlen(ret)+6);
    printf("temp initaialised\n");
    temp[0] = 0;
    
    if ($1->code[0]!=0){
      strcat(temp,$1->code);
      strcat(temp,"\n");
      }
    if ($3->code[0]!=0){
      strcat(temp,$3->code);
      strcat(temp,"\n");
      }

    strcat(temp,ret);
        printf("int multi divi temp cooncatenated with ret\n");

    printf("TEMP = \n");

    puts(temp);

    to_return_expr->code = temp;
    $$ = to_return_expr;  
    printf("multi div $$ assigned!!\n");

}
|unaryexpression                    {
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    to_return_expr->dtype = $1->dtype;
  to_return_expr->code = (char *)malloc(100);
    strcpy(to_return_expr->code,$1->code);
    $$ = to_return_expr;  }
;

mulop: '/'  {
    to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    strcpy(to_return_expr->addr,"/");
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    printf("in sumop sending %s\n ",to_return_expr->addr);
    $$ = to_return_expr;}

|'*'  {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    strcpy(to_return_expr->addr,"*");
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    printf("in sumop sending %s\n ",to_return_expr->addr);
    $$ = to_return_expr;}

|'%'  {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    strcpy(to_return_expr->addr,"%");
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    printf("in sumop sending %s\n ",to_return_expr->addr);
    $$ = to_return_expr;}
;

unaryexpression: unaryop unaryexpression  {}
|factor      {to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    to_return_expr->code = (char *)malloc(100);
    strcpy(to_return_expr->code,$1->code);
    to_return_expr->dtype = $1->dtype;
      printf("\nfactor sending %s\n\n ",to_return_expr->addr);

    $$ = to_return_expr;  }
;

unaryop: '-'
|'*'
|'?'
;

factor: mutable   {
printf("\nim in mutable\n");
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    to_return_expr->code = (char *)malloc(100);
    strcpy(to_return_expr->code,$1->code);
    to_return_expr->dtype = $1->dtype;
      printf("\nmutable sending %s\n\n ",to_return_expr->addr);

    $$ = to_return_expr;  }
|immutable   {
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1->addr;
    to_return_expr->dtype = $1->dtype;
  
    $$ = to_return_expr;        }
;

mutable: ID {{ 
printf("\nim in mutable ID\n");
if(checkid($1)==-1)
          printf("\n%d Error: %s Undeclared!\n",linecount+1,$1);
        if(checkid($1)==-1)
          printf("\n%d Error: %s Undeclared!\n",linecount+1,$1);}
          to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    to_return_expr->code = (char *)malloc(100);
    to_return_expr->code[0] = 0;
    to_return_expr->dtype = checktype($1);
    printf("\nmutable ID sending %s\n\n ",to_return_expr->addr);
    $$ = to_return_expr;
        }
|mutable '[' sumexpression ']' {int c=checkidarray($1); 
if(c==0)
printf("\n%d Error: %s Undeclared!\n",linecount+1,$1);
else if(c==-1)
printf("\n%d Error: Non array variable %s has a subscript!\n",linecount+1,$1);
}  
;

immutable: '(' sumexpression ')'  {}
|constant   { 
        to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    to_return_expr->dtype = $1->dtype;
  
    $$ = to_return_expr;      
        }
|call { $$=$1;}
;


call: ID '(' args ')' 
{ int f=checkfuncdef($1);
  int glag=0;
  if(f==0) 
    {   glag=1;
       printf("\n%d Error: Function %s not defined! Illegal Call!\n",linecount+1,$1);
      }
  else 
    if(f==-1) { glag=1;
                 printf("\n%d Error: %s is not a function\n",linecount+1,$1);
                }
else   
if(checknumarg($1)==0)        //Checking if number of parameters and arguments match
{
printf("\n%d Error: Number of arguments in the function call don't match with definition!\n",linecount+1);
  glag=1;

}

else 
{
  if(checktypearg($1)==-1)
  printf("\n%d Error: Type of Arguments Passed and Parameters don't match for %s!\n",linecount+1,$1);
  glag=1;
}
callargcount=0;
argindex=0;

if(glag==0)
{
$$=checktype($1);
}
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
int c=checkconsttype($1); 
to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    
if(c==0) 
    to_return_expr->dtype = 0;
else if(c==1)
    to_return_expr->dtype = 1;
$$ = to_return_expr;

}  
|CHARCONST { to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    to_return_expr->dtype = 2;
    
    $$ = to_return_expr;}
|STRING { to_return_expr = (struct exprType *)malloc(sizeof(struct exprType));
    to_return_expr->addr = (char *)malloc(20);
    to_return_expr->addr = $1;
    to_return_expr->dtype = 2;
    
    $$ = to_return_expr;}
;

%%

extern int yylex();
extern int yyparse();
extern FILE* yyin;

int main()
{
  
  // open a file handle to a particular file:
  FILE *myfile = fopen("icgtest.c", "r");
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
  
  printfinalsym();
  
}
yyerror(char *s) {
  printf("Parsing Unsuccessful\n");
  printf("Error in line: %d\n",linecount+1);
}
