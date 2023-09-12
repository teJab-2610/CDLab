%{
    #include<stdio.h>


%}

delim [ \t\n]
ws {delim}+
alphabet [a-zA-Z]
num [0-9]
Header \#(.*) 
ID [a-zA-Z_][a-zA-Z0-9_]*
INT [-+]?{num}+(E[-+]?{num}+)?
Float [-+]?{num}+(\.{num}+)?(E[-+]?{num}+)?
CHAR_CONST \'.\'
EXP ","|";"|"."
STRING_LITERAL \"(\\.|[^\\"])*\"|\'(\\.|[^\\'])*\'
Literal "true"|"false"|"NULL"
Keyword "auto"|"double"|"int"|"struct"|"break"|"else"|"long"|"switch"|"case"|"enum"|"register"|"typedef"|"char"|"extern"|"return"|"union"|"continue"|"for"|"signed"|"void"|"do"|"if"|"static"|"while"|"default"|"goto"|"sizeof"|"volatile"|"const"|"float"|"short"|"unsigned"

Cpar "("|")"
Spar "["|"]"
Fpar "{"|"}"
RELOP "=="|"<="|">="|"<"|">"
LOP "&&"|"||"
BITOP "<<"|">>"|"^"|"|"|"&"
AOPERATORS "+"|"-"|"*"|"/"|"%"|"!="|"="|"+="|"-="|"*="|"/="|"="|"++"|"--"
Scom \/\/[^\n]*
Mcom \/\*([^\*]|\*[^\/])*\*\/



%%
{ws} {}
{Header}                       {printf("Preprocessor\t\t\t%s\n",yytext);fprintf(yyout,"Preprocessor\t\t\t%s\n",yytext);}
delimitor {}
{Keyword}                    {printf("Keyword\t\t\t\t%s\n",yytext);fprintf(yyout,"Keyword\t\t\t\t%s\n",yytext);}
{RELOP}                      {printf("Relational operator\t\t%s\n",yytext);fprintf(yyout,"Relational operator\t\t%s\n",yytext);}
{INT}                        {printf("INTEGER\t\t\t\t%s\n",yytext);fprintf(yyout,"INTEGER\t\t\t\t%s\n",yytext);}
{Float}                      {printf("FLOAT_constant\t\t\t%s\n",yytext);fprintf(yyout,"FLOAT_constant\t\t\t%s\n",yytext);}
{CHAR_CONST}                 {printf("Character constant\t\t%s\n",yytext);fprintf(yyout,"Character constant\t\t%s\n",yytext);}
{EXP}                        {printf("Punctuation\t\t\t%s\n",yytext);fprintf(yyout,"Punctuation\t\t\t%s\n",yytext);}
{STRING_LITERAL}             {printf("String literal\t\t\t%s\n",yytext);fprintf(yyout,"String literal\t\t\t%s\n",yytext);}
{Literal}             {printf("literal\t\t\t\t%s\n",yytext);fprintf(yyout,"literal\t\t\t\t%s\n",yytext);}
{ID}                         {printf("Identifier\t\t\t%s\n",yytext);fprintf(yyout,"Identifier\t\t\t%s\n",yytext);}
{Cpar}                       {printf("Circular parenthesis\t\t%s\n",yytext);fprintf(yyout,"Circular parenthesis\t\t%s\n",yytext);}
{Spar}                       {printf("Square parenthesis\t\t%s\n",yytext);fprintf(yyout,"Square parenthesis\t\t%s\n",yytext);}
{Fpar}                       {printf("Curly Brace\t\t\t%s\n",yytext);fprintf(yyout,"Curly Brace\t\t\t%s\n",yytext);}
{BITOP}                  {printf("Bitwise Operator\t\t%s\n",yytext);fprintf(yyout,"Bitwise Operator\t\t%s\n",yytext);}
{AOPERATORS}                  {printf("Arithmetic Operator\t\t%s\n",yytext);fprintf(yyout,"Arithmetic Operator\t\t%s\n",yytext);}
{LOP}                  {printf("Logical Operator\t\t%s\n",yytext);fprintf(yyout,"Logical Operator\t\t%s\n",yytext);}
{Scom}       {}
{Mcom}       {}
    
%% 

int yywrap(){}



int main(int argc , char* argv[])
{
    
    yyout = fopen("symbol_table.txt", "w");
    printf("\nDoing lexical analysis on the given input......\n");
    printf("ANALYSIS DONE\n");
    printf("RESULT :\n");
    printf("Token\t\t\t|\t\t\tLexeme\t\n\n");
    fprintf(yyout,"\nDoing lexical analysis on the given input......\n");
    fprintf(yyout,"ANALYSIS DONE\n");
    fprintf(yyout,"RESULT :\n");
    fprintf(yyout,"Token\t\t\t|\t\t\tLexeme\t\n\n");
	if(argc>1){
	FILE *fp = fopen(argv[1],"r");
	if(fp)
	yyin = fp;
	}

    yylex();
    return 0;
}



