%{
	char *floatbuffer[10];
	int floati=0;
	int floatn=0;
	int floatlengths[50];

	char *charbuffer[10];
	int chari=0;
	int charn=0;
	int charlengths[50];

	char *strlenbuffer[10];
	int strleni=0;
	int strlenn=0;
	int strlenlengths[50];

	char *whilebuffer[10];
	int whilei=0;
	int whilen=0;
	int whilelengths[50];

%}
floatvar [f][l][o][a][t][ |\n|\t]*[a-zA-Z]+[0-9a-zA-Z]*
charvar [c][h][a][r][ |\n|\t]*[a-zA-Z]+[0-9a-zA-Z]*
strlenvar [s][t][r][l][e][n][(](["][0-9a-zA-Z]*["]|[a-zA-Z]+[0-9a-zA-Z]*)[)]
whilevar [w][h][i][l][e][ |\n|\t]*[(].*[)][ |\n|\t]*[{][a-zA-Z|\n|\t0-9|\.|+|\/|-|\*|;]*[}]
%%
{floatvar} { floatbuffer[floati]=yytext;
			 floatlengths[floati]=yyleng;
			 floati++;
			 floatn++;
			 
		   }

{charvar} { charbuffer[chari]=yytext;
			 charlengths[chari]=yyleng;
			 chari++;
			 charn++;
			 
		   }

{strlenvar} {strlenbuffer[strleni]=yytext;
			 strlenlengths[strleni]=yyleng;
			 strleni++;
			 strlenn++;
			}

{whilevar} {
			whilebuffer[whilei]=yytext;
			 whilelengths[whilei]=yyleng;
			 whilei++;
			 whilen++;

		}

%%
int main()
{
	yyin = fopen("program.txt","r");
	yylex();
	int k,j;
	printf("\n\n\n\nRESULT\n\n");

/*float keyword*/
	for(k=0;k<floatn;k++)
	{

		for(j=0;j<floatlengths[k];j++)
		{

			printf("%c", floatbuffer[k][j]);
		}
		printf("\n");
		printf("float is a keyword\n");
		for(j=5;j<floatlengths[k];j++)
		{
			if(floatbuffer[k][j]!=' '&&floatbuffer[k][j]!='\t'&&floatbuffer[k][j]!='\n')
			break;
		}
		for(j=j;j<floatlengths[k];j++)
			printf("%c",floatbuffer[k][j]);
		printf(" is an identifier\n");
		printf("\n\n");
	}

/*char keyword*/
	for(k=0;k<charn;k++)
	{

		for(j=0;j<charlengths[k];j++)
		{

			printf("%c", charbuffer[k][j]);
		}
		printf("\n");
		printf("char is a keyword\n");
		for(j=4;j<charlengths[k];j++)
		{
			if(charbuffer[k][j]!=' '&&charbuffer[k][j]!='\t'&&charbuffer[k][j]!='\n')
			break;
		}
		for(j=j;j<charlengths[k];j++)
			printf("%c",charbuffer[k][j]);
		printf(" is an identifier\n");
		printf("\n\n");
	}

/*strlen function*/
	int literalflag=0;
	for(k=0;k<strlenn;k++)
	{
		literalflag=0;
		for(j=0;j<strlenlengths[k];j++)
		{

			printf("%c", strlenbuffer[k][j]);
		}
		printf("\n");
		printf("strlen is a function name\n");
		for(j=7;j<strlenlengths[k];j++)
		{
			if(strlenbuffer[k][j]=='"')
			{
				literalflag=1;
				j++;
				while(strlenbuffer[k][j]!='"')
				{
					printf("%c",strlenbuffer[k][j]);
					j++;
				}
				printf(" is a literal\n");
				
			}
			break;
		}
		if(literalflag==0)
		{
			for(j=7;j<strlenlengths[k]-1;j++)
			{
				printf("%c",strlenbuffer[k][j]);
			}
			printf(" is a identifier\n");
		}
	}
/*While loop*/
	for(k=0;k<whilen;k++)
	{

		for(j=0;j<whilelengths[k];j++)
		{

			printf("%c", whilebuffer[k][j]);
		}
		printf("\n");
		printf("while is a keyword (loop)\n");
		for(j=5;j<whilelengths[k];j++)
		{
			if(whilebuffer[k][j]!=' '&&whilebuffer[k][j]!='\t'&&whilebuffer[k][j]!='\n'&&whilebuffer[k][j]!='(')
			break;
		}
		for(j=j;whilebuffer[k][j]!=')';j++)
			printf("%c",whilebuffer[k][j]);
		printf(" is the condition for while\n");
		
	}
}

int yywrap()
{
	return 1;
}
