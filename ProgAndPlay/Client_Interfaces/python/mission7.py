from constantList_KP4_1 import *
from pp import *

# Ouverture de la connexion avec le jeu
PP_Open()
# Recherche de l'assembleur
i = 0
u = PP_GetUnitAt(MY_COALITION, i)
while i < PP_GetNumUnits(MY_COALITION) and PP_Unit_GetType(u) != ASSEMBLER:
    # Passer à l'unité suivante
    i += 1
    u = PP_GetUnitAt(MY_COALITION, i)
    
if PP_Unit_GetType(u) == ASSEMBLER:
    assembleur = u
    # Réparation des unités
    i = 0
    while i < PP_GetNumUnits(MY_COALITION):
        u = PP_GetUnitAt(MY_COALITION, i)
        if PP_Unit_GetHealth(u) < PP_Unit_GetMaxHealth(u):
            PP_Unit_ActionOnUnit(assembleur, REPAIR, u)
            while PP_Unit_GetHealth(u) < PP_Unit_GetMaxHealth(u):
                # Afficher la santée courante
                print("Sante de l'unite", u, ":", PP_Unit_GetHealth(u), "/", PP_Unit_GetMaxHealth(u))
        # Passer à l'unité suivante
        i += 1
# Fermer la connexion avec le jeu
PP_Close()
