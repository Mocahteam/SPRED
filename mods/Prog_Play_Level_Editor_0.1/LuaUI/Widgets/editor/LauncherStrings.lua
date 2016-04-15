LAUNCHER_TITLE = ""
LAUNCHER_QUIT = ""
LAUNCHER_NEW_MISSION = ""
LAUNCHER_NEW_TITLE = ""
LAUNCHER_NEW_NO_MAP_FOUND = ""
LAUNCHER_EDIT_MISSION = ""
LAUNCHER_EDIT_TITLE = ""
LAUNCHER_EDIT_NO_LEVEL_FOUND = ""
LAUNCHER_EDIT_SCENARIO = ""

function GetLauncherStrings(lang)
	if lang == "fr" then
		LAUNCHER_TITLE = "Editeur de niveaux Prog & Play"
		LAUNCHER_QUIT = "Quitter"
		LAUNCHER_NEW_MISSION = "Nouvelle mission"
		LAUNCHER_NEW_TITLE = "Choisissez une carte"
		LAUNCHER_NEW_NO_MAP_FOUND = "Aucune map trouvée dans le répertoire \"maps/\""
		LAUNCHER_EDIT_MISSION = "Modifier une mission existante"
		LAUNCHER_EDIT_TITLE = "Choisissez une mission"
		LAUNCHER_EDIT_NO_LEVEL_FOUND = "Aucune mission trouvée dans le répertoire \"CustomLevels/\""
		LAUNCHER_EDIT_SCENARIO = "Modifier la scénarisation"
	else
		LAUNCHER_TITLE = "Prog & Play Level Editor"
		LAUNCHER_QUIT = "Quit"
		LAUNCHER_NEW_MISSION = "New mission"
		LAUNCHER_NEW_TITLE = "Choose a map"
		LAUNCHER_NEW_NO_MAP_FOUND = "No map found in the \"maps/\" directory"
		LAUNCHER_EDIT_MISSION = "Edit existing mission"
		LAUNCHER_EDIT_TITLE = "Choose a mission"
		LAUNCHER_EDIT_NO_LEVEL_FOUND = "No mission found in the \"CustomLevels/\" directory"
		LAUNCHER_EDIT_SCENARIO = "Edit scenario"
	end
end