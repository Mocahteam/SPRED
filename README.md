Historique des changements
===========

* PP_Client :

	* Modification des fonctions pour l'ajout de traces spécifiques lorsque des erreurs sont retournées
	* Ajout d'un booléen 'gamePaused' dans la mémoire partagée : utilisé pour éviter de remplir la queue des traces lorsque le jeu est en pause
	
* PP_Supplier :

* ProgAndPlay.cpp :

	* Ajout d'un booléen 'tracePlayer' dans la mémoire partagée : utilisé pour activer / désactiver les traces spécifiques aux appels des fonctions de PP_Client
	* Récupération des traces depuis la mémoire partagée et mission_ended.conf + log de ces traces dans le fichier mission spécifique

* pp_mission_gui.lua :

	* Création du répertoire des traces dans le répertoire contenant l'executable de Spring s'il n'existe pas
	* Ecriture des traces dans le fichier meta.log
	
* Game.cpp :
	* Appel à une méthode de ProgAndPlay.cpp lorsque la touche 'Pause' est pressée

* Fichiers Mission.txt :
	* Ajout d'une clé "tracesFilename" dans MODOPTIONS