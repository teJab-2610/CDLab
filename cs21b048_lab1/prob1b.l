%option noyywrap

%{
	void myprint(char*, char*);
     	int count_x=0, count_y =0, count_z =0, extras = 0;
%}

%%
x	{count_x = count_x + 1; myprint("" , yytext);}
y	{count_y = count_y + 1; myprint("" , yytext);}
z 	{count_z = count_z + 1; myprint("" , yytext);}
.	{extras = extras+1;	myprint("" , yytext);}	
\n	{	
		if(extras ==0 & count_x ==0 && count_y==0 && count_z==0){
			printf("	ACCEPTED as epsilon.\n");
		}
		else if(extras>0)
			printf("	:REJECTED (String not formed with given Alphabets.)\n");
		else if(count_x%2 == count_y%3){
	     		printf("	:ACCEPTED in given language.\n");
	     	}
	    	else{
			printf("	:REJECTED in given language.\n");
	    	}
	    	count_x=0;
	    	count_y=0;
	    	count_z=0;
	    	extras=0;
	}


%%

int main(int argc , char* argv[])
{
	printf("\nRESULT :\n");
	if(argc>1){
	FILE *fp = fopen(argv[1],"r");
	if(fp)
	yyin = fp;
	}
	 yylex();
	 return 0;
}

void myprint(char* token, char* lexeme){

	printf("%s%s", token, lexeme);
}
