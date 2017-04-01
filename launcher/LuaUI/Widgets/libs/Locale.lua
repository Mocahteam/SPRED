LAUNCHER_TITLE = ""
LAUNCHER_HELP = ""
LAUNCHER_QUIT = ""
LAUNCHER_ERROR = ""

function GetLauncherStrings(lang)
	if lang == "fr" then
		LAUNCHER_TITLE = "Choisissez votre jeu de base"
		LAUNCHER_HELP = "Ce jeu sera la base de votre �diteur : il d�finit les unit�s que vous allez pouvoir utiliser pour cr�er vos missions. Ce jeu sera �galement requis pour jouer les missions cr��es. Lorsque vous aurez choisi un jeu, une nouvelle archive sera cr��e pour vous permettre d'�diter le jeu. Spring red�marrera automatiquement en utilisant cette nouvelle archive. Par la suite, vous pourrez lancer l'�diteur du jeu via le launcher de Spring sans r�aliser cette �tape."
		LAUNCHER_QUIT = "Quitter"
		LAUNCHER_ERROR = "Votre version de Spring ne permet pas d'effectuer cette op�ration."
		LAUNCHER_BUILD_ERROR = "ERREUR !!! La cr�ation de l'�diteur a �chou�."
	else
		LAUNCHER_TITLE = "Choose the master game"
		LAUNCHER_HELP = "This game will be the base of the editor: it will define units and their behaviour, and will be required to play the created missions. Once a game has been chosen, a new archive corresponding to the editor for the chosen mod will be created. Spring will restart using this new archive. Afterwards, you will be able to launch the editor using the archive directly from the launcher."
		LAUNCHER_QUIT = "Quit"
		LAUNCHER_ERROR = "Your Spring version does not allow this operation."
		LAUNCHER_BUILD_ERROR = "ERROR!!! Editor creation fail."
	end
end
