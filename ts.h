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

void supprimerDoublons(liste **tete)
{
    liste *courant = *tete;
    while (courant != NULL)
    {
        liste *predecesseur = courant;
        liste *suivant = courant->suivant;

        while (suivant != NULL)
        {
           
            if (strcmp(courant->entite, suivant->entite) == 0)
            {
       
                predecesseur->suivant = suivant->suivant;
                free(suivant);
                suivant = predecesseur->suivant;
            }
            else
            {
              
                predecesseur = suivant;
                suivant = suivant->suivant;
            }
        }

        courant = courant->suivant;
    }
}

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
            char **str_ptr = (char**)valeur; 
            if (str_ptr && *str_ptr) {  
                size_t len = strlen(*str_ptr);
                nouveau->valeur.s = (char *)malloc(len + 1);
                if (nouveau->valeur.s) 
                {
                    strcpy(nouveau->valeur.s, *str_ptr);
                }
            }   else {
                    fprintf(stderr, "Erreur : Pointeur de chaîne invalide pour '%s'\n", entite);
                    free(nouveau);
                    return -1;
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
                }
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
int rechercherTaille(char tete[]) 
{
    listeT *current=TStab;
    while (current != NULL)
    {
        if(strcmp(current->entite,tete)==0)
        {
            return current->taille;
        }
        current = current->suivant;
    }
    return -1;
}
void afficherListe(const char* titre, liste* tete) {
        printf("╔═══════════════ %s ═══════════════╗\n", titre);
        printf("║                                              ║\n");
        liste* current = tete;
        while (current != NULL) {
            printf("║ %-44s ║\n", current->entite);
            current = current->suivant;
        }
        printf("║                                              ║\n");
        printf("╚══════════════════════════════════════════════╝\n\n");
    }

void afficherToutesLesTablesSymboles() {
    printf("\n╔════════════════════════════════════════════════════════════════╗\n");
    printf("║                    Tables des Symboles                         ║\n");
    printf("╚════════════════════════════════════════════════════════════════╝\n\n");
    supprimerDoublons(&ListeMotCle);
    supprimerDoublons(&ListeOperateurLogique);
    supprimerDoublons(&ListeOperateurArithmetique);
    supprimerDoublons(&ListeOperateurNoAsso);
    afficherListe("Mots-clés", ListeMotCle);
    afficherListe("Opérateurs logiques", ListeOperateurLogique);
    afficherListe("Opérateurs arithmétiques", ListeOperateurArithmetique);
    afficherListe("Opérateurs non-associatifs", ListeOperateurNoAsso);

    printf("╔═══════════════ Table des Symboles principale ═══════════════╗\n");
    printf("║                                                            ║\n");
    printf("║ %-15s │ %-10s │ %-10s │ %-15s ║\n", "Entité", "Type", "Constante", "Valeur");
    printf("╟───────────────────┼────────────┼────────────┼─────────────────╢\n");
    
    listeD *current = TS;
    while (current != NULL) {
        printf("║ %-15s │ %-10s │ %-10s │ ", 
               current->entite, 
               current->type, 
               current->is_const ? "Oui" : "Non");
        
        if (strcmp(current->type, "NUM") == 0) {
            printf("%-15d ║\n", current->valeur.i);
        } else if (strcmp(current->type, "REAL") == 0) {
            printf("%-15.2f ║\n", current->valeur.f);
        } else if (strcmp(current->type, "TEXT") == 0) {
            printf("%-15s ║\n", current->valeur.s);
        } else {
            printf("%-15s ║\n", "Inconnu");
        }
        
        current = current->suivant;
    }
    printf("║                                                            ║\n");
    printf("╚════════════════════════════════════════════════════════════╝\n\n");

    printf("╔═══════════════ Table des Tableaux ═══════════════╗\n");
    printf("║                                                  ║\n");
    printf("║ %-15s │ %-10s │ %-10s │ %-6s ║\n", "Entité", "Type", "Taille", "Valeur");
    printf("╟───────────────────┼────────────┼────────────┼────────╢\n");
    
    listeT *currentT = TStab;
    while (currentT != NULL) {
        printf("║ %-15s │ %-10s │ %-10d │ ", 
               currentT->entite, 
               currentT->type, 
               currentT->taille);
        
        if (strcmp(currentT->type, "NUM") == 0) {
            printf("%-6d ║\n", currentT->valeur.i);
        } else if (strcmp(currentT->type, "REAL") == 0) {
            printf("%-6.2f ║\n", currentT->valeur.f);
        } else if (strcmp(currentT->type, "TEXT") == 0) {
            printf("%-6s ║\n", currentT->valeur.s);
        } else {
            printf("%-6s ║\n", "Inconnu");
        }
        
        currentT = currentT->suivant;
    }
    printf("║                                                  ║\n");
    printf("╚══════════════════════════════════════════════════╝\n");
}
