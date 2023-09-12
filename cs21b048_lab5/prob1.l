%option noyywrap
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "y.tab.h"
%}
NUM [0-9]+ 
IOTA [i]
%%
{NUM}        {ECHO;//printf("lex identified num: %s \n",yytext);
                return NUMBER;}
{IOTA}       {ECHO;//printf("lex identified i: %s \n",yytext);
                return I;}
"+"          {ECHO;//printf("lex identified +: %s \n",yytext);
                return PLUS;}
"-"          {ECHO;//printf("lex identified -: %s \n",yytext);
                return MINUS;}
[ \t]        //{ printf("lex identified space tab: %s \n",yytext);}
";"          {//printf("lex identified ;: %s \n",yytext);
                return SEPERATOR;}
[\n]+           {//printf("\n");
                return EOL;}
<<EOF>>      {//printf("lex identified EOF: %s \n",yytext);
                return EOFf;}
[^0-9i\+\-\;\n]*/[;\n<<EOF>>]            {ECHO;//printf("lex identified invalid: %d \n",(yytext[0]));
return NOTVALIDINPUT;}
%%