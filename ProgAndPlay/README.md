Historique des changements
==========================

PP
--

* PP_Client :

	* Modification des fonctions pour l'ajout de traces spécifiques lorsque des erreurs sont retournées
	* Réecriture de PP_Unit_GetPendingCommands
	* Ajout d'un booléen 'gamePaused' dans la mémoire partagée : utilisé pour éviter de remplir la queue des traces lorsque le jeu est en pause
	* Ajout d'un entier 'timestamp' dans la mémoire partagée qui permet de récupérer la valeur actuelle du temps dans le référentiel du moteur
	
* PP_Supplier :

	* Ajout de fonctions pour la mise à jour des informations dans la mémoire partagée
	
SPRING
------

* ProgAndPlay.cpp :

	* Ajout d'un booléen 'tracePlayer' dans la mémoire partagée : utilisé pour activer / désactiver les traces spécifiques aux missions
	* Récupération des traces depuis la mémoire partagée et mission_ended.conf + log de ces traces dans le fichier mission spécifique
	
* Game.cpp :

	* Appel à la méthode 'GamePaused' de CProgAndPlay lorsque la touche 'Pause' est pressée. Permet de mettre à jour l'information correspondante dans la mémoire partagée
	* Appel à la méthode 'TracePlayer' de CProgAndPlay lorsque la partie démarre. Active le traçage des appels au client si ceux-ci doivent l'être
	* Mise à jour de PP_modGameTime et appel à la méthode 'UpdateTimestamp'
	
* GlobalUnsynced :

	* Ajout d'une variable PP_modGameTime
	
* Spring_dev\spring_0.82.5.1\build\rts\builds\default\cmake_install.cmake :

	* Ajout : copie du fichier params.json dans le dossier d'installation de l'exécutable spring

LUA
---

* Fichiers Missions :

	* Ajout d'une clé "tracesFilename" dans MODOPTIONS
	
* Widget pp_mission_traces.lua :

	* Création du répertoire des traces dans le répertoire contenant l'executable de Spring s'il n'existe pas
	* Ecriture des traces dans le fichier 'traces/meta.log'
	* Création du fichier 'mission_ended.conf'
	
* Widgets pp_mission_gui.lua (KP_Campaign_2.3) et pp_spring_direct_launch (ByteBattle_2) :

	* Appels aux fonctions du widget de traces