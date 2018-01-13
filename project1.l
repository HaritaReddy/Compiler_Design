%{#include<string.h>
	
	char *floatbuffer[10];
	int floati=0;
	int floatn=0;
	int floatlengths[50];

	char *charbuffer[10];
	int chari=0;
	int charn=0;
	int charlengths[50];

	char *charptrbuffer[10];
	int charptri=0;
	int charptrn=0;
	int charptrlengths[50];

	struct node
	{
		char name[50];
		char class[50];
		struct node* next;
	} *symtable[53];

	int poscalc(char* name)
	{
		int i,pos=0;
		for(i=0;i<strlen(name);i++)
		{
			pos=pos+name[i];
		}
		printf("Position calc\n");
		pos=pos%8;
		return pos;

	}

	void insert(char* name,char* class)
	{
		int pos=poscalc(name);
		if(symtable[pos]==NULL)
		{
			printf("Condition entered\n");
			symtable[pos]=(struct node*)malloc(sizeof(struct node));
			strcpy(symtable[pos]->name,name);
			printf("aa\n");

			strcpy(symtable[pos]->class,class);
			symtable[pos]->next=NULL;
			printf("entered first element\n");
		}
		else
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

%}
alpha [a-zA-Z]
digit [0-9]
scomment [/][/].*[\n]
mcomment [/][*](.*[\n].*)*[*][/]
preprocessor [#].+
floatvar [f][l][o][a][t][ |\n|\t]+[a-zA-Z0-9_]+
charvar [c][h][a][r][ |\n|\t]+[a-zA-Z0-9_]+ 
floatcap [Ff][Ll][Oo][Aa][Tt][ |\n|\t]+[a-zA-Z0-9_]+
charcap [Cc][Hh][Aa][Rr][ |\n|\t]+[a-zA-Z0-9_]+
charptr [c][h][a][r][*][*][ |\n|\t]+[a-zA-Z0-9_]+ 
kw ("auto")|("break")|("case")|("const")|("continue")|("main")|("default")|("do")|("double")|("else")|("enum")|("extern")|("for")|("goto")|("if")|("int")|("long")|("register")|("return")|("short")|("signed")|("sizeof")|("static")|("struct")|("switch")|("typedef")|("union")|("unsigned")|("void")|("volatile")|("while")
whilevar [w][h][i][l][e]
strvar ["][a-zA-Z0-9]*["]
id [a-zA-Z][a-zA-Z0-9_]*
wrongid [0-9_][a-zA-Z0-9_]+
unaryop ("++")|("--")
op [+\-*%=<>{}()/]|"=="

strlenvar [s][t][r][l][e][n][(](["][{digit}|{alpha}]*["]|[{alpha}]+[{digit}|{alpha}]*)[)]
constant -?(([0-9]+)|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)
charconstant [\'].*[\']
delimiter [;]


%%
{scomment} {
	printf("Its a comment : %s\n",yytext);
	
}

{mcomment} {
	printf("Its a comment : %s\n",yytext);
}

{preprocessor} {
	printf("Its a preprocessor directive: %s\n",yytext);
}

{floatvar} { 
			floatbuffer[floati]=yytext;
			 floatlengths[floati]=yyleng;
			 floati++;
			 floatn++;
			 
		  }
{floatcap} {
	printf("Error : %s : Did you mean 'float'?\n",yytext);
}
{charvar} { charbuffer[chari]=yytext;
			 charlengths[chari]=yyleng;
			 chari++;
			 charn++;
		   }
{charcap} {
	printf("Error : %s : Did you mean 'char'?\n",yytext);
}
{charptr} { charptrbuffer[charptri]=yytext;
			 charptrlengths[charptri]=yyleng;
			 charptri++;
			 charptrn++;
		   }
{whilevar} {
			
			 printf("\n%s is a keyword(loop)\n",yytext);

		}
{strvar} {
	printf("\n%s is a string\n",yytext);
}
{kw} {
	printf("\n%s is a keyword\n",yytext);
	insert(yytext,"keyword");
}
{delimiter} {
	printf("\n%s is the delimiter\n",yytext);
}
{unaryop} {
	printf("\n%s is a unary operator\n",yytext);
}
{op} {
	printf("\n%s is an operator\n",yytext);
}


{id} {
	printf("\n%s is an identifier\n",yytext);
}
{wrongid}
{
	printf("Wrong Token!\n");
}


{strlenvar} {
			}

{constant} {

	printf("\n%s is a constant\n",yytext);
}

{charconstant} {
	printf("%s is a character constant\n",yytext);
}


%%
int main()
{
	yyin = fopen("test_case_1.c","r");
	yylex();
	
printf("\n\n\n\nRESULT\n\n");
int k,j;
	for(k=0;k<floatn;k++)
	{

		for(j=0;j<floatlengths[k];j++)
		{

			printf("%c", floatbuffer[k][j]);
		}
		printf("\n");
		printf("float is a keyword\n");
		int p;
		for(p=5;p<floatlengths[k];p++)
		{
			if(floatbuffer[k][p]!=' ')
			break;
		}
		if(floatbuffer[k][p]>=48&&floatbuffer[k][p]<=57||floatbuffer[k][p]=='_')
		printf("Erroneous Identifier\n");
		else
		{
		for(j=5;j<floatlengths[k];j++)
		{
			if(floatbuffer[k][j]!=' '&&floatbuffer[k][j]!='\t'&&floatbuffer[k][j]!='\n')
			break;
		}
		for(j=j;j<floatlengths[k];j++)
			printf("%c",floatbuffer[k][j]);
		printf(" is a float identifier\n");
		printf("\n\n");
		}
	}

	for(k=0;k<charn;k++)
	{

		for(j=0;j<charlengths[k];j++)
		{

			printf("%c", charbuffer[k][j]);
		}
		printf("\n");
		printf("char is a keyword\n");
		int p;
		for(p=4;p<charlengths[k];p++)
		{
			if(charbuffer[k][p]!=' ')
			break;
		}
		if(charbuffer[k][p]>=48&&charbuffer[k][p]<=57||charbuffer[k][p]=='_')
		printf("Erroneous Identifier\n");
		else
		{
		for(j=4;j<charlengths[k];j++)
		{
			if(charbuffer[k][j]!=' '&&charbuffer[k][j]!='\t'&&charbuffer[k][j]!='\n')
			break;
		}
		for(j=j;j<charlengths[k];j++)
			printf("%c",charbuffer[k][j]);
		printf(" is a char identifier\n");
		printf("\n\n");
		//Hi
	}
	}

	for(k=0;k<charptrn;k++)
	{
		for(j=0;j<charptrlengths[k];j++)
		{

			printf("%c", charptrbuffer[k][j]);
		}
		printf("\n");
		printf("char** is a char pointer\n");
		int p;
		for(p=6;p<charptrlengths[k];p++)
		{
			if(charptrbuffer[k][p]!=' ')
			break;
		}
		if(charptrbuffer[k][p]>=48&&charptrbuffer[k][p]<=57||charptrbuffer[k][p]=='_')
		printf("Erroneous pointer Identifier\n");
		else
		{
		for(j=6;j<charptrlengths[k];j++)
		{
			if(charptrbuffer[k][j]!=' '&&charptrbuffer[k][j]!='\t'&&charptrbuffer[k][j]!='\n')
			break;
		}
		for(j=j;j<charptrlengths[k];j++)
			printf("%c",charptrbuffer[k][j]);
		printf(" is a char pointer identifier\n");
		printf("\n\n");
		//Hi
	}
	}
	
	for(j=0;j<8;j++)
	{
		printf("Position: %d\t",j);
		struct node* ptr=symtable[j];
		while(ptr!=NULL)
		{
			printf("%s\t%s |\t",ptr->name,ptr->class);
			ptr=ptr->next;
		}
		printf("\n");
	}

}

int yywrap()
{
	return 1;
}
