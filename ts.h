#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syn.tab.h"
#include "ts.h"

extern YYSTYPE yylval;
extern int nb_ligne;
extern int col;
typedef struct Identifiant {
    char* nom;
    char* type;
    struct Identifiant* suivant;
} Identifiant;
typedef struct Symbole {
    char* texte;
    struct Symbole* suivant;
} Symbole;

typedef struct ListeBinaire {
    int num;
    Symbole* liste;
    struct ListeBinaire* suivant;
} ListeBinaire;

Identifiant* listeIdentifiants = NULL;
Symbole* listeMotsCles = NULL;
Symbole* listeConstantes = NULL;
Symbole* listeOperateurs = NULL;
Symbole* listeLogiques = NULL;
Symbole* listeTypes = NULL;
ListeBinaire* listeBinaire = NULL;
void insererIdentifiant(char* nom, char* type) {
    Identifiant* nouvelIdentifiant = (Identifiant*)malloc(sizeof(Identifiant));
    if (nouvelIdentifiant) {
        nouvelIdentifiant->nom = strdup(nom);
        nouvelIdentifiant->type = strdup(type);
        nouvelIdentifiant->suivant = listeIdentifiants;
        listeIdentifiants = nouvelIdentifiant;
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

void insererConstante(const char* constante) {
    insererDansListeBinaire(2, constante);
}

void insererOperateur(const char* operateur) {
    insererDansListeBinaire(3, operateur);
}

void insererOperateurLogique(const char* operateurLogique) {
    insererDansListeBinaire(4, operateurLogique);
}

void insererType(const char* type) {
    insererDansListeBinaire(5, type);
}
