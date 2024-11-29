%{
#include "syn.tab.h"
#include "TS.h"
extern YYSTYPE yylval;
extern int nb_ligne;
extern int col;
%}
lettre [a-zA-Z]
chiffre [0-9]
idf {lettre}({lettre}|{chiffre})*
cst [1-9][0-9]*|0 
%%
EXECUTION { 
    insererTableDesSymboles("EXECUTION", 1);  // Mots-clés, code 1
    return EXECUTION; 
}

DEBUT { 
    insererTableDesSymboles("DEBUT", 1);  // Mots-clés, code 1
    return DEBUT; 
}

FIN { 
    insererTableDesSymboles("FIN", 1);  // Mots-clés, code 1
    return FIN; 
}

Program { 
    insererTableDesSymboles("Program", 1);  // Mots-clés, code 1
    return prog; 
} // Ces mots-clés ont un code 1

TEXT { 
    insererTableDesSymboles("TEXT", 4);  // Types, code 4
    return TEXT; 
}

NUM { 
    insererTableDesSymboles("NUM", 4);  // Types, code 4
    return NUM; 
}

REAL { 
    insererTableDesSymboles("REAL", 4);  // Types, code 4
    return REAL; 
} // Ces mots-clés sont des types et ont le code 4

// Séparateurs et symboles
[,;=/+}{] { 
    return yytext[0]; // Retourne les séparateurs sans modification
}

// Constantes
{cst} { 
    yylval.entier = atoi(yytext);  // Convertit la constante en entier
    insererTableDesSymboles(yytext, 3);  // Constantes, code 3
    return cst; 
}

// Identifiants
{idf}  { 
    yylval.str = strdup(yytext);  // Copie le nom de l'identifiant
    insererTableDesSymboles(yytext, 2);  // Identifiants, code 2
    return idf; 
}

// Gestion des espaces blancs
[ \t]  
\n {nb_ligne++;col=1;}
. {printf ("erreur lexical sur l'entite %s a la ligne %d a la colonne %d",yytext,nb_ligne,col); return err;}
%%