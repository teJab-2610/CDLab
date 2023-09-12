%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yyerror(char *s);
extern FILE * yyin;
#define YYSTYPE int
%}
%token NUMBER I PLUS MINUS SEPERATOR EOL EOFf NOTVALIDINPUT
%start Start
%%
Start    :
          Complex       EOL {printf("\t\tVALID\n\n");} Start 
        | Complex       SEPERATOR  {printf("\t\tVALID\n\n");}Start 
        | Complex       EOFf {printf("\t\tVALID\n\n");}  {printf("Completed\n");return 0;}
        | EOL           Start  
        | SEPERATOR     {printf("No number found INVALID\n\n");} Start 
        | error         EOL {printf("\t\tINVALID\n\n");}  Start 
        | error         SEPERATOR {printf("\t\tINVALID\n\n");} Start 
        | error         EOFf{printf("\t\tINVALID\n\n");} {return 0;} {printf("Completed\n");}
        | NOTVALIDINPUT SEPERATOR{printf("\t\tINVALID\n\n");}   Start  
        | NOTVALIDINPUT EOFf {printf("\t\tINVALID\n\n");}    {return 0;}
        | NOTVALIDINPUT EOL {printf("\t\tINVALID\n\n");}    Start  
        | EOFf          {printf("Completed\n\n");} {return 0;}
        ;
SIGN     : PLUS | MINUS | ;
OPERATOR : PLUS | MINUS ;

Complex   : SIGN NUMBER 
          | SIGN NUMBER I
          | SIGN I
          | SIGN I OPERATOR NUMBER
          | SIGN NUMBER OPERATOR I
          | SIGN I NUMBER
          | SIGN NUMBER OPERATOR I NUMBER
          | SIGN NUMBER OPERATOR NUMBER I
          | SIGN NUMBER I OPERATOR NUMBER
          | SIGN I NUMBER OPERATOR NUMBER 
          ;
%%
int yyerror(char *s)
{
    return 0;
}
int main(int argc, char **argv)
{
    if(argc < 2)
    {
        printf("Usage: %s <filename>\n", argv[0]);
        exit(1);
    }
    FILE *fp = fopen(argv[1], "r");
    if(fp == NULL)
    {
        printf("Error opening file %s\n", argv[1]);
        printf("taking input from stdin\n");
        yyin = stdin;
    }
    else { yyin = fp; }
    yyparse();
    return 0;
}
int yyterminate()
{
    return 1;
}