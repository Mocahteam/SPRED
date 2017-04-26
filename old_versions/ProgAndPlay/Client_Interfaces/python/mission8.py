from constantList_KP4_1 import *
from pp import *

NBBYTES = 3

def trierUnites (raliementBytes, raliementBits):
    """ PP_Pos * PP_Pos ->
    Trie l'ensemble des unités du joueur en déplaçant tous les bit au même
    endroit et tout les bytes au même endroit."""

    i = 0
    while i < PP_GetNumUnits(MY_COALITION):
        unite = PP_GetUnitAt(MY_COALITION, i)
        if PP_Unit_GetType(unite) != BYTE:
            PP_Unit_ActionOnPosition(unite, MOVE, raliementBits)
        else:
            PP_Unit_ActionOnPosition(unite, MOVE, raliementBytes)
        i+= 1

def attendreDepart ():
    """ ->
    Attendre qu'au moin une unité soit en activité."""

    fini = False
    while not fini:
        i = 0
        while i < PP_GetNumUnits(MY_COALITION) and not fini:
            u = PP_GetUnitAt(MY_COALITION, i)
            pdgCmds = PP_Unit_GetPendingCommands(u)
            if len(pdgCmds) > 0:
                fini = True
            i += 1

def attendreRassemblement ():
    """ ->
    Attendre la fin du rassemblement."""

    fini = False
    while not fini:
        fini = True
        i = 0
        while i < PP_GetNumUnits(MY_COALITION) and fini:
            u = PP_GetUnitAt(MY_COALITION, i)
            pdgCmds = PP_Unit_GetPendingCommands(u)
            if len(pdgCmds) > 0:
                fini = False
            i += 1

def lancerAttaque (pos):
    """ PP_Pos ->
    Lance l'attaque sur la position pos."""

    byteList = []
    # Récupérer le premier assembleur et les octets
    i = 0
    cpt = 0
    assembleurNonTrouve = True
    while i < PP_GetNumUnits(MY_COALITION):
        unite = PP_GetUnitAt(MY_COALITION, i)
        if assembleurNonTrouve and PP_Unit_GetType(unite) == ASSEMBLER:
            assembleurNonTrouve = False
            assembleur = unite
        if cpt < NBBYTES and PP_Unit_GetType(unite) == BYTE:
            byteList.append(unite)
            cpt += 1
        i += 1
    # Lancer la marche
    i = 0
    while i < PP_GetNumUnits(MY_COALITION):
        unite = PP_GetUnitAt(MY_COALITION, i)
        if PP_Unit_GetType(unite) == BYTE:
            PP_Unit_ActionOnPosition(unite, FIGHT, pos)
        else:
            PP_Unit_ActionOnUnit(unite, GUARD, byteList[0])
        i += 1
	
    # Avancer jusqu'à trouver l'ennemie
    while PP_GetNumUnits (ENEMY_COALITION) == 0:
        print("Avancer jusqu'a trouver l'ennemi")
        
    # Tout lacher (sauf l'assembleur)
    i = 0
    while i < PP_GetNumUnits(MY_COALITION):
        unite = PP_GetUnitAt(MY_COALITION, i)
        if PP_Unit_GetType(unite) != ASSEMBLER:
            PP_Unit_ActionOnPosition(unite, FIGHT, pos)
        i += 1
	
    # Réparer les bytes endommagés
    urgencePrecedente = -1;
    assembleurToujoursVivant = PP_Unit_GetType(assembleur) > 0
    while not PP_IsGameOver() and assembleurToujoursVivant:
        # Tester si l'assembleur est toujours vivant
        assembleurToujoursVivant = PP_Unit_GetType(assembleur) > 0
        if assembleurToujoursVivant:
            # Supprimer les octets détruits
            i = 0
            while i < cpt:
                if PP_Unit_GetType(byteList[i]) == -1:
                    # Supprimer cet octet
                    j = i
                    while j+1 < cpt:
                        byteList[j] = byteList[j+1]
                        j += 1
                    cpt -= 1
                else:
                    i += 1
            # Recherche de l'octet le plus endomagé
            i = 0
            urgent = -1
            while i < cpt:
                # Vérifier si l'octet courant est plus prioritaire que la précédente urgence
                if urgent == -1:
                    urgent = i
                if i != urgent:
                    if PP_Unit_GetHealth(byteList[i]) < PP_Unit_GetHealth(byteList[urgent]):
                        urgent = i
                i += 1
            if urgent != -1:
                asmPdgCmds = PP_Unit_GetPendingCommands(assembleur)
                if urgent != urgencePrecedente or len(asmPdgCmds) == 0:
                    PP_Unit_ActionOnUnit(assembleur, REPAIR, byteList[urgent])
                    urgencePrecedente = urgent
                    
# Programme principal
attaque = PP_Pos(1792.0, 256.0)
bytesPos = PP_Pos(478.0, 255.0)
bitsPos = PP_Pos(255.0, 255.0)

# Ouvrir la connexion avec le jeu
PP_Open()

trierUnites(bytesPos, bitsPos)

attendreDepart ()

attendreRassemblement ()

lancerAttaque (attaque)

# Fermer la connexion avec le jeu
PP_Close()
