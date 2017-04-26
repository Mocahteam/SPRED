from constantList_KP4_1 import *
from pp import *

# Ouverture de la connexion avec le jeu
PP_Open()
i = 0
enemy = PP_GetUnitAt(ENEMY_COALITION,0)
while i < PP_GetNumUnits(MY_COALITION):
    u = PP_GetUnitAt(MY_COALITION, i)
    PP_Unit_ActionOnUnit(u, ATTACK, enemy)
    i += 1
# Fermer la connexion avec le jeu
PP_Close()
