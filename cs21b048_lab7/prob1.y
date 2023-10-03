%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yyerror(char *s);
extern FILE * yyin;

struct Snode{
    struct Snode *left;
    struct Snode *right;
    char token[100];
    char lexvalue[100];
    int dval;
};

struct Snode *newNode(char *token, char *lexvalue, int dval) {
    struct Snode *node = (struct Snode*)malloc(sizeof(struct Snode));
    node->left = NULL;
    node->right = NULL;
    strcpy(node->token, token);
    strcpy(node->lexvalue, lexvalue);
    node->dval = dval;
    return node;
}
void printnode(struct Snode *root){
    //print seperately for id and num
    if(strcmp(root->token, "ID")==0){
        printf("ID\t\t\t%s\n", root->lexvalue);
    }
    if(strcmp(root->lexvalue, "ASSIGN")==0){
        printf("ASSIGN\t\t\t=\n");
    }
    if(strcmp(root->lexvalue, "NUMBER")==0){
        printf("NUM\t\t\t%d\n", (int)root->dval);
    }
    if(strcmp(root->lexvalue, "UNARY_PLUS")==0){
        printf("UNARY +\t\t\t+\n");
    }
    if(strcmp(root->lexvalue, "UNARY_MINUS")==0){
        printf("UNARY -\t\t\t-\n");
    }
    if(strcmp(root->lexvalue, "POST_INCREMENT")==0){
        printf("UNARY POST\t\t++\n");
    }
    if(strcmp(root->lexvalue, "POST_DECREMENT")==0){
        printf("UNARY POST\t\t--\n");
    }
    if(strcmp(root->lexvalue, "PRE_INCREMENT")==0){
        printf("UNARY PRE\t\t++\n");
    }
    if(strcmp(root->lexvalue, "PRE_DECREMENT")==0){
        printf("UNARY PRE\t\t--\n");
    }
    if(strcmp(root->lexvalue, "PLUS")==0){
        printf("OP\t\t\t+\n");
    }
    if(strcmp(root->lexvalue, "MINUS")==0){
        printf("OP\t\t\t-\n");
    }
    if(strcmp(root->lexvalue, "DIVIDE")==0){
        printf("OP\t\t\t\\\n");
    }
    if(strcmp(root->lexvalue, "MULTIPLY")==0){
        printf("OP\t\t\t*\n");
    }
    
}


void printinorder(struct Snode *root){
    if(root == NULL) return;
    if(root->left){printinorder(root->left);}
    printnode(root);
    if(root->right){printinorder(root->right);}
}

void printpreorder(struct Snode *root){
    if(root==NULL) return;
    printnode(root);
    if(root->left){printpreorder(root->left);}
    if(root->right){printpreorder(root->right);}
};

void printpostorder(struct Snode *root){
    if(root==NULL) return;
    if(root->left){printpostorder(root->left);}
    if(root->right){printpostorder(root->right);}
    printnode(root);
};

void printALL(struct Snode *root){
    printf("Inorder Traversal:\n");
    printf("---------------------------------------------\n");
    printf("TOKEN\t\t\tLEXEME\n");
    printf("---------------------------------------------\n");
    printinorder(root);
    printf("\nPostorder Traversal:\n");
    printf("---------------------------------------------\n");
    printf("TOKEN\t\t\tLEXEME\n");
    printf("---------------------------------------------\n");
    printpostorder(root);
    printf("\nPreorder Traversal:\n");
    printf("---------------------------------------------\n");
    printf("TOKEN\t\t\tLEXEME\n");
    printf("---------------------------------------------\n");
    printpreorder(root);
    printf("---------------------------------------------\n");
    printf("---------------------------------------------\n\n");
}

%}

%union {
    int dval;
    char lexeme[100];
    struct Snode *node;
}

%token <lexeme> ID  
%token <dval> NUMBER
%token <lexeme> PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN ASSIGN INCREMENT DECREMENT SEPERATOR EOFf EOL
%type <node> Start EQN STMNT EXPRESSION TERM FACTOR SIGN 

%%
Start       : EQN Start 
            | EOL Start
            | EOL EOFf {return 0;}
            | EQN 
            | EOFf {return 0;}
            ; 

EQN         : STMNT SEPERATOR { printf("\t\tValid\n\n"); printALL($1); }
            | error SEPERATOR { printf("\t\tInvalid\n\n");printf("---------------------------------------------\n"); 
    printf("---------------------------------------------\n\n");}
            | error EOL { printf("\t\tInvalid \n\n");printf("---------------------------------------------\n");
    printf("---------------------------------------------\n\n"); }
            | error EOFf { printf("\t\tInvalid \n\n"); return 0;printf("---------------------------------------------\n");
    printf("---------------------------------------------\n\n");}
            | SEPERATOR { printf("\t\tNo equation\n\n");printf("---------------------------------------------\n");
    printf("---------------------------------------------\n\n"); }
            ;

STMNT       : ID ASSIGN EXPRESSION { 
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $1);
                    $$ = newNode("STMNT", "ASSIGN", 0);$$->right = $3;
                    $$->left = newNode("ID", temp, 0); 
                    }
            
            | ID INCREMENT { 
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $1); 
                    $$ = newNode("STMNT", "POST_INCREMENT", 0);
                    $$->left =  newNode("ID", temp, 0); 
                    }
            | ID DECREMENT {
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $1);
                    $$ = newNode("STMNT", "POST_DECREMENT", 0);
                    $$->left = newNode("ID", temp, 0);
                    }
            | INCREMENT ID { 
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $2);
                    $$ = newNode("STMNT", "PRE_INCREMENT", 0);
                    $$->right = newNode("ID", temp, 0);
                    }
            | DECREMENT ID { 
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $2); 
                    $$ = newNode("STMNT", "PRE_DECREMENT", 0);
                    $$->right = newNode("ID", temp, 0);
                    }
 
EXPRESSION  : EXPRESSION PLUS TERM { $$ = newNode("EXPRESSION", "PLUS", 0); $$->left = $1; $$->right = $3; }
            | EXPRESSION MINUS TERM { $$ = newNode("EXPRESSION", "MINUS", 0); $$->left = $1; $$->right = $3; }
            | SIGN TERM { 
                    if($1!=NULL){
                        $1->right = $2;
                        $$ = $1;
                    }
                    else{
                        $$ = $2;
                    }
            }
            ;

TERM        : TERM MULTIPLY SIGN FACTOR /*create multiple node for sign as a child*/{
                    if($3!=NULL){
                        $3->right = $4;
                        $$ = newNode("TERM", "MULTIPLY", 0);
                        $$->left = $1; $$->right = $3;
                    }
                    else{
                        $$ = newNode("TERM", "MULTIPLY", 0);
                        $$->left = $1; $$->right = $4;
                    }
                  }
            | TERM DIVIDE SIGN FACTOR {
                    if($3!=NULL){
                        $3->right = $4;
                        $$ = newNode("TERM", "DIVIDE", 0);
                        $$->left = $1; $$->right = $3;
                    }
                    else{
                        $$ = newNode("TERM", "DIVIDE", 0);
                        $$->left = $1; $$->right = $4;
                    }
                  }
                    
            | SIGN FACTOR {
                    if($1!=NULL){
                        $1->right = $2;
                        $$ = $1;
                    }
                    else{
                        $$ = $2;
                    }
                  }
            ;
FACTOR      : NUMBER {
                    int temp = $1;
                    $$ = newNode("FACTOR", "NUMBER", temp); }

            | ID {
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $1);
                    $$ = newNode("FACTOR", "ID", 0);
                    $$->left = newNode("ID", temp, 0); }
            | LPAREN EXPRESSION RPAREN {
                    $$ = newNode("FACTOR", "EXPRESSION", 0);
                    $$->left = $2; }
            | INCREMENT ID {
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $2);
                    $$ = newNode("FACTOR", "PRE_INCREMENT", 0);
                    $$->right = newNode("ID", temp, 0); }
            | DECREMENT ID {
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $2);
                    $$ = newNode("FACTOR", "PRE_DECREMENT", 0);
                    $$->right = newNode("ID", temp, 0); }    
            | ID INCREMENT {
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $1);
                    $$ = newNode("FACTOR", "POST_INCREMENT", 0);
                    $$->left = newNode("ID", temp, 0); }
            | ID DECREMENT {
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $1);
                    $$ = newNode("FACTOR", "POST_DECREMENT", 0);
                    $$->left = newNode("ID", temp, 0); }
            | ID ASSIGN EXPRESSION {
                    char *temp = (char*)malloc(sizeof(char)*100);
                    strcpy(temp, $1);
                    $$ = newNode("FACTOR", "ASSIGN", 0);
                    $$->left = newNode("ID", temp, 0); $$->right = $3; }
            ;
SIGN       : PLUS { $$ = newNode("UNARYOP", "UNARY_PLUS", 0); }
            | MINUS { $$ = newNode("UNARYOP", "UNARY_MINUS", 0); }
            | {$$ = NULL;}
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
        exit(1);
    }
    else { yyin = fp; }
    printf("---------------------------------------------\n");
    yyparse();
    return 0;
}
int yyterminate()
{
    return 1;
}
