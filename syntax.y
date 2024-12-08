%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ts1.h"
extern int yylex(void); 
extern int nb_ligne;
extern int col;
extern void yyerror(const char *s);
extern int yylineno;  
extern char *yytext; 

%}
%union {
    int entier; 
    float reel; 
    char *str; 
    char *strv;
    void *vide;
    struct listeD *symbole;
    struct listeT *symbol;
}
%token DEBUT FIN EXECUTION FIXE
%token SI ALORS SINON TANTQUE FAIRE AFFICHE LIRE

%token <str> ASSIGN
%token <str> EQ
%token <str> NEQ
%token <str> LE
%token <str> GE
%token <str> ET
%token <str> OU
%token <str> NON

%token <reel> cstflt    
%token <entier> cstint  
%token <str> idf       
%token <strv> TEXTV     

%token NUM REAL TEXT   

%type <str> type
%type <symbole> var_list
%type <symbol> var_list2
%type <symbole>const_declaration
%type <vide>constant_value

%left OU
%left ET
%nonassoc '<' '>' LE GE EQ NEQ
%left '+' '-'
%left '*' '/'

%start program

%%
    
program:
    DEBUT declarations EXECUTION block FIN
    ;

declarations:
    declarations declaration
    | /* Epsilon */
    ;

declaration:
    type ':' var_list {
        struct listeD *var;
        for (var = $3; var != NULL; var = var->suivant) {
            insererTS(var->entite, $1, 0,&(var->valeur));  
        }
    } 
    | type ':' var_list2 {
        struct listeT *var;
        for (var=$3 ; var != NULL; var=var->suivant){
            insererTableau(var->entite,$1,var->taille,&(var->valeur));
        }
    }
    | FIXE type ':' const_declaration {
        listeD *var;
        for (var = $4; var != NULL; var = var->suivant) {
            insererTS(var->entite, $2,1,&(var->valeur)); 
        }
    }
    ;

type:
    NUM    { $$ = strdup("NUM");}
    | REAL { $$ = strdup("REAL");}
    | TEXT { $$ = strdup("TEXT");}
    ;
var_list:
    var_list ',' idf {
        struct listeD *new_var = (struct listeD*)malloc(sizeof(struct listeD)); 
        strcpy(new_var->entite, $3);
        new_var->is_const = 0;
        new_var->suivant = $1;
        $$ = new_var;
    }
    | idf {
        struct listeD *new_var = (struct listeD*)malloc(sizeof(struct listeD));
        strcpy(new_var->entite, $1);
        new_var->is_const = 0; 
        new_var->suivant = NULL; 
        $$ = new_var;
    }
;
var_list2 :
    var_list2 ',' idf '[' cstint ']' {
        struct listeT *new_var = (struct listeT*)malloc(sizeof(struct listeT)); 
        strcpy(new_var->entite, $3);
        new_var->taille = $5;
        new_var->suivant = $1;
        $$ = new_var;
    }
    | idf '[' cstint ']' {
        struct listeT *new_var = (struct listeT*)malloc(sizeof(struct listeT));
        strcpy(new_var->entite, $1);
        new_var->taille = $3;
        new_var->suivant = NULL; 
        $$ = new_var;
    }

const_declaration:
    idf EQ constant_value
    {
        struct listeD *new_var = (struct listeD*)malloc(sizeof(struct listeD));
        strcpy(new_var->entite,$1);
        new_var->valeur=$3;
        new_var->suivant=NULL;
        $$ = new_var;
    }
    |idf EQ TEXTV 
    {

    }
    ;

constant_value:
    cstint
    | cstflt
    | TEXTV
    ;

block:
    '{' statements '}'
    ;

statements:
    statements statement
    | /* Epsilon */
    ;

statement:
    assignment 
    | conditional
    | loop
    | io_statement
    ;

assignment:
    idf ASSIGN expression 
    | idf ASSIGN cstint {
        // Vérification de type à implémenter
    }
    | idf ASSIGN cstflt {
        // Vérification de type à implémenter
    }
    | idf ASSIGN TEXTV
    | idf '[' cstint ']' ASSIGN expression
    ;

division:
    cstflt '/' cstflt {} 
    | cstint '/' cstint {} 
    | cstint '/' cstflt {} 
    | cstflt '/' cstint {} 
    | idf '/' idf 
    ;

expression:
    expression '+' expression 
    | expression '-' expression
    | expression '*' expression
    | division
    | '(' expression ')'
    | idf
    | cstint
    | cstflt
    | idf '['cstint']'
    ;

conditional:
    SI '(' condition ')' ALORS block SINON block
    ;

loop:
    TANTQUE '(' condition ')' FAIRE block
    ;

condition:
    expression '<' expression
    | expression '>' expression
    | expression LE expression
    | expression GE expression
    | expression EQ expression
    | expression NEQ expression
    | condition ET condition
    | condition OU condition
    | NON condition
    ;

io_statement:
    AFFICHE '(' io_args ')'
    | LIRE '(' idf ')'
    | LIRE '(' idf '['cstint']' ')'
    ;

io_args:
    io_args ',' expression
    | expression 
    | TEXTV
    ;

%%
void yyerror(const char *s) {
    extern int yylineno;
    extern char *yytext;
    fprintf(stderr, "Erreur syntaxique à la ligne %d : %s près de \"%s\"\n", yylineno, s, yytext);
}

int main() {
    if (yyparse() == 0) {  
        printf("Analyse syntaxique réussie\n");
        /* afficherTS();
        afficherTStab(); */
    } else {  
        printf("Erreur d'analyse syntaxique\n");
    }
    return 0;
}
