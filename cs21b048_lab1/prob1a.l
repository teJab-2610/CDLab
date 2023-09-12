/*
Regex for a string not containing 00: (1+01)*(E+0)

Similarly for a string containing 111 as substring: (1+0)* 111 (1+0)*

From the above two statements we can deduce that the regex for a string not containing 00 and 111 as substring is: (1+01)*(E+0) 111 (1+01)*(E+0)
*/

%option noyywrap

%{
    void myprint(char*, char*);
%}

%%
(1|01)*0?111(1|01)*0?			 {myprint("Accepted",yytext);}
.*	                     {myprint("Not Accepted",yytext);}

%%

int main()
{
     printf("\nResult :\n");
	 yylex();
	 return 0;
}

void myprint(char* token, char* lexeme){
	printf("%s for the input %s\n", token, lexeme);
}