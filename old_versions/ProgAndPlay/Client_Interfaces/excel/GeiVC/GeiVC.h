#ifndef GEI_VC_H
#define GEI_VC_H

#ifdef __cplusplus
extern "C" {
#endif

/*****************************************************************************/
/* Définition des types de donnée                                            */
/*****************************************************************************/

/*
 * Représente les différentes coalitions de joueurs.
 */
typedef enum {
  ME,     /* représente le joueur. */
  ALLY,   /* représente les alliés du joueur. */
  ENEMY   /* représente les enemis du joueur. */
} GEI_Coalition;

/*
 * Défini le type représentant une unité.
 */
typedef int GEI_Unit;

/*
 * Défini le type position pour représenter une coordonnée dans le jeu
 */
typedef struct {
  float x;  /* représente l'abscisse. */
  float y;  /* représente l'ordonnée. */
} GEI_Pos;

/*****************************************************************************/
/* Fonctions de communication avec le jeu                                    */
/*****************************************************************************/

/*
 * Initialise le GEI. Cette fonction doit être appelée avant toute autre
 * fonction du GEI.
 * Retourne : 0 en cas de succès
 *            -11 en cas d'erreur d'ouverture de la mémoire partagée
 *            -6 s'il est impossible de réouvrir la GEI
 */
int GEI_Open();

/*
 * Demande au jeu de rafraichir l'état du jeu. Cette fonction est bloquante
 * tant que le jeu n'a pas terminé sa mise à jour.
 * Retourne : 0 en cas de succès
 *            -1 si la GEI n'est pas initialisée
 */
int GEI_Refresh ();

/*
 * Ferme le GEI libère les ressources allouées. Elle doit toujours être appelée
 * avant la fin du programme. Cette fonction doit être la dernière des
 * fonctions du GEI à être appelée.
 * Retourne : 0 en cas de succès
 *            -1 si la GEI n'est pas initialisée
 */
int GEI_Close ();

/*
 * Fournit la taille de la map sous la forme d'une position.
 * Retourne : La taille de la carte en cas de succès
 *            Une position contenant des -1 si la GEI n'est pas initialisée
 */
GEI_Pos GEI_MapSize ();

/*
 * Fournit la position de départ du joueur courant.
 * Retourne : La position en cas de succès
 *            Une position contenant des -1 si la GEI n'est pas initialisée
 */
GEI_Pos GEI_StartPosition ();

/*
 * Fournit le nombre de zone constructible
 * Retourne : le nombre de zone constructible en cas de succès
 *            -1 si la GEI n'est pas initialisée
 */
int GEI_GetNumBuildingLand ();

/*
 * Fournit les coordonnées de la zone de construction "bl".
 * bl : numétro de la zone de construction
 * Retourne : la position en cas de succès
 *            Une position contenant des -1 si la GEI n'est pas initialisée
 *            Une position contenant des -9 si la zone de construction est
 * invalide
 */
GEI_Pos GEI_BuildingLandPosition(int bl);

/*
 * Fournit le nombre d'unités visibles appartenant à la coalission "c"
 * c : coalition à consulter
 * Retourne : le nombre d'unités visibles de cette coalition en cas de succès
 *            -1 si la GEI n'est pas initialisée
 *            -4 si la coalition n'est pas valide
 */
int GEI_GetNumUnits (GEI_Coalition c);

/*
 * Fournit la "index"ème unité visible de la coalition "c"
 * index : où trouver une unité
 * c : coalition de l'unité à chercher
 * Retourne : l'unité en cas de succès
 *            -1 si la GEI n'est pas initialisée
 *            -4 si la coalition est invalide
 *            -7 si i dépasse le nombre d'unité de la coalition c
 */
GEI_Unit GEI_GetUnitAt (int index, GEI_Coalition c);

/*
 * Intéroge l'unité "unit" pour renvoyer sa coalition
 * unit : unité à intéroger
 * Retourne : la coalition en cas de succès
 *            -1 si la GEI n'est pas initialisée
 *            -2 si l'unité n'est pas trouvée
 */
GEI_Coalition GEI_Unit_GetCoalition (GEI_Unit unit);

/*
 * Intéroge l'unité "unit" pour renvoyer son type
 * unit : unité à intéroger
 * Retourne : le type en cas de succès
 *            -1 si la GEI n'est pas initialisée
 *            -2 si l'unité n'est pas trouvée
 *            -8 si le type de l'unité n'est pas trouvé
 */
int GEI_Unit_GetType (GEI_Unit unit);

/*
 * Intéroge l'unité "unit" pour renvoyer sa position.
 * unit : unité à intéroger
 * Retourne : la position en cas de succès
 *            Une position contenant des -1 si la GEI n'est pas initialisée
 *            Une position contenant des -2 si l'unité n'est pas trouvée
 */
GEI_Pos GEI_Unit_GetPosition (GEI_Unit unit);

/*
 * Intéroge l'unité "unit" pour renvoyer sa vie.
 * unit : unité à intéroger
 * Retourne : la vie en cas de succès
 *            -1 si la GEI n'est pas initialiée
 *            -2 si l'unité n'est pas trouvée
 */
float GEI_Unit_GetHealth (GEI_Unit unit);

/*
 * Intéroge l'unité "unit" pour renvoyer le groupe à laquelle elle appartient
 * unit : unité à intéroger
 * Retourne : le numéro du groupe [0;9] auquel appartient l'unité.
 *            10 si l'unité n'est affectée à aucun groupe.
 *            -1 si la GEI n'est pas initialiée
 *            -2 si l'unité n'est pas trouvée
 */
int GEI_Unit_GetGroup (GEI_Unit unit);

/*
 * Donne l'ordre à l'unité "unit" de s'affecter au groupe "group".
 * Seules les unités dirigées par le joueur peuvent recevoir un tel ordre.
 * unit : unité à affecter
 * group : groupe d'affectation. -1 <= groupe <= 9. Si groupe == -1 alors
 *         l'unité est retirée de son groupe
 * Retourne : 0 en cas de succès
 *            -1 si la GEI n'est pas initialisée
 *            -2 si l'unité n'est pas trouvée
 *            -3 si le joueur n'est pas le propriétaire de l'unité à déplacer
 *            -10 le groupe est incorrect
 */
int GEI_Unit_SetGroup (GEI_Unit unit, int group);

/*
 * Intéroge l'unité "unit" pour déterminer depuis combien de temps elle est
 * inactive. Une unité est concidérée en activité si elle se déplace, si elle
 * est en combat ou si elle construit quelque chose (batiment ou unité)
 * unit : unité à intéroger
 * Retourne : 0 si l'unité est active	
 *            >0 si l'unité est inactive depuis un certain temps
 *            -1 si la GEI n'est pas initialisée
 *            -2 si l'unité n'est pas trouvée
 */
int GEI_Unit_InactiveTime (GEI_Unit unit);

/*
 * Donne l'ordre à l'unité "unit" de réaliser l'action "action" sur l'unité
 * "target".
 * Seules les unités dirigées par le joueur peuvent recevoir un tel ordre.
 * unit : unité à commander
 * action : action à réaliser
 * target : unité ciblée
 * Retourne : 0 en cas de succès
 *            -1 si la GEI n'est pas initialisée
 *            -2 si l'unité n'est pas trouvée
 *            -3 si le joueur n'est pas le propriétaire de l'unité à déplacer
 *            -5 si l'unité cible n'est pas trouvée
 */
int GEI_Unit_ActionOnUnit (int unit, int action, int target);

/*
 * Donne l'ordre à l'unité "unit" de réaliser l'action "action" sur la
 * position (x, y).
 * Seules les unités dirigées par le joueur peuvent recevoir un tel ordre.
 * unit : unité à commander
 * action : action à réaliser
 * x : abscisse de la position ciblée
 * y : ordonnée de la position ciblée
 * Retourne : 0 en cas de succès
 *            -1 si la GEI n'est pas initialisée
 *            -2 si l'unité n'est pas trouvée
 *            -3 si le joueur n'est pas le propriétaire de l'unité à déplacer
 */
int GEI_Unit_ActionOnPosition (int unit, int action, float x, float y);

/* Donne l'ordre à l'unité "unit" de stopper son action en cours.
 * Seules les unités dirigées par le joueur peuvent recevoir un tel ordre.
 * unit : unité à stopper.
 * Retourne : 0 en cas de succès
 *            -1 si la GEI n'est pas initialisée
 *            -2 si l'unité n'est pas trouvée
 *            -3 si le joueur n'est pas le propriétaire de l'unité à stopper
 */
int GEI_Unit_Stop (GEI_Unit unit);

#ifdef __cplusplus
}
#endif

#endif
