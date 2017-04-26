-- jeu.spec
-- biblioth�que d'interaction avec le jeu de Compalgo
--

--------------------------
-- D�finition des types --
--------------------------

-- une position repr�sente un point pr�cis sur la carte
type Position : enregistrement
    x <R�el>,  -- abcisse
    y <R�el> ; -- ordonn�e

-- un tableau de param�tres
constante NBPARAMETRESMAX <Entier> = 3;
type TabParam�tres : tableau [1 � NBPARAMETRESMAX] de <R�el>;

-- repr�sentation d'une commande
type Commande : enregistrement
    code <Entier>, -- code de la commande
    nbParam�tres <Entier>, -- nombre de param�tres associ�s � cette commande
    param�tres <TabParam�tres> ; -- liste des param�tres associ�s � cette
                                 -- commande

-- un tableau de commande
constante NBCOMMANDEMAX <Entier> = 10;
type TabCommandes : tableau [1 � NBCOMMANDEMAX] de <Commande>;

-- repr�sentation d'une unit�
type Unit� : enregistrement
    id <Entier>,         -- identifiant unique de l'unit�
    coalition <Entier>,  -- coalition d'appartenance de l'unit� : MOI, ENNEMI
                         -- ou ALLIE
    sorte <Entier>,      -- type de l'unit� : BADBLOCK, LOGICBOMB, DEBUG,
                         -- KERNEL, SOCKET, TERMINAL, ASSEMBLER, BIT, BYTE,
                         -- POINTER
    position <Position>, -- position de l'unit� sur la carte
    sant� <R�el>,        -- niveau de sant� de l'unit�
    sant�Max <R�el>,     -- sant� maximum que peut atteindre l'unit�
    groupe <Entier>,     -- groupe d'affectaction de l'unit�
                         -- si groupe < 0 alors l'unit� n'est affect�e � aucun
                         -- groupe
    nbCommandeATraiter <Entier>,         -- nombre de commande en attente
    commandeATraiter <TabCommandes> ;    -- liste de commande en attente
                            

----------------------------------
-- Op�rations de gestion du jeu --
----------------------------------

-- Ouvre le jeu
-- Cette proc�dure doit �tre appel�e avant toute autre fonction du jeu sous
-- peine de r�sultats incoh�rents
proc�dure ouvrirJeu ;

-- Ferme le jeu
proc�dure fermerJeu ;

--------------------------------
-- Op�rations g�n�rales du jeu --
--------------------------------

-- Indique si le jeu est termin�
fonction jeuEstTermin� retourne <Bool�en> ;

-- Fournit la dimention de la carte de jeu sous la forme d'une Position (coin
-- inf�rieure droit)
fonction dimensionsCarte retourne <Position> ;

-- Fournit la position de d�part de la partie
fonction positionDeD�part retourne <Position> ;

-- Fournit le niveau courant de la ressource id
fonction resourcesDisponibles (entr�e id <Entier>) retourne <Entier> ;

----------------------------------------
-- Op�rations sur les zones sp�ciales --
----------------------------------------

-- Retourne le nombre de zones sp�ciales
fonction nombreZonesSp�ciales retourne <Entier> ;

-- Fournit les positions de la zone sp�ciale num�ro zs
-- n�cessite zs compris dans l'intervalle [1..n] 
-- o� n est le nombre de zone constructible
fonction positionZoneSp�ciale (entr�e zs <Entier>) retourne <Position> ;

-----------------------------------
-- Op�rations sur les coalitions --
-----------------------------------

-- Retourne le nombre d'unit�s de la coalition c
-- Seules les unit�s visibles par le joueur sont comptabilis�es
-- n�cessite c appartient � l'ensemble {MOI, ALLIE, ENNEMI)
fonction nombreUnit�s (entr�e c <Entier>) retourne <Entier> ;

-- Retourne la i�me unit� visible de la coalition c
-- n�cessite c appartient � l'ensemble {MOI, ALLIE, ENNEMI)
-- n�cessite i compris dans l'intervalle [1..n] 
-- o� n est le nombre d'unit� de la coalition c
fonction i�meUnit� (entr�e c <Entier>, entr�e i <Entier>) retourne <Unit�> ;

-------------------------------
-- Op�rations sur les unit�s --
-------------------------------

-- Retourne VRAI si l'unit� est visible par le joueur
fonction estVisible (entr�e u <Unit�>) retourne <Bool�en> ;

-- Retourne VRAI si l'unit� u est synchrone avec le dernier rafra�chissement du
-- jeu
-- n�cessite u visible
fonction estSynchronis�e (entr�e u <Unit�>) retourne <Bool�en> ;

-- Synchronise l'unit� u avec le dernier rafra�chissement du jeu
-- n�cessite u visible
proc�dure synchroniserUnit� (m�j u <Unit�>) ;

-- Ajoute l'unit� u au groupe g
-- n�cessite u visible
-- n�cessite u dirig�e par le joueur (u.coalition = MOI)
-- n�cessite groupe >= 0
proc�dure affecterGroupe (entr�e u <Unit�>, entr�e g <Entier>) ;

-- Retire l'unit� u de son groupe d'appartenance
-- n�cessite u visible
-- n�cessite u dirig�e par le joueur  (u.coalition = MOI)
proc�dure retirerGroupe (entr�e u <Unit�>) ;

-- L'unit� u r�alise l'action action sur l'unit� cible cible
-- n�cessite u unit� visible
-- n�cessite u dirig�e par le joueur (u.coalition = MOI)
-- n�cessite cible unit� visible
-- n�cessite action est une action basique {DEPLACER, PATROUILLER, COMBATTRE,
-- ATTAQUER, GARDER, REPARER, RECLAMER} ou une action sp�ciale {NXFALG,
-- SIGTERM} ou une action de construction {BUILDBADBLOCK, BUILDLOGICBOMB,
-- BUILDSOCKET, BUILDTERMINAL, DEBUG, BUILDASSEMBLER, BUILDBYTE, BUILDPOINTER,
-- BUILDBIT}
proc�dure r�aliserActionSurUnit� (entr�e u <Unit�>, entr�e action <Entier>,
    entr�e cible <Unit�>) ;

-- L'unit� u r�alise l'action action sur la position pos
-- n�cessite u unit� visible
-- n�cessite u dirig�e par le joueur (u.coalition = MOI)
-- n�cessite action est une action basique {DEPLACER, PATROUILLER, COMBATTRE,
-- ATTAQUER, GARDER, RESTORER} ou une action sp�ciale {NXFALG, SIGTERM} ou une
-- action de construction {BUILDBADBLOCK, BUILDLOGICBOMB, BUILDSOCKET,
-- BUILDTERMINAL, DEBUG, BUILDASSEMBLER, BUILDBYTE, BUILDPOINTER, BUILDBIT}
proc�dure r�aliserActionSurPosition (entr�e u <Unit�>, entr�e action <Entier>,
    entr�e pos <Position>) ;

-- L'unit� u r�alise l'action non cibl� action avec comme param�tre param
-- n�cessite u unit� visible
-- n�cessite u dirig�e par le joueur (u.coalition = MOI)
-- n�cessite action est une action basique {WAIT, FIRESTATE, SELFDESTRUCTION,
-- REPEAT, MOVESTATE} ou une action sp�ciale {LAUNCHMINES, STOPBUILDING}
proc�dure r�aliserActionNonCibl�e (entr�e u <Unit�>, entr�e action <Entier>,
    entr�e param <R�el>) ;

-------------------------------
-- Op�rations additionnelles --
-------------------------------

-- Retourne un nombre al�atoire compris entre 0.0 et limite
fonction hasard (entr�e limite <R�el>) retourne <R�el> ;

-- Effectue une pause de t milisecondes
proc�dure d�lai (entr�e t <Entier>) ;

