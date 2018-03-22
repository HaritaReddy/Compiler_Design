%token ID NUM WHILE
%right '='
%left '+' '-'
%left '*' '/'
%left UMINUS
%%

S : WHILE{lab1();} '(' E ')'{lab2();} E ';'{lab3();}
  ;
E :V '='{ push("=");} E{codegen_assign();}
  | E '+'{ push("+");} E{codegen();}
  | E '-'{ push("-");} E{codegen();}
  | E '*'{ push("*");} E{codegen();}
  | E '/'{ push("/");} E{codegen();}
  | '(' E ')'
  | '-'{push("-");} E{codegen_umin();} %prec UMINUS
  | V
  | NUM{push($1);}
  ;
V : ID {push($1);}
  ;
%%
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include<ctype.h>
char st[100][10];
int top=0;
char i_[2]="0";
char temp[2]="t";
extern int yylex();
extern int yyparse();
extern FILE* yyin;
int lnum=1;
int start=1;
main()
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
 }

yyerror(char *s) {
  printf("yytext: %s\n",s);
  printf("Parsing Unsuccessful\n");
}
  


push(char *text)
 {
  strcpy(st[++top],text);
 }

codegen()
 {
 strcpy(temp,"t");
 strcat(temp,i_);
  printf("%s = %s %s %s\n",temp,st[top-2],st[top-1],st[top]);
  top-=2;
 strcpy(st[top],temp);
 i_[0]++;
 }

codegen_umin()
 {
 strcpy(temp,"t");
 strcat(temp,i_);
 printf("%s = -%s\n",temp,st[top]);
 top--;
 strcpy(st[top],temp);
 i_[0]++;
 }

codegen_assign()
 {
 printf("%s = %s\n",st[top-2],st[top]);
 top-=2;
 }



lab1()
{
printf("L%d: \n",lnum++);
}


lab2()
{
 strcpy(temp,"t");
 strcat(temp,i_);
 printf("%s = not %s\n",temp,st[top]);
 printf("if %s goto L%d\n",temp,lnum);
 i_[0]++;
 }

lab3()
{
printf("goto L%d \n",start);
printf("L%d: \n",lnum);
}