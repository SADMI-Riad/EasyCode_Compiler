#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntax.tab.h"
#define max 20

typedef struct liste
{
    char entite[max];
    struct liste *suivant;
} liste;

typedef struct constant{
    char type[max];
    union {
        int i;             
        float f;           
        char *s;           
    } valeur;  
}constant;
typedef struct listeD
{
    char entite[max];
    char type[max];
    int is_const;
    union {
        int i;          
        float f;           
        char *s;           
    } valeur;  
    struct listeD *suivant;
} listeD;

typedef struct listeT
{
    char entite[max];
    char type[max];
    int taille;
    union {
        int i;          
        float f;           
        char *s;           
    } valeur;  
    struct listeT *suivant;
} listeT;
liste *ListeMotCle = NULL;
liste *ListeOperateurLogique = NULL;
liste *ListeOperateurArithmetique = NULL;
liste *ListeOperateurNoAsso = NULL;
listeD *TS = NULL;
listeT *TStab = NULL;

void insererMotCle(char tete[])
{
    liste *nouveau = (liste *)malloc(sizeof(liste));
    if (nouveau)
    {
        strcpy(nouveau->entite, tete);
        nouveau->suivant = ListeMotCle;
        ListeMotCle = nouveau;
    } 
    else {
        printf("erreur");
    }
}

void insererOperateurLogique(char tete[])
{
    liste *nouveau = (liste *)malloc(sizeof(liste));
    if (nouveau)
    {
        strcpy(nouveau->entite, tete);
        nouveau->suivant = ListeOperateurLogique;
        ListeOperateurLogique = nouveau;
    }else {
        printf("erreur");
    }
}

void insererOperateurArithmetique(char tete[])
{
    liste *nouveau = (liste *)malloc(sizeof(liste));
    if (nouveau)
    {
        strcpy(nouveau->entite, tete);
        nouveau->suivant = ListeOperateurArithmetique;
        ListeOperateurArithmetique = nouveau;
    }else {
        printf("erreur");
    }
}

void insererOperateurNoAsso(char tete[])
{
    liste *nouveau = (liste *)malloc(sizeof(liste));
    if (nouveau)
    {
        strcpy(nouveau->entite, tete);
        nouveau->suivant = ListeOperateurNoAsso;
        ListeOperateurNoAsso = nouveau;
    }else {
        printf("erreur");
    }
}
int rechercherIdf(char entite[]) {
    listeD *current = TS; 
    while (current != NULL) {
        if (strcmp(current->entite, entite) == 0) {
            return 1; 
        }
        current = current->suivant; 
    }
    listeT *currentTab = TStab;
    while (currentTab != NULL)
    {
        if((strcmp(currentTab->entite, entite) == 0)){
            return 1;
        }
        currentTab = currentTab->suivant;
    }
    return 0;
}
int insererTableau(char entite[], char type[], int taille, void *valeur) {
    listeT *current = TStab;
    if (rechercherIdf(entite)==1)
    {
        return -1;
    }
    listeT *nouveau = (listeT *)malloc(sizeof(listeT));
    if (nouveau) {
        strcpy(nouveau->entite, entite);
        strcpy(nouveau->type, type);
        nouveau->taille = taille;
        if (strcmp(type, "NUM") == 0) {
            nouveau->valeur.i = *(int *)valeur; //*(int *) = void 
        } 
        else if (strcmp(type, "REAL") == 0) {
            nouveau->valeur.f = *(float *)valeur; 
        }
        else if (strcmp(type, "TEXT") == 0) {
            nouveau->valeur.s = (char *)malloc(strlen((char *)valeur) +1);
            if (nouveau->valeur.s) {
                strcpy(nouveau->valeur.s, (char *)valeur); 
            }
        } 
        nouveau->suivant = TStab;
        TStab = nouveau;
    } else {
        fprintf(stderr, "Erreur d'allocation mémoire pour le symbole '%s'\n", entite);
        exit(1);
    }
    return 1;
}
int insererTS(char entite[], char type[], int is_const, void *valeur) {
    listeD *current = TS;
    if(rechercherIdf(entite)==1)
    {
        return -1;
    }
    while (current != NULL) {
        if (strcmp(current->entite, entite) == 0) {
            fprintf(stderr, "Erreur: Le symbole '%s' est déjà déclaré.\n", entite);
            exit(1);
        }
        current = current->suivant;
    }

    listeD *nouveau = (listeD *)malloc(sizeof(listeD));
    if (nouveau) {
        strcpy(nouveau->entite, entite);
        strcpy(nouveau->type, type);
        nouveau->is_const = is_const;
        if (strcmp(type, "NUM") == 0) {
            nouveau->valeur.i = *(int *)valeur; 
        } 
        else if (strcmp(type, "REAL") == 0) {
            nouveau->valeur.f = *(float *)valeur; 
        }
        else if (strcmp(type, "TEXT") == 0) {
            char **str_ptr = (char**)valeur; 
            if (str_ptr && *str_ptr) {  
                size_t len = strlen(*str_ptr);
                nouveau->valeur.s = (char *)malloc(len + 1);
                if (nouveau->valeur.s) 
                {
                    strcpy(nouveau->valeur.s, *str_ptr);
                    printf("Chaîne copiée : %s\n", nouveau->valeur.s);
                }
            }   else {
                    fprintf(stderr, "Erreur : Pointeur de chaîne invalide pour '%s'\n", entite);
                    free(nouveau);
                    return -1;
            }
}
        nouveau->suivant = TS;
        TS = nouveau;
    } 
    else {
        fprintf(stderr, "Erreur d'allocation mémoire pour le symbole '%s'\n", entite);
        exit(1);
    }
    return 1;
}


