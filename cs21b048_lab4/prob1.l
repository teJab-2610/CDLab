%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap  

%{
int E();
int Edash();
int T();
int Tdash();
int F();
char string[1000];
char tokenized_string[1000];
const char* cursor;
int pos=0;
void tokenise(char *token, char *lexeme);
%}

var [a-zA-Z][.a-zA-Z0-9]*|[_a-zA-Z0-9]*
num [0-9]+
id {var}|{num}
SUM [+]
PRODUCT [*]
OPENPARA [(]
CLOSEPARA [)]
%%
{id} {
    tokenise("id", yytext);  
}
{SUM} {
    tokenise("sum", yytext);  
}
{PRODUCT} {
    tokenise("product", yytext);
}
{OPENPARA} {
    tokenise("openpara", yytext);
}
{CLOSEPARA} {
    tokenise("closepara", yytext);
}
[ \t]*            {}
[\n]             { tokenise("newline", yytext);}
<<EOF>>                   { tokenise("error", yytext); return 0;}   
%%

void tokenise(char *token, char *lexeme) {
    if(token == "id"){
        strcat(string, lexeme);
        tokenized_string[pos++] = 'i';
    }
    else if(token == "sum"){
        tokenized_string[pos++] = '+';
        strcat(string, lexeme);
    }
    else if(token == "product"){
        strcat(string, lexeme);
        tokenized_string[pos++] = '*';
    }
    else if(token == "openpara"){
        strcat(string, lexeme);
        tokenized_string[pos++] = '(';
    }
    else if (token == "closepara"){
        strcat(string, lexeme);
        tokenized_string[pos++] = ')';
    }
    else if(token == "newline"){
       
      
            cursor = &tokenized_string[0];
            if (E() && *cursor == '\0') {
                printf(" %s -> SUCCESSFULLY PARSED\n", string);
            } 
            else {
            printf(" %s -> FAILED PARSING\n", string);
            }
            memset(string, 0, sizeof(string));
            memset(tokenized_string, 0, sizeof(tokenized_string));
            pos = 0;
        
        
    }
    else if(token == "error" ){
        cursor = &tokenized_string[0];
        if (E() && *cursor == '\0') {
            printf(" %s -> SUCCESSFULLY PARSED\n", string);
        }
        else if(pos != 0){
        printf(" %s -> FAILED PARSING\n", string);
        }
        memset(string, 0, sizeof(string));
        memset(tokenized_string, 0, sizeof(tokenized_string));
        pos = 0;
        printf("DONE!");
    }
} 

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (fp == NULL) {
        printf("Error opening file\n");
        return 1;
    }

    yyin = fp;
    yylex();

    fclose(fp);
    return 0;
}

int E() {
    if (T()) {  
        if (Edash())  
            return 1;  
        else  
            return 0;  
    } else  
        return 0;  
}

int Edash() {
      if (*cursor == '+') {  
    
        cursor++;  
        if (T()) {  
            if (Edash())  
                return 1;  
            else  
                return 0;  
        } else  
            return 0;  
    } else {  
    
        return 1;  
    }  
}

int T() {
    
    if (F()) {  
        if (Tdash())  
            return 1;  
        else  
            return 0;  
    } else  
        return 0;
}

int Tdash() {
    if (*cursor == '*') {  
        
        cursor++;  
        if (F()) {  
            if (Tdash())  
                return 1;  
            else  
                return 0;  
        } else  
            return 0;  
    } else {  
        
        return 1;  
    }  
}

int F() {
    if (*cursor == '(') {  
       
        cursor++;  
        if (E()) {  
            if (*cursor == ')') {  
                cursor++;  
                return 1;  
            } else  
                return 0;  
        } else  
            return 0;  
    } else if (*cursor == 'i') {  
        cursor++;  
       
        return 1;  
    } else  
        return 0;  
}
