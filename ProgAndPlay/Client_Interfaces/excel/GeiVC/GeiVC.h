#ifndef GEI_VC_H
#define GEI_VC_H

#ifdef __cplusplus
extern "C" {
#endif

/*****************************************************************************/
/* D�finition des types de donn�e                                            */
/*****************************************************************************/

/*
 * Repr�sente les diff�rentes coalitions de joueurs.
 */
typedef enum {
  ME,     /* repr�sente le joueur. */
  ALLY,   /* repr�sente les alli�s du joueur. */
  ENEMY   /* repr�sente les enemis du joueur. */
} GEI_Coalition;

/*
 * D�fini le type repr�sentant une unit�.
 */
typedef int GEI_Unit;

/*
 * D�fini le type position pour repr�senter une coordonn�e dans le jeu
 */
typedef struct {
  float x;  /* repr�sente l'abscisse. */
  float y;  /* repr�sente l'ordonn�e. */
} GEI_Pos;

/*****************************************************************************/
/* Fonctions de communication avec le jeu                                    */
/*****************************************************************************/

/*
 * Initialise le GEI. Cette fonction doit �tre appel�e avant toute autre
 * fonction du GEI.
 * Retourne : 0 en cas de succ�s
 *            -11 en cas d'erreur d'ouverture de la m�moire partag�e
 *            -6 s'il est impossible de r�ouvrir la GEI
 */
int GEI_Open();

/*
 * Demande au jeu de rafraichir l'�tat du jeu. Cette fonction est bloquante
 * tant que le jeu n'a pas termin� sa mise � jour.
 * Retourne : 0 en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 */
int GEI_Refresh ();

/*
 * Ferme le GEI lib�re les ressources allou�es. Elle doit toujours �tre appel�e
 * avant la fin du programme. Cette fonction doit �tre la derni�re des
 * fonctions du GEI � �tre appel�e.
 * Retourne : 0 en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 */
int GEI_Close ();

/*
 * Fournit la taille de la map sous la forme d'une position.
 * Retourne : La taille de la carte en cas de succ�s
 *            Une position contenant des -1 si la GEI n'est pas initialis�e
 */
GEI_Pos GEI_MapSize ();

/*
 * Fournit la position de d�part du joueur courant.
 * Retourne : La position en cas de succ�s
 *            Une position contenant des -1 si la GEI n'est pas initialis�e
 */
GEI_Pos GEI_StartPosition ();

/*
 * Fournit le nombre de zone constructible
 * Retourne : le nombre de zone constructible en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 */
int GEI_GetNumBuildingLand ();

/*
 * Fournit les coordonn�es de la zone de construction "bl".
 * bl : num�tro de la zone de construction
 * Retourne : la position en cas de succ�s
 *            Une position contenant des -1 si la GEI n'est pas initialis�e
 *            Une position contenant des -9 si la zone de construction est
 * invalide
 */
GEI_Pos GEI_BuildingLandPosition(int bl);

/*
 * Fournit le nombre d'unit�s visibles appartenant � la coalission "c"
 * c : coalition � consulter
 * Retourne : le nombre d'unit�s visibles de cette coalition en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 *            -4 si la coalition n'est pas valide
 */
int GEI_GetNumUnits (GEI_Coalition c);

/*
 * Fournit la "index"�me unit� visible de la coalition "c"
 * index : o� trouver une unit�
 * c : coalition de l'unit� � chercher
 * Retourne : l'unit� en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 *            -4 si la coalition est invalide
 *            -7 si i d�passe le nombre d'unit� de la coalition c
 */
GEI_Unit GEI_GetUnitAt (int index, GEI_Coalition c);

/*
 * Int�roge l'unit� "unit" pour renvoyer sa coalition
 * unit : unit� � int�roger
 * Retourne : la coalition en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 *            -2 si l'unit� n'est pas trouv�e
 */
GEI_Coalition GEI_Unit_GetCoalition (GEI_Unit unit);

/*
 * Int�roge l'unit� "unit" pour renvoyer son type
 * unit : unit� � int�roger
 * Retourne : le type en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 *            -2 si l'unit� n'est pas trouv�e
 *            -8 si le type de l'unit� n'est pas trouv�
 */
int GEI_Unit_GetType (GEI_Unit unit);

/*
 * Int�roge l'unit� "unit" pour renvoyer sa position.
 * unit : unit� � int�roger
 * Retourne : la position en cas de succ�s
 *            Une position contenant des -1 si la GEI n'est pas initialis�e
 *            Une position contenant des -2 si l'unit� n'est pas trouv�e
 */
GEI_Pos GEI_Unit_GetPosition (GEI_Unit unit);

/*
 * Int�roge l'unit� "unit" pour renvoyer sa vie.
 * unit : unit� � int�roger
 * Retourne : la vie en cas de succ�s
 *            -1 si la GEI n'est pas initiali�e
 *            -2 si l'unit� n'est pas trouv�e
 */
float GEI_Unit_GetHealth (GEI_Unit unit);

/*
 * Int�roge l'unit� "unit" pour renvoyer le groupe � laquelle elle appartient
 * unit : unit� � int�roger
 * Retourne : le num�ro du groupe [0;9] auquel appartient l'unit�.
 *            10 si l'unit� n'est affect�e � aucun groupe.
 *            -1 si la GEI n'est pas initiali�e
 *            -2 si l'unit� n'est pas trouv�e
 */
int GEI_Unit_GetGroup (GEI_Unit unit);

/*
 * Donne l'ordre � l'unit� "unit" de s'affecter au groupe "group".
 * Seules les unit�s dirig�es par le joueur peuvent recevoir un tel ordre.
 * unit : unit� � affecter
 * group : groupe d'affectation. -1 <= groupe <= 9. Si groupe == -1 alors
 *         l'unit� est retir�e de son groupe
 * Retourne : 0 en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 *            -2 si l'unit� n'est pas trouv�e
 *            -3 si le joueur n'est pas le propri�taire de l'unit� � d�placer
 *            -10 le groupe est incorrect
 */
int GEI_Unit_SetGroup (GEI_Unit unit, int group);

/*
 * Int�roge l'unit� "unit" pour d�terminer depuis combien de temps elle est
 * inactive. Une unit� est concid�r�e en activit� si elle se d�place, si elle
 * est en combat ou si elle construit quelque chose (batiment ou unit�)
 * unit : unit� � int�roger
 * Retourne : 0 si l'unit� est active	
 *            >0 si l'unit� est inactive depuis un certain temps
 *            -1 si la GEI n'est pas initialis�e
 *            -2 si l'unit� n'est pas trouv�e
 */
int GEI_Unit_InactiveTime (GEI_Unit unit);

/*
 * Donne l'ordre � l'unit� "unit" de r�aliser l'action "action" sur l'unit�
 * "target".
 * Seules les unit�s dirig�es par le joueur peuvent recevoir un tel ordre.
 * unit : unit� � commander
 * action : action � r�aliser
 * target : unit� cibl�e
 * Retourne : 0 en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 *            -2 si l'unit� n'est pas trouv�e
 *            -3 si le joueur n'est pas le propri�taire de l'unit� � d�placer
 *            -5 si l'unit� cible n'est pas trouv�e
 */
int GEI_Unit_ActionOnUnit (int unit, int action, int target);

/*
 * Donne l'ordre � l'unit� "unit" de r�aliser l'action "action" sur la
 * position (x, y).
 * Seules les unit�s dirig�es par le joueur peuvent recevoir un tel ordre.
 * unit : unit� � commander
 * action : action � r�aliser
 * x : abscisse de la position cibl�e
 * y : ordonn�e de la position cibl�e
 * Retourne : 0 en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 *            -2 si l'unit� n'est pas trouv�e
 *            -3 si le joueur n'est pas le propri�taire de l'unit� � d�placer
 */
int GEI_Unit_ActionOnPosition (int unit, int action, float x, float y);

/* Donne l'ordre � l'unit� "unit" de stopper son action en cours.
 * Seules les unit�s dirig�es par le joueur peuvent recevoir un tel ordre.
 * unit : unit� � stopper.
 * Retourne : 0 en cas de succ�s
 *            -1 si la GEI n'est pas initialis�e
 *            -2 si l'unit� n'est pas trouv�e
 *            -3 si le joueur n'est pas le propri�taire de l'unit� � stopper
 */
int GEI_Unit_Stop (GEI_Unit unit);

#ifdef __cplusplus
}
#endif

#endif
