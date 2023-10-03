%option noyywrap
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "y.tab.h"
%}
NUM [0-9]+ 
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*

%%
{NUM}|{NUM}"."{NUM}      {yylval.dval=atoi(yytext); ECHO;return NUMBER;}
{IDENTIFIER} {strcpy(yylval.lexeme,yytext); ECHO; return ID;}
"++"         {ECHO; return INCREMENT;}
"--"         {ECHO; return DECREMENT;}
"+"          {ECHO; return PLUS;}
"-"          {ECHO; return MINUS;}
"="          {ECHO; return ASSIGN;}
"*"          {ECHO; return MULTIPLY;}
"/"          {ECHO; return DIVIDE;}
"("          {ECHO; return LPAREN;}
")"          {ECHO; return RPAREN;}
[ \t]        {ECHO;}
";"          {ECHO; return SEPERATOR;}
[\n]+        {ECHO; return EOL;}
<<EOF>>      {ECHO; return EOFf;}
.            {printf("ignored :%s",yytext);;}
%%