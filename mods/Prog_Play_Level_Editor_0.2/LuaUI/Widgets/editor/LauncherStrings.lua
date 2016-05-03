LAUNCHER_TITLE = ""
LAUNCHER_QUIT = ""
LAUNCHER_NEW_MISSION = ""
LAUNCHER_NEW_TITLE = ""
LAUNCHER_NEW_NO_MAP_FOUND = ""
LAUNCHER_EDIT_MISSION = ""
LAUNCHER_EDIT_TITLE = ""
LAUNCHER_EDIT_NO_LEVEL_FOUND = ""
LAUNCHER_SCENARIO = ""
LAUNCHER_SCENARIO_TITLE = ""
LAUNCHER_SCENARIO_EXPORT = ""
LAUNCHER_SCENARIO_IMPORT = ""
LAUNCHER_SCENARIO_IMPORT_SCENARIO_NOT_FOUND = ""
LAUNCHER_SCENARIO_BEGIN = ""
LAUNCHER_SCENARIO_END = ""
LAUNCHER_SCENARIO_NAME = ""
LAUNCHER_SCENARIO_NAME_DEFAULT = ""
LAUNCHER_SCENARIO_DESCRIPTION = ""
LAUNCHER_SCENARIO_DESCRIPTION_DEFAULT = ""
LAUNCHER_SCENARIO_RESET = ""
LAUNCHER_X = ""

function GetLauncherStrings(lang)
	if lang == "fr" then
		LAUNCHER_TITLE = "Editeur de niveaux Prog & Play"
		LAUNCHER_QUIT = "Quitter"
		LAUNCHER_NEW_MISSION = "Nouvelle mission"
		LAUNCHER_NEW_TITLE = "Choisissez une carte"
		LAUNCHER_NEW_NO_MAP_FOUND = "Aucune map trouv�e dans le r�pertoire \"maps/\""
		LAUNCHER_EDIT_MISSION = "Modifier une mission existante"
		LAUNCHER_EDIT_TITLE = "Choisissez une mission"
		LAUNCHER_EDIT_NO_LEVEL_FOUND = "Aucune mission trouv�e dans le r�pertoire \"CustomLevels/\""
		LAUNCHER_SCENARIO = "Modifier la sc�narisation"
		LAUNCHER_SCENARIO_TITLE = "Editeur de sc�nario"
		LAUNCHER_SCENARIO_EXPORT = "Exporter le sc�nario"
		LAUNCHER_SCENARIO_IMPORT = "Importer un sc�nario"
		LAUNCHER_SCENARIO_IMPORT_SCENARIO_NOT_FOUND = "Aucun sc�nario trouv� dans le r�pertoire \"CustomLevels/\""
		LAUNCHER_SCENARIO_BEGIN = "D�but"
		LAUNCHER_SCENARIO_END = "Fin"
		LAUNCHER_SCENARIO_NAME = "Nom"
		LAUNCHER_SCENARIO_NAME_DEFAULT = "Scenario"
		LAUNCHER_SCENARIO_DESCRIPTION = "Description"
		LAUNCHER_SCENARIO_DESCRIPTION_DEFAULT = "Scenario pour le jeu Prog&Play"
		LAUNCHER_SCENARIO_RESET = "R�initialiser"
		LAUNCHER_X = "X"
	else
		LAUNCHER_TITLE = "Prog & Play Level Editor"
		LAUNCHER_QUIT = "Quit"
		LAUNCHER_NEW_MISSION = "New mission"
		LAUNCHER_NEW_TITLE = "Choose a map"
		LAUNCHER_NEW_NO_MAP_FOUND = "No map found in the \"maps/\" directory"
		LAUNCHER_EDIT_MISSION = "Edit existing mission"
		LAUNCHER_EDIT_TITLE = "Choose a mission"
		LAUNCHER_EDIT_NO_LEVEL_FOUND = "No mission found in the \"CustomLevels/\" directory"
		LAUNCHER_SCENARIO_IMPORT_SCENARIO_NOT_FOUND = "No scenario found in the \"CustomLevels/\" directory"
		LAUNCHER_SCENARIO = "Edit scenario"
		LAUNCHER_SCENARIO_TITLE = "Scenario Editor"
		LAUNCHER_SCENARIO_EXPORT = "Export scenario"
		LAUNCHER_SCENARIO_IMPORT = "Import scenario"
		LAUNCHER_SCENARIO_BEGIN = "Begin"
		LAUNCHER_SCENARIO_END = "End"
		LAUNCHER_SCENARIO_NAME = "Name"
		LAUNCHER_SCENARIO_NAME_DEFAULT = "Scenario"
		LAUNCHER_SCENARIO_DESCRIPTION = "Description"
		LAUNCHER_SCENARIO_DESCRIPTION_DEFAULT = "Scenario for the game Prog&Play"
		LAUNCHER_SCENARIO_RESET = "Reset"
		LAUNCHER_X = "X"
	end
end