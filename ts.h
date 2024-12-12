#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

int rechercherIdf(char entiteRecherchee[]) {
    listeD *current = TS; 
    while (current != NULL) {
        if (strcmp(current->entite, entiteRecherchee) == 0) {
            return 1; 
        }
        current = current->suivant; 
    }
    listeT *currentN = TStab;
    while (currentN != NULL)
    {
        if((strcmp(currentN->entite, entiteRecherchee) == 0)){
            return 1;
        }
        currentN = currentN->suivant;
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



void insererMotCle(char tete[])
{
    liste *nouveau = (liste *)malloc(sizeof(liste));
    if (nouveau)
    {
        strcpy(nouveau->entite, tete);
        nouveau->suivant = ListeMotCle;
        ListeMotCle = nouveau;
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
    }
}

// Fonction d'affichage unifiée pour toutes les listes
void afficher()
{
    // Affichage de la liste des mots-clés
    printf("\nListe des mots-clés :\n");
    liste *current = ListeMotCle;
    while (current != NULL)
    {
        printf("%s\n", current->entite);
        current = current->suivant;
    }

    // Affichage de la liste des opérateurs logiques
    printf("\nListe des opérateurs logiques :\n");
    current = ListeOperateurLogique;
    while (current != NULL)
    {
        printf("%s\n", current->entite);
        current = current->suivant;
    }

    // Affichage de la liste des opérateurs arithmétiques
    printf("\nListe des opérateurs arithmétiques :\n");
    current = ListeOperateurArithmetique;
    while (current != NULL)
    {
        printf("%s\n", current->entite);
        current = current->suivant;
    }

    // Affichage de la liste des opérateurs non-associatifs
    printf("\nListe des opérateurs non-associatifs :\n");
    current = ListeOperateurNoAsso;
    while (current != NULL)
    {
        printf("%s\n", current->entite);
        current = current->suivant;
    }
}

void afficherTS() {
    printf("\n/*************** Table des Symboles ******************/\n");
    printf("_____________________________________________________\n");
    printf("\t| Entite | Type | Constante | Valeur |\n");
    printf("_____________________________________________________\n");

    listeD *current = TS;         
    while (current != NULL) {
        printf("\t| %-6s | %-4s | %-9s | ", current->entite, current->type, current->is_const ? "Oui" : "Non");
        if (strcmp(current->type, "NUM") == 0) {
            printf("%-6d |\n", current->valeur.i);
        } 
        else if (strcmp(current->type, "REAL") == 0) {
            printf("%-6.2f |\n", current->valeur.f); 
        } 
        else if (strcmp(current->type, "TEXT") == 0) {
            printf("%-1s |\n", current->valeur.s);  
        } 
        else {
            printf("Inconnu |\n"); 
        }

        current = current->suivant;
    }
}
void afficherTStab() {
    printf("\n/*************** Table des Symboles ******************/\n");
    printf("_____________________________________________________\n");
    printf("\t| Entite | Type | Taille | Valeur |\n");
    printf("_____________________________________________________\n");

    listeT *current = TStab;
    while (current != NULL) {
        printf("\t| %-6s | %-4s | %-9d | ", current->entite, current->type, current->taille);
        if (strcmp(current->type, "NUM") == 0) {
            printf("%-6d |\n", current->valeur.i); 
        } 
        else if (strcmp(current->type, "REAL") == 0) {
            printf("%-6.2f |\n", current->valeur.f); 
        } 
        else if (strcmp(current->type, "TEXT") == 0) {
            printf("%-6s |\n", current->valeur.s); 
        } 
        else {
            printf("Inconnu |\n");
        }

        current = current->suivant;
    }
}
struct listeD *chercherTS(char nom[]) 
{
    struct listeD *current = TS;  
    while (current != NULL) 
    {
        if (strcmp(current->entite, nom) == 0) 
        {
            return current;  
        }
        current = current->suivant; 
    }
    return NULL; 
}
char *chercherType(char nom[]) {
    listeD *currentD = TS;
    while (currentD != NULL) {
        if (strcmp(currentD->entite, nom) == 0) {
            return currentD->type;  
        }
        currentD = currentD->suivant;
    }
    listeT *currentT = TStab;
    while (currentT != NULL) {
        if (strcmp(currentT->entite, nom) == 0) {
            return currentT->type; 
        }
        currentT = currentT->suivant;
    }
    return NULL;  
}
int rechercherTaille(char tete[]) 
{
    listeT *current=TStab;
    while (current != NULL)
    {
        if(strcmp(current->entite,tete)==0)
        {
            printf("hello");
            return current->taille;
        }
        current = current->suivant;
    }
    return -1;
}
int is_constant(char nom[])
{
    listeD *current = TS; 
    while (current != NULL)
    {
        if(strcmp(current->entite,nom)==0)
        {
            return current->is_const;
        }
    }
    return -1;
}
float chercherValeur(char nom[])
{
    listeD *current = TS;
    while (current != NULL)
    {
        if(strcmp(current->entite,nom)==0)
        {
            if(strcmp(current->type,"REAL")==0)
            {
                return (float) current->valeur.i;
            }
            else if(strcmp(current->type,"REAL")==0)
            {
                return  current->valeur.f;
            }
        }
    }
    return -1;
}