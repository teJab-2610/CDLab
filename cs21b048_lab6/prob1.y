%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yyerror(char *s);
extern FILE * yyin;
#define YYSTYPE int
%}
%token NUMBER ID PLUS MINUS INCREMENT DECREMENT ASSIGN MULTIPLY DIVIDE LPAREN RPAREN SEPERATOR EOL EOFf NOTVALIDINPUT
%start Start
%%
Start       : EQN Start
            | EOL Start
            | EOL EOFf { return 0;}
            | EQN 
            | EOFf { return 0;}
            ;
EQN         : INCREMENT ID SEPERATOR { printf("\t\tValid\n\n"); }
            | DECREMENT ID SEPERATOR { printf("\t\tValid\n\n"); }
            | ID INCREMENT SEPERATOR { printf("\t\tValid\n\n"); }
            | ID DECREMENT SEPERATOR { printf("\t\tValid\n\n"); }
            | ID ASSIGN EXPRESSION SEPERATOR { printf("\t\tValid\n\n"); }
            | error SEPERATOR { printf("\t\tInvalid\n\n"); }
            | error EOL { printf("\t\tInvalid \n\n"); }
            | error EOFf { printf("\t\tInvalid \n\n"); return 0;}
            | SEPERATOR { printf("\t\tNo equation\n\n"); }
            ;
EXPRESSION  : EXPRESSION PLUS {;} TERM 
            | EXPRESSION MINUS {;}TERM 
            | SIGN TERM {;}
            ;
TERM        : TERM MULTIPLY {;} SIGN FACTOR 
            | TERM DIVIDE SIGN FACTOR {;}
            | SIGN FACTOR {;}
            ;
FACTOR      : NUMBER {;}
            | ID {;}
            | LPAREN EXPRESSION RPAREN {;}
            | INCREMENT ID {;}
            | DECREMENT ID {;}
            | ID INCREMENT {;}
            | ID DECREMENT {;}
            | ID ASSIGN EXPRESSION {;}
            ;
SIGN        : PLUS 
            | MINUS 
            |
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
