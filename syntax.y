%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntax.tab.h"
extern int yylex(void); 
extern void yyerror(const char *s);
extern int yylineno;  
extern char *yytext;  
%}

%union {
    int entier; 
    float reel; 
    char *str; 
    char *strv;
}

%token DEBUT FIN EXECUTION FIXE
%token SI ALORS SINON TANTQUE FAIRE AFFICHE LIRE
%token <str> ASSIGN <str> EQ <str> NEQ <str> LE <str> GE <str> ET <str> OU <str> NON
%token <entier> cstflt    
%token <reel> cstint  
%token <str> idf       
%token <strv> TEXTV     

%token NUM REAL TEXT   
%type <str> type

%left OU
%left ET
%nonassoc '<' '>' LE GE EQ NEQ
%left '+' '-'
%left '*' '/'

%start program

%%

program:
    DEBUT declarations EXECUTION block FIN
    {
        printf("Analyse syntaxique réussie - Program\n");
    }
    ;

declarations:
    declarations declaration
    {
        printf("Déclaration trouvée\n");
    }
    | /* Epsilon */
    {
        printf("Fin des déclarations\n");
    }
    ;

declaration:
    type ':' var_list 
    {
        printf("Déclaration de variables : \n");
    }
    | FIXE type ':' const_declaration 
    {
        printf("Déclaration constante :\n");
    }
    ;

type:
    NUM    { $$ = strdup("NUM"); printf("Type NUM\n"); }
    | REAL { $$ = strdup("REAL"); printf("Type REAL\n"); }
    | TEXT { $$ = strdup("TEXT"); printf("Type TEXT\n"); }
    ;

var_list:
    var_list ',' idf
    {
        printf("Liste de variables :\n");
    }
    | idf
    {
        printf("Variable :\n");
    }
    ;

const_declaration:
    idf EQ constant_value
    {
        printf("Déclaration constante : \n");
    }
    ;

constant_value:
    cstint { printf("Valeur constante : \n"); }
    | cstflt { printf("Valeur constante : \n"); }
    | TEXTV { printf("Valeur constante : \n"); }
    ;

block:
    '{' statements '}'
    {
        printf("Début du bloc de code\n");
    }
    ;

statements:
    statements statement
    {
        printf("Déclaration de statement\n");
    }
    | /* Epsilon */
    {
        printf("Fin des instructions\n");
    }
    ;

statement:
    assignment 
    {
        printf("Affectation trouvée\n");
    }
    | conditional
    {
        printf("Conditionnelle trouvée\n");
    }
    | loop
    {
        printf("Boucle trouvée\n");
    }
    | io_statement
    {
        printf("Instruction d'entrée/sortie trouvée\n");
    }
    ;

assignment:
    idf ASSIGN expression
    {
        printf("Affectation :\n");
    }
    ;

expression:
    expression '+' expression 
    {
        printf("Expression addition :\n");
    }
    | expression '-' expression
    {
        printf("Expression soustraction :\n");
    }
    | expression '*' expression
    {
        printf("Expression multiplication :\n");
    }
    | expression '/' expression 
    {
        printf("Expression division :\n");
    }
    | '(' expression ')'
    {
        printf("Expression entre parenthèses\n");
    }
    | idf
    {
        printf("Identifiant :\n");
    }
    | cstint
    {
        printf("Constante entière :\n");
    }
    | cstflt
    {
        printf("Constante flottante :\n");
    }
    ;

conditional:
    SI '(' condition ')' ALORS block SINON block
    {
        printf("Condition SI\n");
    }
    ;

loop:
    TANTQUE '(' condition ')' FAIRE block
    {
        printf("Boucle TANTQUE\n");
    }
    ;

condition:
    expression '<' expression
    {
        printf("Condition inférieure :\n");
    }
    | expression '>' expression
    {
        printf("Condition supérieure :\n ");
    }
    | expression LE expression
    {
        printf("Condition inférieure ou égale :\n ");
    }
    | expression GE expression
    {
        printf("Condition supérieure ou égale : \n");
    }
    | expression EQ expression
    {
        printf("Condition égalité : \n");
    }
    | expression NEQ expression
    {
        printf("Condition inégalité :\n");
    }
    | condition ET condition
    {
        printf("Condition ET :\n");
    }
    | condition OU condition
    {
        printf("Condition OU : \n");
    }
    | NON condition
    {
        printf("Condition NON\n");
    }
    ;

io_statement:
    AFFICHE '(' io_args ')'
    {
        printf("Instruction AFFICHE\n");
    }
    | LIRE '(' idf ')'
    {
        printf("Instruction LIRE\n");
    }
    ;

io_args:
    io_args ',' expression
    {
        printf("Arguments d'IO :\n ");
    }
    | expression 
    {
        printf("Argument d'IO : \n");
    }
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
    } else {  
        printf("Erreur d'analyse syntaxique\n");
    }
    return 0;
}
