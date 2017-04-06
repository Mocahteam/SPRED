LAUNCHER_TITLE = ""
LAUNCHER_HELP = ""
LAUNCHER_QUIT = ""
LAUNCHER_ERROR = ""

function GetLauncherStrings(lang)
	if lang == "fr" then
		LAUNCHER_TITLE = "Choisissez votre jeu de base"
		LAUNCHER_HELP = "Ce jeu sera la base de votre �diteur : il d�finit les unit�s que vous allez pouvoir utiliser pour cr�er vos missions. Ce jeu sera �galement requis pour jouer les missions cr��es. Lorsque vous aurez choisi un jeu, une nouvelle archive sera cr��e pour vous permettre d'�diter le jeu. Spring red�marrera automatiquement en utilisant cette nouvelle archive. Par la suite, vous pourrez lancer l'�diteur du jeu via le launcher de Spring sans r�aliser cette �tape."
		LAUNCHER_QUIT = "Quitter"
		LAUNCHER_ERROR = "L'�diteur ne fonctione pas sur la version de Spring que vous utilisez.\nMerci d'utiliser la version 0.82.5.1 pour Prog&Play ou une version 98+."
	else
		LAUNCHER_TITLE = "Choose the master game"
		LAUNCHER_HELP = "This game will be the base of the editor: it will define units and their behaviour, and will be required to play the created missions. Once a game has been chosen, a new archive corresponding to the editor for the chosen mod will be created. Spring will restart using this new archive. Afterwards, you will be able to launch the editor using the archive directly from the launcher."
		LAUNCHER_QUIT = "Quit"
		LAUNCHER_ERROR = "The editor does not work on the version of Spring you are using.\nPlease use the tweaked 0.82.5.1 or a 98+ version."
	end
end
