%option noyywrap

%{
	 void myprint(char*, char*);
%}

/*
For X and W parts of the string we can use [a-d]+ and for Z we can say ^[a-d]
Y can be a or b or c or d which gives us four cases and they can joined together using OR as below
*/

%%
([a-d]+a)[^a-d]([a-d]+a)|([a-d]+b)[^a-d]([a-d]+b)|([a-d]+c)[^a-d]([a-d]+c)|([a-d]+d)[^a-d]([a-d]+d)	{myprint(yytext, " ACCEPTED in language." );}
.*						{myprint(yytext," REJECTED in language.");}


%%

int main(int argc, char* argv[])
{
	if(argc>1){
		FILE *fp = fopen(argv[1],"r");
		if(fp){
			yyin = fp;
		}
	}
	yylex();
	return 0;
}

void myprint(char* token, char* lexeme){

	printf("\n %s %s\n", token, lexeme);

}
