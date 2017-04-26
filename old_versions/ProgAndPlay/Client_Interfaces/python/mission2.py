from constantList_KP4_1 import *
from pp import *

# Ouverture de la connexion avec le jeu
PP_Open()
# Récupération de la première unité
u = PP_GetUnitAt(MY_COALITION, 0)
# Récupération de la position de l'unité
pDepart = PP_Unit_GetPosition(u)
# Calcul de la coordonnée d'arrivée
pArrivee = PP_Pos()
pArrivee.x = pDepart.x - 927
pArrivee.y = pDepart.y + 513
# Ordonner à mon unité courante de se déplacer à la position calculée
PP_Unit_ActionOnPosition(u, MOVE, pArrivee)
# Fermer la connexion avec le jeu
PP_Close()
