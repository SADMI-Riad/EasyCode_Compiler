%{
#include "syntax.tab.h"
#include "ts.h"
extern YYSTYPE yylval;
int nb_ligne=1;
int col=1;
%}

lettre [a-zA-Z]
chiffre [0-9]
idf {lettre}({lettre}|{chiffre}|_)*
cstflt [+-]?([0-9]*\.[0-9]+|[0-9]+\.) 
cstint [+-]?[0-9]+

%%

"FIXE" { 
    insererMotCle("FIXE"); 
    return FIXE; 
}
"SI" { 
    insererMotCle("SI"); 
    return SI; 
}
"ALORS" { 
    insererMotCle("ALORS"); 
    return ALORS; 
}
"SINON" { 
    insererMotCle("SINON"); 
    return SINON; 
}
"TANTQUE" { 
    insererMotCle("TANTQUE"); 
    return TANTQUE; 
}
"FAIRE" { 
    insererMotCle("FAIRE"); 
    return FAIRE; 
}
"affiche" { 
    insererMotCle("affiche"); 
    return AFFICHE; 
}
"lire" { 
   insererMotCle("lire"); 
    return LIRE; 
}

"<-" { 
    insererOperateurNoAsso("<-"); 
    return ASSIGN; 
}
"=" { 
    insererOperateurNoAsso("="); 
    return EQ; 
}
"!=" { 
    insererOperateurNoAsso("!="); 
    return NEQ; 
}
"<=" { 
    insererOperateurNoAsso("<="); 
    return LE; 
}
">=" { 
    insererOperateurNoAsso(">="); 
    return GE; 
}
"<" { 
    insererOperateurNoAsso("<"); 
    return '<'; 
}
">" { 
    insererOperateurNoAsso(">"); 
    return '>'; 
}

"ET" { 
    insererOperateurLogique("ET");  
    return ET; 
}
"OU" { 
    insererOperateurLogique("OU");  
    return OU; 
}
"NON" { 
    insererOperateurLogique("NON"); 
    return NON; 
}

"+" { 
    insererOperateurArithmetique("+"); 
    return '+'; 
}
"-" { 
    insererOperateurArithmetique("-"); 
    return '-'; 
}
"*" { 
    insererOperateurArithmetique("*"); 
    return '*'; 
}
"/" { 
    insererOperateurArithmetique("/"); 
    return '/'; 
}

"DEBUT" { 
    insererMotCle("DEBUT"); 
    return DEBUT; 
}
"FIN" { 
    insererMotCle("FIN"); 
    return FIN; 
}
"EXECUTION" { 
    insererMotCle("EXECUTION"); 
    return EXECUTION; 
}
"NUM" { 
    return NUM; 
}
"REAL" { 
    return REAL; 
}
"TEXT" { 
    return TEXT; 
}

"{" { return '{'; }
"}" { return '}'; }
"(" { return '('; }
")" { return ')'; }
"[" { return '['; }
"]" { return ']'; }
";" { return ';'; }
":" { return ':'; }
"," { return ','; }

{cstint} { 
    yylval.entier = atoi(yytext);
    if (yylval.entier < -32767 || yylval.entier > 32767) {
       printf("\033[34mErreur lexicale : entier en dehors de cet intervalle [-32767, 32767]\033[0m\n");
        return -1;
    }
    return cstint;
} 


{cstflt} { 
    yylval.reel = atof(yytext); 
    return cstflt; 
}

{idf} { 
    if (strlen(yytext) > 10) {
        printf("\033[34mErreur lexicale : l'identifiant '%s' dépasse la limite de 10 caractères à la ligne %d, colonne %d\033[0m\n", yytext, nb_ligne, col);
        return -1; 
    } else {
        yylval.str = strdup(yytext);
        return idf;
    }
}
\n { nb_ligne++; col = 1; }
[ \t] {col++;}

\"[^\"]*\" { yylval.strv = strdup(yytext); return TEXTV; }
--.*?## { yylval.str = strdup(yytext); return COMMENT; }
\{-([^-]|-[^}])*-\} { 
    char *p;
    for (p = yytext; *p != '\0'; p++) {
        if (*p == '\n') {
            nb_ligne++;
            col = 1;
        } else {
            col++;
        }
    }
    yylval.str = strdup(yytext); 
    return COMMENTM; 
}

. { 
    printf("Erreur lexicale sur l'entité %s à la ligne %d à la colonne %d\n", yytext, nb_ligne, col); 
    return -1; 
}

%%
