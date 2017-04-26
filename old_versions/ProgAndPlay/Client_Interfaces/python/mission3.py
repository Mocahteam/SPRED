from constantList_KP4_1 import *
from pp import *

# Ouverture de la connexion avec le jeu
PP_Open()
# Récupérer la première unité
u = PP_GetUnitAt(MY_COALITION, 0)
# Attendre l'arrivée de l'ennemi
while PP_GetNumUnits(ENEMY_COALITION) == 0:
    print("En attente de l'arrivée de l'ennemi")
# Récupérer l'unité ennemie
e = PP_GetUnitAt(ENEMY_COALITION, 0)
# Ordonner à mon unité courante d'attaquer l'ennemi
PP_Unit_ActionOnUnit(u, ATTACK, e)
# Fermer la connexion avec le jeu
PP_Close()
