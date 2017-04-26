from constantList_KP4_1 import *
from pp import *

# Définition de la cible
pos = PP_Pos(256.0, 811.0)
# Ouverture de la connexion avec le jeu
PP_Open()
# Parcourir toutes les unités
i = 0
while i < PP_GetNumUnits(MY_COALITION):
    # Récupérer l'unité courante
    u = PP_GetUnitAt(MY_COALITION, i)
    # Donner l'ordre de déplacement
    if PP_Unit_GetType(u) == ASSEMBLER:
        PP_Unit_ActionOnPosition(u, MOVE, pos)
    i += 1
# Fermer la connexion avec le jeu
PP_Close()
