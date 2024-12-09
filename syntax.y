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
    struct listeD *symbole;
    struct listeT *symbol;
    struct constant *con;
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
%type <symbole> const_declaration
%type <con> constant_value
/* %type <con> expression */

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
            if(insererTS(var->entite, $1, 0,&(var->valeur))==-1)
            {
                printf("double déclarations de %s à la ligne %d et colonne %d \n",var->entite,nb_ligne,col);
            }
        }
    } 
    | type ':' var_list2 {
        struct listeT *var;
        for (var=$3 ; var != NULL; var=var->suivant){
            if(insererTableau(var->entite,$1,var->taille,&(var->valeur))==-1)
            {
                printf("double déclarations de %s à la ligne %d et colonne %d \n",var->entite,nb_ligne,col);
            }
        }
    }
    | FIXE type ':' const_declaration {
        listeD *var;
        for (var = $4; var != NULL; var = var->suivant) {
            if(insererTS(var->entite, $2,1,&(var->valeur))==-1)
            {
                printf("double déclarations de %s à la ligne %d et colonne %d \n",var->entite,nb_ligne,col);
            }
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
            strcpy(new_var->entite, $1);
                if (strcmp($3->type, "NUM") == 0) 
                {
                    new_var->valeur.i = $3->valeur.i; 
                    strcpy(new_var->type, "NUM");  
                }
                else if (strcmp($3->type, "REAL") == 0) 
                {
                    new_var->valeur.f = $3->valeur.f; 
                    strcpy(new_var->type, "REAL"); 
                }       
                else if (strcmp($3->type, "TEXT") == 0) 
                {
                    new_var->valeur.s = strdup($3->valeur.s);  
                    strcpy(new_var->type, "TEXT"); 
                }
            new_var->is_const = 1; 
            new_var->suivant = NULL;
            free($3);
            $$ = new_var;
    }
    | idf 
    {
            struct listeD *new_var = (struct listeD*)malloc(sizeof(struct listeD));
            strcpy(new_var->entite, $1);
            new_var->is_const = 1;
            new_var->suivant = NULL;
            $$ = new_var;
    }
    ;


constant_value:
    cstint {
        $$ = (struct constant*)malloc(sizeof(struct constant));
        strcpy($$->type,strdup("NUM"));
        $$->valeur.i = $1;  
    }
    | cstflt {
        $$ = (struct constant*)malloc(sizeof(struct constant));
        strcpy($$->type,strdup("REAL"));
        $$->valeur.f = $1;
    }
    | TEXTV {
        $$ = (struct constant*)malloc(sizeof(struct constant));
        strcpy($$->type,strdup("TEXT"));
        $$->valeur.s = strdup($1);
    }
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
    | LIRE '(' idf '['cstint']' ')' {
    }
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
    fprintf(stderr, "Erreur syntaxique à la ligne %d et colonne %d: %s près de \"%s\"\n", nb_ligne,col, s, yytext);
}

int main() {
    if (yyparse() == 0) {  
        printf("Analyse syntaxique réussie\n");
        afficherTS();
        afficherTStab();
    } else {  
        printf("Erreur d'analyse syntaxique\n");
    }
    return 0;
}
