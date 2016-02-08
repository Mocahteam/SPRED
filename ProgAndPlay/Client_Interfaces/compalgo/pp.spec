-- pp.spec
-- Interface avec les m�thodes natives de la biblioth�que de
-- communication avec le jeu
--

---------------------------------------
-- Op�ration de gestion de Prog&Play --
---------------------------------------

-- Initialise la PP
-- Retourne 0 si l'ouverture c'est bien pass�e
-- Retourne -1 en cas d'erreur
fonction open retourne <Entier> ;

-- Ferme Prog&Play et lib�re les ressources allou�es
-- Elle doit toujours �tre appel�e avant la fin du programme
-- Cette fonction doit �tre la derni�re des fonctions du PP � �tre appel�e
-- Retourne 0 en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite la PP initialis�e
fonction close retourne <Entier> ;

--------------------------------
-- Op�ration g�n�rales du jeu --
--------------------------------

-- Indique si le jeu est termin�
-- retourne une valeur > 0 si le jeu est termin�
-- retourne 0 si le jeu n'est pas termin�
-- retourne -1 en cas d'erreur
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction isGameOver retourne <Entier> ;

-- Fournit la taille de la carte sous forme de deux coordonn�es x (abcisse) et
-- y (ordonn�e) en cas de succ�s
-- en cas d'erreur, x = y = -1
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
proc�dure getMapSize (sortie x <R�el>, sortie y <R�el>) ;

-- Fournit sous forme de deux coordonn�es x (abcisse) et y (ordonn�e) la
-- position de d�part du joueur courant en cas de succ�s
-- en cas d'erreur, x = y = -1
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
proc�dure getStartPosition (sortie x <R�el>, sortie y <R�el>) ;

-- Fournit le niveau courant d'une certaine ressource
-- Retourne le niveau courant de la ressource "id"
-- Retourne -1 en cas d'erreur
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction getResource (entr�e id <Entier>) retourne <Entier> ;

----------------------------------------
-- Op�rations sur les zones sp�ciales --
----------------------------------------

-- Retourne le nombre de zones sp�ciales du jeu en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction getNumSpecialAreas retourne <Entier> ;


-- Fournit la position sous forme de coordonn�es x (abcisse) et y (ordonn�e) de
-- la zone sp�ciale z en cas de succ�s
-- en cas d'erreur, x = y = -1
-- n�cessite z doit �tre compris dans l'intervalle [0..n[ o� n est le nombre de
-- zones sp�ciales
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
proc�dure getSpecialAreaPosition
    (entr�e z <Entier>, sortie x <R�el>, sortie y <R�el>) ;

-----------------------------------
-- Op�rations sur les coalitions --
-----------------------------------

-- Retourne le nombre d'unit�s visibles de la coalition c en cas de succ�s
-- Retourne -1 en cas de probl�me
-- n�cessite c est une coalition valide : MOI, ENNEMI ou ALLIE
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction getNumUnits (entr�e c <Entier>) retourne <Entier> ;

-- Retourne le num�ro de la i�me unit� visible de la coalition c en cas de
-- succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite i compris dans l'intervalle [0..n[ o� n est le nombre d'unit� de
-- la coalition c
-- n�cessite c est une coalition valide : MOI, ENNEMI ou ALLIE
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction getUnitAt (entr�e c <Entier>, entr�e i <Entier>) retourne <Entier> ;

-------------------------------
-- Op�rations sur les unit�s --
-------------------------------

-- Retourne la coalition de l'unit� u en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitGetCoalition (entr�e u <Entier>) retourne <Entier> ;

-- Retourne le type d'une unit� u en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitGetType (entr�e u <Entier>) retourne <Entier> ;

-- Retourne la position de l'unit� u sous forme de coordonn�es x (abscisse) et
-- y (ordonn�e) en cas de succ�s
-- en cas d'erreur, x = y = -1
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
proc�dure unitGetPosition (entr�e u <Entier>,
                           sortie x <R�el>, sortie y <R�el>);

-- Retourne le niveau de sant� de l'unit� u en cas de succ�s
-- Retourne -1.0 en cas d'erreur
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitGetHealth (entr�e u <Entier>) retourne <R�el> ;


-- Retourne le niveau de sant� maximum que l'unit� u peut atteindre en cas de
-- succ�s
-- Retourne -1.0 en cas d'erreur
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitGetMaxHealth (entr�e u <Entier>) retourne <R�el> ;

-- Retourne le num�ro du groupe dont fait partie l'unit� u en cas de succ�s
-- Retourne -1 en cas d'erreur
-- Retourne -2 si l'unit� n'est affect�e � aucun groupe
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitGetGroup (entr�e u <Entier>) retourne <Entier> ;

-- Donne l'ordre � l'unit� u de s'affecter au groupe g
-- Si g = -1 alors l'unit� est retir�e de son groupe
-- Retourne 0 en cas de succ�s
-- Retourne -1 en cas d'echec
-- n�cessite u soit dirig�e par le joueur
-- n�cessite g >= -1 
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitSetGroup (entr�e u <Entier>, entr�e g <Entier>)
retourne <Entier> ;

-- Donne l'ordre � l'unit� u de se retirer de son groupe courant
-- n�cessite u soit dirig�e par le joueur
-- Retourne 0 en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitRemoveFromGroup (entr�e u <Entier>) retourne <Entier> ;

-- Donne l'ordre � l'unit� u de r�aliser l'action action sur l'unit� cible cible
-- Retourne 0 en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite u soit dirig�e par le joueur
-- n�cessite action est une action basique {DEPLACER, PATROUILLER, COMBATTRE,
-- ATTAQUER, GARDER, REPARER, RECLAMER} ou une action sp�ciale {NXFALG,
-- SIGTERM} ou une action de construction {-BADBLOCK, -LOGICBOMB, -DEBUG,
-- -KERNEL, -SOCKET, -TERMINAL, -ASSEMBLER, -BIT, -BYTE, -POINTER}
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitActionOnUnit
    (entr�e u <Entier>, entr�e action <Entier>, entr�e cible <Entier>)
retourne <Entier> ;

-- Donne l'ordre � l'unit� u de r�aliser l'action action � la position (x, y)
-- Retourne 0 en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite u soit dirig�e par le joueur
-- n�cessite action est une action basique {DEPLACER, PATROUILLER, COMBATTRE,
-- ATTAQUER, GARDER, RESTORER} ou une action sp�ciale {NXFALG, SIGTERM} ou une
-- action de construction {-BADBLOCK, -LOGICBOMB, -DEBUG, -KERNEL, -SOCKET,
-- -TERMINAL, -ASSEMBLER, -BIT, -BYTE, -POINTER}
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitActionOnPosition
    (entr�e u <Entier>, entr�e action <Entier>, entr�e x <R�el>,
    entr�e y <R�el>)
retourne <Entier> ;

-- Donne l'ordre � l'unit� u de r�aliser l'action action avec le param�tre param
-- Retourne 0 en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite u soit dirig�e par le joueur
-- n�cessite action est une action basique {WAIT, FIRESTATE, SELFDESTRUCTION,
-- REPEAT, MOVESTATE} ou une action sp�ciale {LAUNCHMINES}
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitUntargetedAction
    (entr�e u <Entier>, entr�e action <Entier>, entr�e param <R�el>)
retourne <Entier> ;

------------------------------------------------------------------------------
-- Op�ration d'acc�s aux commandes en attente                               --
-- Attention : ces op�rations doivent imp�rativement �tre encadr�es par les --
-- op�rations de gestion de section critique                                --
------------------------------------------------------------------------------

-- Retourne le nombre de commande en attente pour l'unit� u en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite u soit dirig�e par le joueur
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitGetNumPdgCmds (entr�e u <Entier>) retourne <Entier> ;

-- Retourne le code de la i�me commande en attente pour l'unit� u en cas de
-- succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite u soit dirig�e par le joueur
-- n�cessite i doit �tre compris dans l'intervalle [0..n[ o� n est le nombre de
-- commande en attente pour l'unit� u
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitPdgCmdGetCode (entr�e u <Entier>, entr�e i <Entier>)
retourne <Entier> ;

-- Retourne le nombre de param�tres associ�s � la i�me commande en attente pour
-- l'unit� u en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite u soit dirig�e par le joueur
-- n�cessite i doit �tre compris dans l'intervalle [0..n[ o� n est le nombre de
-- commande en attente pour l'unit� u
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitPdgCmdGetNumParam (entr�e u <Entier>, entr�e i <Entier>)
retourne <Entier> ;

-- Retourne le param�tre num�ro idParam de la commande en attente num�ro idCmd
-- de l'unit� u en cas de succ�s
-- Retourne -1 en cas d'erreur
-- n�cessite u soit dirig�e par le joueur
-- n�cessite idCmd doit �tre compris dans l'intervalle [0..n[ o� n est le
-- nombre de commandes en attente pour l'unit� u
-- n�cessite idParam doit �tre compris dans l'intervalle [0..m[ o� m est le
-- nombre de param�tre de la commande en attente num�ro idCmd pour l'unit� u
-- n�cessite la PP initialis�e
-- n�cessite le jeu rafra�chit
fonction unitPdgCmdGetParam (entr�e u <Entier>, entr�e idCmd <Entier>,
                             entr�e idParam <Entier>) retourne <R�el> ;

-----------------------------------------------
-- Op�rations de gestion de section critique --
-----------------------------------------------

-- Cette proc�dure doit �tre appel�e avant l'entr�e d'une section critique
-- Ne pas oublier d'appeler "exitCriticalSection" en sortant de la section critique
proc�dure enterCriticalSection;

-- Cette proc�dure doit �tre appel�e � la fin de la section critique
proc�dure exitCriticalSection;

--------------------------------------
-- Op�ration de gestion des erreurs --
--------------------------------------

-- Retourne la derni�re erreur sous la forme d'une cha�ne
fonction getError retourne <Cha�ne>;

-- Supprime toutes les informations li�es � la derni�re erreur survenue
proc�dure clearError;

-------------------------------
-- Op�rations additionnelles --
-------------------------------

-- Retourne un nombre al�atoire compris entre 0.0 et limite
fonction random (entr�e limite <R�el>) retourne <R�el> ;

-- Effectue une pause de t milisecondes
proc�dure delay (entr�e t <Entier>) ;

-- convertit un R�el en Entier
fonction r�elVersEntier (entr�e r <R�el>) retourne <Entier> ;
