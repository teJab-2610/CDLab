%option noyywrap

%{
#include <stdio.h>
void myprint(char*, char*);
%}


alphanum       [a-zA-Z0-9_]
word           {alphanum}+
domain         {word}(\.{word})(\.{word})+
email          {word}\@{domain}
mailto         (mailto\:)
password_char  [a-zA-Z0-9_!@#$%^&*()-+]
http           (http(s)?:\/\/)
ftp            (ftp:\/\/)
file           (file:\/\/)
username       {alphanum}+
password       {password_char}+
user_section   {username}(:{password})?\@
port           (0*([0-9]{1,4})|([1-5][0-9]{4})|(6[0-4][0-9]{3})|(65[0-4][0-9]{2})|(655[0-2][0-9])|(6553[0-5]))
num            [0-255]
fragmant       \#{alphanum}+
query_param    \?{alphanum}+=({alphanum}+)(&{alphanum}+=({alphanum}+))*
ip             {num}\.{num}\.{num}\.{num}
hostname       {domain}|{ip}
PORT           \:{port}
path           \/({alphanum}+)((\/|\.){alphanum}+)*


http_url       {http}:\/\/{user_section}?{hostname}(:{port})?(\/({path}))?(\?({query_param}))?(#{fragmant})?
file_url       file:\/\/(\/({path}))
ftp_url        ftp:\/\/{user_section}?{hostname}(:{port})?(\/({path}))?
mailto_url     mailto\:{email}


%%
{username}     {myprint("User Name : ", yytext);}
{http}         {myprint("HTTP Protocol : ", yytext);}
{ftp}          {myprint("FTP Protocol : ", yytext);}
{file}         {myprint("File : ", yytext);}
{mailto}       {myprint("MailTo : ", yytext);}
{email}        {myprint("Email : ", yytext);}
{user_section} {myprint("User Info : ", yytext);}
{hostname}     {myprint("Host : ", yytext);}
{PORT}         {myprint("Port ID : ", yytext);}
{query_param}  {myprint("Quries : ", yytext);}
{fragmant}     {myprint("Fragmant : ", yytext);}
{path}         {myprint("Path : ", yytext);}


%%

int main(int argc, char *argv[]) {
    if (argc > 1) {
    	FILE *fp = fopen(argv[1], "r");
	if (fp) {	
    		yyin = fp;	
	}	
    }
    yylex();
    return 0;
}

void myprint(char* type, char* value) {
    printf("%s     %s\n", type, value);
}
