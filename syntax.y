%{
#include "semantique.h"
extern int yylex(void); 
extern int nb_ligne;
extern int col;
extern int yynerrs;  
extern char *yytext;
extern void yyerror(const char *s);
extern void afficherTStab(void) ;
extern void afficherToutesLesTablesSymboles(void);
#define RED     "\033[1;31m"  
#define YELLOW  "\033[1;33m"  
#define RESET   "\033[0m"  
#define GREEN   "\033[0;32m"

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

%error-verbose


%token <str> ASSIGN
%token <str> EQ
%expect 2
%token <str> NEQ
%token <str> LE
%token <str> GE
%token <str> ET
%token <str> OU
%token <str> NON

%token <reel> cstflt    
%token <entier> cstint  
%token <str> idf       
%token <str> TEXTV   
%token COMMENT
%token COMMENTM


%token NUM REAL TEXT   

%type <str> type
%type <symbole> var_list
%type <symbol> var_list2
%type <symbole> const_declaration
%type <con> constant_value
%type <con> expression

%left OU
%left ET
%nonassoc '<' '>' LE GE EQ NEQ
%left '+' '-'
%left '*' '/'

%start program

%%
    
program:
    commantaires DEBUT declarations commantaires EXECUTION block FIN commantaires
    ;

declarations:
    declarations commantaires declaration 
    | /* Epsilon */
    ;
commantaires : 
    commantaires commantaire
    | /* Epsilon */
commantaire :
    COMMENT 
    | COMMENTM
    ;
declaration:
    type ':' var_list ';'{inserstionTS_et_verifications_double_declarations($3,$1,0);} 
    | type ':' var_list2 ';'{inserstionTStab_et_verifications_double_declarations($3,$1);}
    | FIXE type ':' const_declaration ';'{inserstionTS_et_verifications_double_declarations($4,$2,1);}
    ;

type:
    NUM    { $$ = strdup("NUM");}
    | REAL { $$ = strdup("REAL");}
    | TEXT { $$ = strdup("TEXT");}
    ;
var_list:
    var_list ',' idf {$$=creationVarlist1($3,$1);}
    | idf {$$=creationVarlist1($1,NULL);}
;
var_list2 :
    var_list2 ',' idf '[' cstint ']' {$$=creationVarlist2($3 ,$5 , $1);}
    | idf '[' cstint ']' {$$=creationVarlist2($1 ,$3 , NULL);}

const_declaration:
    idf EQ constant_value{$$=constDeclaration($3,$1,1);}
    | idf {$$=constDeclaration(NULL,$1,1);}
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
    '{' commantaires statements '}'
    ;

statements:
    statements  statement commantaires
    | /* Epsilon */
    ;

statement:
    assignment ';'   
    | conditional
    | loop
    | io_statement ';'
    ;

assignment:
    idf ASSIGN expression {gestionErreurAssig($3,$1);}
    | idf '[' cstint ']' ASSIGN expression {gestion_taille_tableau($1,$3);}
    | idf '[' idf ']' ASSIGN expression {gererTaille($1,$3);}
    ;

expression:
    expression '+' expression {$$=gestionErreurType(1,$1,$3);}
    | expression '-' expression {$$=gestionErreurType(2,$1,$3);}
    | expression '*' expression {$$=gestionErreurType(3,$1,$3);}
    | expression '/' expression {$$=gestionErreurType(4,$1,$3);}
    | '(' expression ')' { $$ = $2; }
    | constant_value {$$=$1;}
    | idf { $$=gestionIDF($1);}
    ;


conditional:
    SI '(' condition ')' ALORS block SINON block
    | SI '(' condition ')' ALORS block 
    ;

loop:
    TANTQUE '(' condition ')' FAIRE block

    ;

condition:
    expression '<' expression{gestionIncompatiblite($1,$3);}
    | expression '>' expression{gestionIncompatiblite($1,$3);}
    | expression LE expression{gestionIncompatiblite($1,$3);}
    | expression GE expression{gestionIncompatiblite($1,$3);}
    | expression EQ expression{gestionIcompatibilitéEQ_NEQ($1,$3);}
    | expression NEQ expression{gestionIcompatibilitéEQ_NEQ($1,$3);}
    | condition ET condition
    | condition OU condition
    | NON condition
    ;


io_statement:
    AFFICHE '(' io_args ')'
    | LIRE '(' idf ')' {gestion_io_statemnt(0 ,$3,-1 );}
    | LIRE '(' idf '['cstint']' ')' {gestion_io_statemnt(1,$3,$5 );}
    | LIRE '(' idf '['idf']' ')' {gererTaille($3,$5)}
    ;

io_args:
    io_args ',' expression
    | expression 
    ;

%%
void yyerror(const char *s) {

    if (strstr(s, "syntax error") || strstr(s, "Erreur Syntaxique")) {
        printf("\n%sErreur syntaxique ligne %d, colonne %d: ", RED, nb_ligne, col);
        printf("%s%s\n", s, RESET);
    } else {
        printf("\n%sErreur sémantique ligne %d, colonne %d: ", YELLOW, nb_ligne, col);
        printf("%s%s\n", s, RESET);
    }
}


int main() {
    int result = yyparse();
    if (result == 0 && yynerrs == 0) {  
        printf("\n\n%sAnalyse syntaxique réussie%s\n\n",GREEN,RESET);
        afficherToutesLesTablesSymboles();
    } else {  
        printf("\n\nNombre total d'erreurs: %d\n\n", yynerrs);
    }
    return result;
}
