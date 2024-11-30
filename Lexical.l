%{
#include "syntax.tab.h"
#include "ts.h"
extern YYSTYPE yylval;
extern int nb_ligne;
extern int col;
%}

lettre [a-zA-Z]
chiffre [0-9]
idf {lettre}({lettre}|{chiffre})*
cstflt [+-]?([0-9]+(\.[0-9]*)?|\.[0-9]+)
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
    insererOperateur("<-"); 
    return ASSIGN; 
}
"==" { 
    insererOperateur("=="); 
    return EQ; 
}
"!=" { 
    insererOperateur("!="); 
    return NEQ; 
}
"<=" { 
    insererOperateur("<="); 
    return LE; 
}
">=" { 
    insererOperateur(">="); 
    return GE; 
}
"<" { 
    insererOperateur("<"); 
    return '<'; 
}
">" { 
    insererOperateur(">"); 
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
    insererOperateur("+"); 
    return '+'; 
}
"-" { 
    insererOperateur("-"); 
    return '-'; 
}
"*" { 
    insererOperateur("*"); 
    return '*'; 
}
"/" { 
    insererOperateur("/"); 
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
    insererType("NUM");  
    return TYPE; 
}
"REAL" { 
    insererType("REAL");  
    return REAL; 
}
"TEXT" { 
    insererType("TEXT");  
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
    return cstint; 
}

{cstflt} { 
    yylval.reel = atof(yytext); 
    return cstflt; 
}

{idf} { 
    if (strlen(yytext) > 10) {
        printf("Erreur lexicale : l'identifiant '%s' dépasse la limite de 10 caractères à la ligne %d, colonne %d\n", yytext, nb_ligne, col);
        return err; 
    } else {
        yylval.str = strdup(yytext);
        return idf;
    }
}
\"[^\"]*\" { yylval.str = strdup(yytext); return TEXTV; }

[ \t] 
\n { nb_ligne++; col = 1; }

. { 
    printf("Erreur lexicale sur l'entité %s à la ligne %d à la colonne %d\n", yytext, nb_ligne, col); 
    return err; 
}

%%
