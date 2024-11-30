#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntax.tab.h"
#include "ts.h"
// extern YYSTYPE yylval;
// extern int nb_ligne;
// extern int col;
typedef struct SymbT {
    char* nom;
    char* type;
    struct SymbT* suivant;
} SymbT;
typedef struct Symbole {
    char* texte;
    struct Symbole* suivant;
} Symbole;

typedef struct ListeBinaire {
    int num;
    Symbole* liste;
    struct ListeBinaire* suivant;
} ListeBinaire;

SymbT* listeIdentifiants = NULL;
SymbT* listeCst = NULL;
Symbole* listeMotsCles = NULL;
Symbole* listeOperateurs = NULL;
Symbole* listeLogiques = NULL;
Symbole* listeTypes = NULL;
ListeBinaire* listeBinaire = NULL;
void insererIdentifiant(char* nom, char* type) {
    SymbT* nouvelIdentifiant = (SymbT*)malloc(sizeof(SymbT));
    if (nouvelIdentifiant) {
        nouvelIdentifiant->nom = strdup(nom);
        nouvelIdentifiant->type = strdup(type);
        nouvelIdentifiant->suivant = listeIdentifiants;
        listeIdentifiants = nouvelIdentifiant;
    }
}
void insererCst(char* nom, char* type) {
    SymbT* nouvelIdentifiant = (SymbT*)malloc(sizeof(SymbT));
    if (nouvelIdentifiant) {
        nouvelIdentifiant->nom = strdup(nom);
        nouvelIdentifiant->type = strdup(type);
        nouvelIdentifiant->suivant = listeCst;
        listeCst = nouvelIdentifiant;
    }
}
void insererDansListeBinaire(int code, const char* texte) {
    Symbole* nouveauSymbole = (Symbole*)malloc(sizeof(Symbole));
    if (nouveauSymbole) {
        nouveauSymbole->texte = strdup(texte);
        nouveauSymbole->suivant = NULL;

        ListeBinaire* current = listeBinaire;
        while (current) {
            if (current->num == code) {
                nouveauSymbole->suivant = current->liste;
                current->liste = nouveauSymbole;
                return;
            }
            current = current->suivant;
        }

        ListeBinaire* nouvelleListeBinaire = (ListeBinaire*)malloc(sizeof(ListeBinaire));
        nouvelleListeBinaire->num = code;
        nouvelleListeBinaire->liste = nouveauSymbole;
        nouvelleListeBinaire->suivant = listeBinaire;
        listeBinaire = nouvelleListeBinaire;
    }
}

void insererMotCle(const char* motCle) {
    insererDansListeBinaire(1, motCle);
}

void insererOperateur(const char* operateur) {
    insererDansListeBinaire(2, operateur);
}

void insererOperateurLogique(const char* operateurLogique) {
    insererDansListeBinaire(3, operateurLogique);
}

void insererType(const char* type) {
    insererDansListeBinaire(4, type);
}
