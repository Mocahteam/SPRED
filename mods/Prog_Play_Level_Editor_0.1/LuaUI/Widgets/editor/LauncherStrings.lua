LAUNCHER_TITLE = ""
LAUNCHER_NEW_MISSION = ""
LAUNCHER_EDIT_MISSION = ""
LAUNCHER_EDIT_SCENARIO = ""

function GetLauncherStrings(lang)
	if lang == "fr" then
		LAUNCHER_TITLE = "Editeur de niveaux Prog & Play"
		LAUNCHER_NEW_MISSION = "Nouvelle mission"
		LAUNCHER_EDIT_MISSION = "Modifier une mission existante"
		LAUNCHER_EDIT_SCENARIO = "Modifier la scénarisation"
	else
		LAUNCHER_TITLE = "Prog & Play Level Editor"
		LAUNCHER_NEW_MISSION = "New mission"
		LAUNCHER_EDIT_MISSION = "Edit existing mission"
		LAUNCHER_EDIT_SCENARIO = "Edit scenario"
	end
end