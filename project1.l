%{
	#include<string.h>
	
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
		int count;
		struct node* next;
	} *symtable[53],*constable[53];

	int poscalc(char* name)
	{
		int i,pos=0;
		for(i=0;i<strlen(name);i++)
		{
			pos=pos+name[i];
		}
		pos=pos%53;
		return pos;

	}
	int poscalccons(char* name)
	{
		int i,pos=0;
		for(i=0;i<strlen(name);i++)
		{
			pos=pos+name[i];
		}
		pos=pos%53;
		return pos;

	}
	void insert(char* name,char* class)
	{
		int pos=poscalc(name);
		if(symtable[pos]==NULL)
		{
			symtable[pos]=(struct node*)malloc(sizeof(struct node));
			strcpy(symtable[pos]->name,name);

			strcpy(symtable[pos]->class,class);
			symtable[pos]->next=NULL;
			symtable[pos]->count=1;
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
				check->count++;
				break;
			}
				check=check->next;
			}
			if(flag==1)
			return;
			struct node* ptr=(struct node*)malloc(sizeof(struct node));
			strcpy(ptr->name,symtable[pos]->name);
			strcpy(ptr->class,symtable[pos]->class);
			ptr->count=symtable[pos]->count;
			ptr->next=symtable[pos]->next;
			strcpy(symtable[pos]->name,name);
			strcpy(symtable[pos]->class,class);
			symtable[pos]->next=ptr;
			symtable[pos]->count=1;
		}
	}
	void insertincons(char* name,char* class)
	{
		int pos=poscalc(name);
		if(constable[pos]==NULL)
		{
			constable[pos]=(struct node*)malloc(sizeof(struct node));
			strcpy(constable[pos]->name,name);

			strcpy(constable[pos]->class,class);
			constable[pos]->next=NULL;
			constable[pos]->count=1;
		}
		else
		{	
			int flag=0;
			struct node* check=constable[pos];
			while(check!=NULL)
			{
				if(strcmp(check->name,name)==0)
				{
				flag=1;
				check->count++;
				break;
			}
				check=check->next;
			}
			if(flag==1)
			return;
			struct node* ptr=(struct node*)malloc(sizeof(struct node));
			strcpy(ptr->name,constable[pos]->name);
			strcpy(ptr->class,constable[pos]->class);
			ptr->count=constable[pos]->count;
			ptr->next=constable[pos]->next;
			strcpy(constable[pos]->name,name);
			strcpy(constable[pos]->class,class);
			constable[pos]->next=ptr;
			constable[pos]->count=1;
		}
	}

	int commstart=0;
%}
alpha [a-zA-Z]
digit [0-9]
scomment [/][/].*[\n]
mcommentstart [/][*]
mcommentend [*][/]
charconstant [\'][a-zA-Z][\']
preprocessor [#].+
floatvar [f][l][o][a][t][ |\n|\t]+[a-zA-Z0-9_]+
charvar [c][h][a][r][ |\n|\t]+[a-zA-Z0-9_]+ 
floatcap [Ff][Ll][Oo][Aa][Tt][ |\n|\t]+[a-zA-Z0-9_]+
charcap [Cc][Hh][Aa][Rr][ |\n|\t]+[a-zA-Z0-9_]+
charptr [c][h][a][r][*]+[ |\n|\t]+[a-zA-Z0-9_]+ 
kw ("float")|("char")|("auto")|("break")|("case")|("const")|("continue")|("main")|("default")|("do")|("double")|("else")|("enum")|("extern")|("for")|("goto")|("if")|("int")|("long")|("register")|("return")|("short")|("signed")|("sizeof")|("static")|("struct")|("switch")|("typedef")|("union")|("unsigned")|("void")|("volatile")|("while")
whilevar [w][h][i][l][e]
strvar ["][a-zA-Z0-9]*["]
id [a-zA-Z][a-zA-Z0-9_]*
unaryop ("++")|("--")
op [+\-*%=<>/]|"=="
spchar [{}()]
strlenvar [s][t][r][l][e][n][(](["][{digit}|{alpha}]*["]|[{alpha}]+[{digit}|{alpha}]*)[)]
constant -?(([0-9]+)|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)
wrongid [0-9_][a-zA-Z0-9_]+|[a-zA-Z0-9]*[\&][a-zA-Z0-9]*
delimiter [;,]
stray [$&`@~]

%%
{scomment} {
	printf("%-20s : Comment\n",yytext);
	
}

{mcommentstart} {
	if(commstart==0)
	commstart++;
	
}

{mcommentend} {
	if(commstart==1)
	commstart--;
	else printf("\nStray symbols found : %s",yytext);
}
{preprocessor} {

	if(commstart==0)
	printf("%-20s : Preprocessor directive: \n",yytext);
}

{floatvar} { 
	if(commstart==0){
			floatbuffer[floati]=yytext;
			 floatlengths[floati]=yyleng;
			 floati++;
			 floatn++;
			 insert("float","keyword");
			 printf("%s : datatype declaration\n",yytext);
			}
		}
		{floatcap} {
			if(commstart==0)
	printf("Error : %s : Did you mean 'float'?\n",yytext);
}
{charvar} { 
	if(commstart==0){
			charbuffer[chari]=yytext;
			 charlengths[chari]=yyleng;
			 chari++;
			 charn++;
			 insert("char","keyword");
			 printf("%s : datatype declaration\n",yytext);
			}
		}


		{charcap} {
			if(commstart==0)
	printf("Error : %s : Did you mean 'char'?\n",yytext);
}
{charptr} { if(commstart==0){
			charptrbuffer[charptri]=yytext;
			 charptrlengths[charptri]=yyleng;
			 charptri++;
			 charptrn++;
			}
		}
		{charconstant} {
			if(commstart==0){
	printf("%-20s : character constant\n",yytext);
	insert(yytext,"constant");
	insertincons(yytext,"char");
}
}
{whilevar} {
	if(commstart==0){
			 printf("\n%-20s : keyword(loop)\n",yytext);
			 insert(yytext,"keyword");
			}
		}
		{strvar} {
			if(commstart==0){
	printf("\n%-20s : string\n",yytext);
	insert(yytext,"string literal");
	insertincons(yytext,"string");
}
}

{kw} {
	if(commstart==0){
	printf("\n%-20s : keyword\n",yytext);
	insert(yytext,"keyword");
}
}
{id} { if(commstart==0)
	{
	printf("\n%-20s : identifier\n",yytext);
	insert(yytext,"identifier");
}
}
{delimiter} {
	if(commstart==0){
	printf("\n%-20s : separator\n",yytext);
	insert(yytext,"separator");
}
}
{unaryop} {
	if(commstart==0){
	printf("\n%-20s : unary operator\n",yytext);
	insert(yytext,"unary operator");
}
}
{op} {
	if(commstart==0){
	printf("\n%-20s : operator\n",yytext);
	insert(yytext,"binary operator");
}
}

{spchar} {
	if(commstart==0){
	printf("\n%-20s : special character\n",yytext);
	insert(yytext,"sp. character");
}
}

{strlenvar} {
}

{constant} {
	if(commstart==0){
	int i=0;
	printf("\n%-20s : constant\n",yytext);
	insert(yytext,"constant");
	int isfloat=0;
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
}

}

{wrongid} {	if(commstart==0)
	printf("%s  : Invalid identifer\n",yytext);
}

{stray} {
	printf("%s : Stray character\n",yytext);
}



%%
int main()
{
	yyin = fopen("program.txt","r");
	yylex();
	
printf("\n\n\n\nRESULT\n\n");
int k,j;

if(commstart==1)
{
		printf("\nError : Unterminated Comment\n\n");
	}
	for(k=0;k<floatn;k++)
	{

		for(j=0;j<floatlengths[k];j++)
		{

			printf("%c", floatbuffer[k][j]);
		}
		printf("\n");
		printf("float : keyword\n");
		int p;
		for(p=5;p<floatlengths[k];p++)
		{
			if(floatbuffer[k][p]!=' ')
			break;
		}
		if(floatbuffer[k][p]>=48&&floatbuffer[k][p]<=57||floatbuffer[k][p]=='_')
		printf("Error: Invalid Identifier\n");
		else
		{
		for(j=5;j<floatlengths[k];j++)
		{
			if(floatbuffer[k][j]!=' '&&floatbuffer[k][j]!='\t'&&floatbuffer[k][j]!='\n')
			break;
		}
		char arr[32];
		int s=0;
		for(j=j;j<floatlengths[k];j++)
		{
			printf("%c",floatbuffer[k][j]);
			arr[s]=floatbuffer[k][j];
			s++;
		}
		arr[s]='\0';
		insert(arr,"identifier");
		printf(" : float identifier\n");
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
		printf("char : keyword\n");
		int p;
		for(p=4;p<charlengths[k];p++)
		{
			if(charbuffer[k][p]!=' ')
			break;
		}
		if(charbuffer[k][p]>=48&&charbuffer[k][p]<=57||charbuffer[k][p]=='_')
		printf("Error: Invalid Identifier\n");
		else
		{
		for(j=4;j<charlengths[k];j++)
		{
			if(charbuffer[k][j]!=' '&&charbuffer[k][j]!='\t'&&charbuffer[k][j]!='\n')
			break;
		}
		char arr[32];
		int s=0;
		for(j=j;j<charlengths[k];j++)
		{
			printf("%c",charbuffer[k][j]);
			arr[s]=charbuffer[k][j];
			s++;
		}
		arr[s]='\0';
		insert(arr,"identifier");
		printf(" : char identifier\n");
		printf("\n\n");
		
	}
}

	for(k=0;k<charptrn;k++)
	{
		for(j=0;j<charptrlengths[k];j++)
		{

			printf("%c", charptrbuffer[k][j]);
		}
		printf("\n");
		int starcount=0;
		for(j=0;j<charptrlengths[k];j++)
		{

			if(charptrbuffer[k][j]=='*')
			starcount++;
		}
		if(starcount==1)
		printf("char* : char pointer\n");
		else
		printf("char** : char pointer\n");
		int p;
		for(p=6;p<charptrlengths[k];p++)
		{
			if(charptrbuffer[k][p]!=' ')
			break;
		}
		if(charptrbuffer[k][p]>=48&&charptrbuffer[k][p]<=57||charptrbuffer[k][p]=='_')
		printf("Error: Invalid Identifier\n");
		else
		{
		for(j=6;j<charptrlengths[k];j++)
		{
			if(charptrbuffer[k][j]!=' '&&charptrbuffer[k][j]!='\t'&&charptrbuffer[k][j]!='\n')
			break;
		}
		char arr[32];
		int s=0;
		for(j=j;j<charptrlengths[k];j++)
		{
			printf("%c",charptrbuffer[k][j]);
			arr[s]=charptrbuffer[k][j];
			s++;
		}
		arr[s]='\0';
		insert(arr,"identifier");
		printf(" : char pointer identifier\n");
		printf("\n\n");
		
	}
}

	printf("--SYMBOL TABLE--\n");
	for(j=0;j<53;j++)
	{
		
		struct node* ptr=symtable[j];
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
	printf("\n\n--CONSTANTS TABLE--\n");
	for(j=0;j<53;j++)
	{
		
		struct node* ptr=constable[j];
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

int yywrap()
{
	return 1;
}
