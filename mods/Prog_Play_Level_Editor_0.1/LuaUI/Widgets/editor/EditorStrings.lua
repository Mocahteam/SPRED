local lang = Spring.GetModOptions()["language"]

if lang == "fr" then
	EDITOR_FILE = "Fichier"
	EDITOR_FILE_NEW = "Nouveau"
	EDITOR_FILE_NEW_TITLE = "Choisissez une carte"
	EDITOR_FILE_NEW_NO_MAP_FOUND = "Aucune carte n'a �t� trouv�e dans le r�pertoire maps"
	EDITOR_FILE_LOAD = "Ouvrir"
	EDITOR_FILE_LOAD_TITLE = "Charger niveau"
	EDITOR_FILE_LOAD_NO_LEVEL_FOUND = "Aucun niveau n'a �t� trouv� dans le r�pertoire CustomLevels"
	EDITOR_FILE_SAVE = "Enregistrer"
	EDITOR_FILE_SAVE_CONFIRM = "Ecraser le fichier d�j� existant ?"
	EDITOR_FILE_SAVE_CONFIRM_HELP = "(Vous pouvez changer le nom dans les param�tres de la carte)"
	EDITOR_FILE_BACK_TO_MENU_CONFIRM = "Retourner au menu principal ?"
	EDITOR_FILE_BACK_TO_MENU_CONFIRM_HELP = "(Les changements non sauvegard�s seront effac�s)"
	EDITOR_FILE_EXPORT = "Exporter"
	EDITOR_FILE_MENU = "Menu principal"
	EDITOR_UNITS = "Unit�s"
	EDITOR_UNITS_FACTION = "Faction"
	EDITOR_UNITS_UNSTABLE = "Unit�s instables"
	EDITOR_UNITS_TEAM = "Equipe"
	EDITOR_UNITS_LIST = "Liste des Unit�s"
	EDITOR_UNITS_EDIT_ATTRIBUTES = "Attributs"
	EDITOR_UNITS_EDIT_ATTRIBUTES_EDIT = "Modifier les attributs"
	EDITOR_UNITS_EDIT_ATTRIBUTES_HP = "PV"
	EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL = "Soin auto"
	EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_GLOBAL = "Param�tres globaux"
	EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_ENABLED = "Activ�"
	EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_DISABLED = "D�sactiv�"
	EDITOR_UNITS_EDIT_ATTRIBUTES_TEAM = "Equipe"
	EDITOR_UNITS_EDIT_ATTRIBUTES_APPLY = "Appliquer"
	EDITOR_UNITS_GROUPS_DEFAULT_NAME = "Groupe"
	EDITOR_UNITS_GROUPS_SHOW = "Groupes d'unit�s"
	EDITOR_UNITS_GROUPS_LIST = "Liste des groupes"
	EDITOR_UNITS_GROUPS_ADD = "Ajouter un groupe"
	EDITOR_UNITS_GROUPS_ADDTO = "Ajouter � un groupe"
	EDITOR_UNITS_GROUPS_REMOVEFROM = "Supprimer d'un groupe"
	EDITOR_UNITS_GROUPS_NEW = "Nouveau groupe"
	EDITOR_UNITS_GROUPS_NO_GROUP = "Les unit�s s�lectionn�es n'ont aucun groupe en commun."
	EDITOR_UNITS_GROUPS_NO_COMMON_GROUP = "Cette unit� n'appartient � aucun groupe."
	EDITOR_ZONES = "Zones"
	EDITOR_ZONES_SHOW = "Afficher"
	EDITOR_ZONES_HIDE = "Masquer"
	EDITOR_ZONES_DEFAULT_NAME = "Zone"
	EDITOR_ZONES_ATTRIBUTES = "Attributs sp�ciaux"
	EDITOR_ZONES_ATTRIBUTES_ALWAYS_IN_VIEW = "Toujours dans la vue du joueur"
	EDITOR_ZONES_ATTRIBUTES_MARKER = "Afficher un marqueur au centre"
	EDITOR_FORCES = "Forces"
	EDITOR_FORCES_TEAM_DEFAULT_NAME = "Equipe"
	EDITOR_FORCES_TEAMCONFIG = "Configuration des �quipes"
	EDITOR_FORCES_TEAMCONFIG_ENABLED = "Activ�e"
	EDITOR_FORCES_TEAMCONFIG_DISABLED = "D�sactiv�e"
	EDITOR_FORCES_TEAMCONFIG_CONTROL = "Controll�e par"
	EDITOR_FORCES_TEAMCONFIG_CONTROL_PLAYER = "Joueur"
	EDITOR_FORCES_TEAMCONFIG_CONTROL_COMPUTER = "Ordinateur"
	EDITOR_FORCES_TEAMCONFIG_COLOR = "Couleur en jeu"
	EDITOR_FORCES_ALLYTEAMS = "Alliances"
	EDITOR_FORCES_ALLYTEAMS_LIST = "Liste des �quipes"
	EDITOR_TRIGGERS = "�v�nements"
	EDITOR_TRIGGERS_EVENTS = "�v�nements"
	EDITOR_TRIGGERS_EVENTS_DEFAULT_NAME = "Ev�nement"
	EDITOR_TRIGGERS_EVENTS_NEW = "+ Nouvel Ev�nement"
	EDITOR_TRIGGERS_EVENTS_FILTER = "Filtre"
	EDITOR_TRIGGERS_EVENTS_TYPE = "Type"
	EDITOR_TRIGGERS_EVENTS_GROUP_NOT_FOUND = "Pas de groupe"
	EDITOR_TRIGGERS_EVENTS_ZONE_NOT_FOUND = "Pas de zone"
	EDITOR_TRIGGERS_EVENTS_VARNUM_NOT_FOUND = "Pas de variable num�rique"
	EDITOR_TRIGGERS_EVENTS_VARBOOL_NOT_FOUND = "Pas de variable bool�enne"
	EDITOR_TRIGGERS_EVENTS_CONDITION_NOT_FOUND = "Pas de condition trouv�e"
	EDITOR_TRIGGERS_EVENTS_COMMANDS_NOT_FOUND = "Aucune commande trouv�e"
	EDITOR_TRIGGERS_EVENTS_PICK = "S�lectionner"
	EDITOR_TRIGGERS_EVENTS_PICK_POSITION = "Cliquer sur le sol pour s�lectionner une position"
	EDITOR_TRIGGERS_EVENTS_PICK_POSITION_WRONG = "Position invalide"
	EDITOR_TRIGGERS_EVENTS_PICK_UNIT = "Cliquer sur une unit� pour la s�lectionner"
	EDITOR_TRIGGERS_EVENTS_PICK_UNIT_CREATED = "Unit�(s) cr��e(s) par le dernier appel �"
	EDITOR_TRIGGERS_EVENTS_PICK_RANDOM_ZONE = "Position al�atoire � l'int�rieur de"
	EDITOR_TRIGGERS_EVENTS_RANDOM_ZONE = "Al�atoire dans"
	EDITOR_TRIGGERS_EVENTS_MESSAGE_HINT = "Plusieurs messages peuvent �tre d�finis en les s�parant par ||. Un message al�atoire sera choisi � chaque appel � cette action."
	EDITOR_TRIGGERS_EVENTS_TIME_HINT = "Vous pouvez mettre 0 dans ce champ pour une dur�e infinie."
	EDITOR_TRIGGERS_EVENTS_VARIABLE_HINT = "Des variables personnalis�es peuvent �tre d�finies en allant dans le menu accessible depuis le panneau des �v�nements"
	EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_EXACTLY = "Exactement"
	EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_ATLEAST = "Au moins"
	EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_ATMOST = "Au plus"
	EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_ALL = "Tous"
	EDITOR_TRIGGERS_EVENTS_CREATED_GROUP = "Unit�s cr��es par "
	EDITOR_TRIGGERS_EVENTS_CONFIGURE = "Configuration de "
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_EVENT = "Configurer l'�v�nement"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER = "D�clencheur (d�faut : et global)"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CUSTOM = "D�clencheur personnalis�"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_DEFAULT = "D�clencheur par d�faut"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CURRENT = "D�clencheur actuel : "
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_NOT_VALID = "Le d�clencheur personnalis� n'est pas valide."
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_EXAMPLE = "Exemple de d�clencheur personnalis� : ((not cond1) or cond2) and cond3"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_ACTION_SEQUENCE = "S�quence d'ex�cution des actions"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT = "Importation d'une condition ou d'une action"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT_CONDITION = "Importer cette condition"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT_ACTION = "Importer cette action"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_OTHER = "Autres param�tres"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION = "R�p�tition"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_YES = "Oui, toutes les X secondes"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_NO = "Non"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_MESSAGE = "Ev�nement r�p�t� toutes les /X/ secondes."
	EDITOR_TRIGGERS_CONDITIONS = "Conditions"
	EDITOR_TRIGGERS_CONDITIONS_DEFAULT_NAME = "Condition"
	EDITOR_TRIGGERS_CONDITIONS_NEW = "+ Nouvelle Condition"
	EDITOR_TRIGGERS_ACTIONS = "Actions"
	EDITOR_TRIGGERS_ACTIONS_DEFAULT_NAME = "Action"
	EDITOR_TRIGGERS_ACTIONS_NEW = "+ Nouvelle Action"
	EDITOR_TRIGGERS_VARIABLES = "Variables personnalis�es"
	EDITOR_TRIGGERS_VARIABLES_EDIT = "Variables"
	EDITOR_TRIGGERS_VARIABLES_NEW = "+ Nouvelle Variable"
	EDITOR_TRIGGERS_VARIABLES_DEFAULT_NAME = "Variable"
	EDITOR_TRIGGERS_VARIABLES_NAME = "Nom"
	EDITOR_TRIGGERS_VARIABLES_TYPE = "Type"
	EDITOR_TRIGGERS_VARIABLES_TYPE_NUMBER = "Nombre"
	EDITOR_TRIGGERS_VARIABLES_TYPE_BOOLEAN = "Bool�en"
	EDITOR_TRIGGERS_VARIABLES_INITVALUE = "Valeur initiale"
	EDITOR_MAPSETTINGS = "Param�tres de la carte"
	EDITOR_MAPSETTINGS_MAP_NAME = "Nom"
	EDITOR_MAPSETTINGS_MAP_BRIEFING = "Briefing"
	EDITOR_MAPSETTINGS_MAP_BRIEFING_COLOR_HINT = "Astuce : Vous pouvez ajouter des couleurs au texte du briefing en utilisant le code HEX. Ex : /#FF0000#Exemple/ => \255\255\0\0Exemple"
	EDITOR_MAPSETTINGS_CAMERA_AUTO_ENABLED = "Cam�ra automatique activ�e"
	EDITOR_MAPSETTINGS_CAMERA_AUTO_DISABLED = "Cam�ra automatique d�sactiv�e"
	EDITOR_MAPSETTINGS_HEAL_AUTO_ENABLED = "Soin automatique des unit�s activ�"
	EDITOR_MAPSETTINGS_HEAL_AUTO_DISABLED = "Soin automatique des unit�s d�sactiv�"
	EDITOR_MAPSETTINGS_MOUSE_ENABLED = "Souris activ�e"
	EDITOR_MAPSETTINGS_MOUSE_DISABLED = "Souris d�sativ�e"
	EDITOR_MAPSETTINGS_MINIMAP_ENABLED = "Minimap activ�e"
	EDITOR_MAPSETTINGS_MINIMAP_DISABLED = "Minimap d�sativ�e"
	EDITOR_MAPSETTINGS_WIDGETS = "Configurer les widgets"
	EDITOR_OK = "OK"
	EDITOR_YES = "Oui"
	EDITOR_NO = "Non"
	EDITOR_X = "X"
else
	EDITOR_FILE = "File"
	EDITOR_FILE_NEW = "New"
	EDITOR_FILE_NEW_TITLE = "Choose a map"
	EDITOR_FILE_NEW_NO_MAP_FOUND = "No map has been found in the maps directory"
	EDITOR_FILE_LOAD = "Load"
	EDITOR_FILE_LOAD_TITLE = "Load level"
	EDITOR_FILE_LOAD_NO_LEVEL_FOUND = "No level has been found in the CustomLevels directory"
	EDITOR_FILE_SAVE = "Save"
	EDITOR_FILE_SAVE_CONFIRM = "Override existing file?"
	EDITOR_FILE_SAVE_CONFIRM_HELP = "(You can change the name in the map settings)"
	EDITOR_FILE_BACK_TO_MENU_CONFIRM = "Return to main menu?"
	EDITOR_FILE_BACK_TO_MENU_CONFIRM_HELP = "(Unsaved changes will be discarded)"
	EDITOR_FILE_EXPORT = "Export"
	EDITOR_FILE_MENU = "Main Menu"
	EDITOR_UNITS = "Units"
	EDITOR_UNITS_FACTION = "Faction"
	EDITOR_UNITS_UNSTABLE = "Unstable units"
	EDITOR_UNITS_TEAM = "Team"
	EDITOR_UNITS_LIST = "Unit List"
	EDITOR_UNITS_EDIT_ATTRIBUTES = "Attributes"
	EDITOR_UNITS_EDIT_ATTRIBUTES_EDIT = "Edit Attributes"
	EDITOR_UNITS_EDIT_ATTRIBUTES_HP = "HP"
	EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL = "Auto heal"
	EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_GLOBAL = "Use global settings"
	EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_ENABLED = "Enabled"
	EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_DISABLED = "Disabled"
	EDITOR_UNITS_EDIT_ATTRIBUTES_TEAM = "Team"
	EDITOR_UNITS_EDIT_ATTRIBUTES_APPLY = "Apply"
	EDITOR_UNITS_GROUPS_DEFAULT_NAME = "Group"
	EDITOR_UNITS_GROUPS_SHOW = "Show unit groups"
	EDITOR_UNITS_GROUPS_LIST = "Group List"
	EDITOR_UNITS_GROUPS_ADD = "Add Group"
	EDITOR_UNITS_GROUPS_ADDTO = "Add to Group"
	EDITOR_UNITS_GROUPS_REMOVEFROM = "Remove from Group"
	EDITOR_UNITS_GROUPS_NEW = "New Group"
	EDITOR_UNITS_GROUPS_NO_GROUP = "This unit does not belong to any group."
	EDITOR_UNITS_GROUPS_NO_COMMON_GROUP = "This unit does not belong to any group."
	EDITOR_ZONES = "Zones"
	EDITOR_ZONES_SHOW = "Show all"
	EDITOR_ZONES_HIDE = "Hide all"
	EDITOR_ZONES_DEFAULT_NAME = "Zone"
	EDITOR_ZONES_ATTRIBUTES = "Special attributes"
	EDITOR_ZONES_ATTRIBUTES_ALWAYS_IN_VIEW = "Always in player view"
	EDITOR_ZONES_ATTRIBUTES_MARKER = "Display marker in center"
	EDITOR_FORCES = "Forces"
	EDITOR_FORCES_TEAM_DEFAULT_NAME = "Team"
	EDITOR_FORCES_TEAMCONFIG = "Teams Configuration"
	EDITOR_FORCES_TEAMCONFIG_ENABLED = "Enabled"
	EDITOR_FORCES_TEAMCONFIG_DISABLED = "Disabled"
	EDITOR_FORCES_TEAMCONFIG_CONTROL = "Controlled by"
	EDITOR_FORCES_TEAMCONFIG_CONTROL_PLAYER = "Player"
	EDITOR_FORCES_TEAMCONFIG_CONTROL_COMPUTER = "Computer"
	EDITOR_FORCES_TEAMCONFIG_COLOR = "In-game color"
	EDITOR_FORCES_ALLYTEAMS = "Ally Teams"
	EDITOR_FORCES_ALLYTEAMS_LIST = "Team List"
	EDITOR_TRIGGERS = "Events"
	EDITOR_TRIGGERS_EVENTS = "Events"
	EDITOR_TRIGGERS_EVENTS_DEFAULT_NAME = "Event"
	EDITOR_TRIGGERS_EVENTS_NEW = "+ New Event"
	EDITOR_TRIGGERS_EVENTS_FILTER = "Filter"
	EDITOR_TRIGGERS_EVENTS_TYPE = "Type"
	EDITOR_TRIGGERS_EVENTS_GROUP_NOT_FOUND = "No group found"
	EDITOR_TRIGGERS_EVENTS_ZONE_NOT_FOUND = "No zone found"
	EDITOR_TRIGGERS_EVENTS_VARNUM_NOT_FOUND = "No number variable found"
	EDITOR_TRIGGERS_EVENTS_VARBOOL_NOT_FOUND = "No boolean variable found"
	EDITOR_TRIGGERS_EVENTS_CONDITION_NOT_FOUND = "No condition found"
	EDITOR_TRIGGERS_EVENTS_COMMANDS_NOT_FOUND = "No commands found"
	EDITOR_TRIGGERS_EVENTS_PICK = "Pick"
	EDITOR_TRIGGERS_EVENTS_PICK_POSITION = "Click on the ground to pick a position"
	EDITOR_TRIGGERS_EVENTS_PICK_POSITION_WRONG = "Invalid position"
	EDITOR_TRIGGERS_EVENTS_PICK_UNIT = "Click on a unit to pick it"
	EDITOR_TRIGGERS_EVENTS_PICK_UNIT_CREATED = "Unit(s) created by the last call to"
	EDITOR_TRIGGERS_EVENTS_PICK_RANDOM_ZONE = "Random position within"
	EDITOR_TRIGGERS_EVENTS_RANDOM_ZONE = "Random within"
	EDITOR_TRIGGERS_EVENTS_MESSAGE_HINT = "Multiple messages can be defined using || to split them. A random one will be picked each time this action is called."
	EDITOR_TRIGGERS_EVENTS_TIME_HINT = "You can put 0 in this field for an infinite duration."
	EDITOR_TRIGGERS_EVENTS_VARIABLE_HINT = "Variables can be defined by going to the menu available through the event panel"
	EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_EXACTLY = "Exactly"
	EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_ATLEAST = "At least"
	EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_ATMOST = "At most"
	EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_ALL = "All"
	EDITOR_TRIGGERS_EVENTS_CREATED_GROUP = "Units created by "
	EDITOR_TRIGGERS_EVENTS_CONFIGURE = "Configure"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_EVENT = "Configure Event"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER = "Trigger (default: global and)"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CUSTOM = "Use custom trigger"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_DEFAULT = "Use default trigger"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CURRENT = "Current trigger : "
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_NOT_VALID = "The written trigger is not valid. Please check it."
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_EXAMPLE = "Custom trigger example: ((not condition1) or condition2) and condition3"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_ACTION_SEQUENCE = "Action sequence"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT = "Import condition or action from an event"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT_CONDITION = "Import condition"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT_ACTION = "Import action"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_OTHER = "Other parameters"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION = "Repetition"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_YES = "Yes, every X seconds"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_NO = "No"
	EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_MESSAGE = "Event repeated every /X/ seconds."
	EDITOR_TRIGGERS_CONDITIONS = "Conditions"
	EDITOR_TRIGGERS_CONDITIONS_DEFAULT_NAME = "Condition"
	EDITOR_TRIGGERS_CONDITIONS_NEW = "+ New Condition"
	EDITOR_TRIGGERS_ACTIONS = "Actions"
	EDITOR_TRIGGERS_ACTIONS_DEFAULT_NAME = "Action"
	EDITOR_TRIGGERS_ACTIONS_NEW = "+ New Action"
	EDITOR_TRIGGERS_VARIABLES = "Custom Variables"
	EDITOR_TRIGGERS_VARIABLES_EDIT = "Edit Variables"
	EDITOR_TRIGGERS_VARIABLES_NEW = "+ New Variable"
	EDITOR_TRIGGERS_VARIABLES_DEFAULT_NAME = "Variable"
	EDITOR_TRIGGERS_VARIABLES_NAME = "Name"
	EDITOR_TRIGGERS_VARIABLES_TYPE = "Type"
	EDITOR_TRIGGERS_VARIABLES_TYPE_NUMBER = "Number"
	EDITOR_TRIGGERS_VARIABLES_TYPE_BOOLEAN = "Boolean"
	EDITOR_TRIGGERS_VARIABLES_INITVALUE = "Initial value"
	EDITOR_MAPSETTINGS = "Map Settings"
	EDITOR_MAPSETTINGS_MAP_NAME = "Name"
	EDITOR_MAPSETTINGS_MAP_BRIEFING = "Briefing"
	EDITOR_MAPSETTINGS_MAP_BRIEFING_COLOR_HINT = "Hint : You can add colors to the briefing using HEX code. Ex: /#FF0000#Example/ => \255\255\0\0Example"
	EDITOR_MAPSETTINGS_CAMERA_AUTO_ENABLED = "Automatic camera enabled"
	EDITOR_MAPSETTINGS_CAMERA_AUTO_DISABLED = "Automatic camera disabled"
	EDITOR_MAPSETTINGS_HEAL_AUTO_ENABLED = "Unit auto heal enabled"
	EDITOR_MAPSETTINGS_HEAL_AUTO_DISABLED = "Unit auto heal disabled"
	EDITOR_MAPSETTINGS_MOUSE_ENABLED = "Mouse enabled"
	EDITOR_MAPSETTINGS_MOUSE_DISABLED = "Mouse disabled"
	EDITOR_MAPSETTINGS_MINIMAP_ENABLED = "Minimap enabled"
	EDITOR_MAPSETTINGS_MINIMAP_DISABLED = "Minimap disabled"
	EDITOR_MAPSETTINGS_WIDGETS = "Configure widgets"
	EDITOR_OK = "OK"
	EDITOR_YES = "Yes"
	EDITOR_NO = "No"
	EDITOR_X = "X"
end