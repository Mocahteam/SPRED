# Introduction

Cette documentation vise deux objectifs : Décrire le fonctionnement de Prog&Play et les travaux de développement informatique qui ont lieu de la période septembre 2015 juin 2016. Le but est de faciliter la reprise du projet.

# Généralités

Cette partie explique succinctement le cadre dans lequel se situe le jeu sérieux Prog&Play. Cette courte introduction est réservée aux néophytes du projet. 

## Spring

Spring est le moteur de jeu sur lequel est construit Kernel Panic, jeu sur lequel est construit Prog&Play. Premier paragraphe de [sa page Wikipedia francophone](https://fr.wikipedia.org/wiki/Spring_(jeu_vid%C3%A9o)) :

Le moteur a été développé pour porter le jeu Total Annihilation avec un rendu 3D, il a ensuite permis le développement d'une dizaine d'autres jeux, dont Kernel Panic. 

## Kernel Panic

Spring est codé en C++ et en LUA, la partie C++ concerne le coeur de Spring, la partie LUA concerne la partie interface avec l'utilisateur et le développement des IAs ou des missions. Kernel Panic, [comme son nom le suggère](https://en.wikipedia.org/wiki/Kernel_panic), est basé sur l'univers informatique. Les unités manipulées représentent des bits, octets, etc. Le jeu a plusieurs modes permettant aux joueurs de s'affronter (éventuellement en ligne) ainsi qu'un mode "campagne". De plus amples informations sont disponibles [en ligne](https://springrts.com/wiki/Kernel_Panic). 

## Prog&Play 

La page [http://www.irit.fr/ProgAndPlay/](http://www.irit.fr/ProgAndPlay/) détaille l'ensemble des informations sur Prog&Play et présente [un guide d'installation](http://www.irit.fr/ProgAndPlay/progAndPlay_Installation.php) et un [un guide d'utilisation](http://www.irit.fr/ProgAndPlay/progAndPlay_Utilisation.php). Le jeu consiste en une série de missions dont l'objectif ne peut être atteint qu'en écrivant un script donnant un comportement aux unités dont dispose le joueur.

![À gauche, un script python donnant un comportement d'attaque à l'unité du bas pour sauver l'unité du milieu. Lancer le script permet donc de réussir la mission](./images/capture1.png)  

Prog&Play ne représente pas unique mode de jeu, mais les sous-modes de jeux de kernel panic  demandant au joueur de programmer les actions de sa faction. Actuellement il recouvre deux modes de jeu : un mode missions (**KP campaign**) et le mode combat (**Byte Battle**). Les travaux présentés dans ce document portent sur le mode **KP campaign**. Le point commun entre ces deux modes est que le joueur utilise **l'API Prog&Play** pour commander ses unités. L'API prend la forme d'un fichier dll communiquant directement avec Spring. Ce choix de conception a une implication importante : un large éventail de langages est rendu disponible au joueur (C, Scratch, Ada, Python, Java, OCaml). Les programmes générés communiquent directement avec Spring par le biais de cette bibliothèque jouant un rôle d'interface. L'éditeur de code n'est pas embarqué dans le projet, et peut donc être choisi par l'enseignant. En ce qui concerne les travaux de développement sur le projet, la programmation de modes de jeu dans Spring peut donc être réalisée sans considérations liées au langage qu'utilisera le joueur. 

# Fichiers et archives lus par Spring 

## Lien entre Spring et les différents modes de jeu 

[image]: ./images/capture2.png  "Spring Home" 
![Page d'accueil de Spring \label{1}][image]

Lorsqu'un utilisateur exécute spring.exe, il accède à une interface (cf figure\ref{1}) permettant de choisir son jeu. Lorsque le joueur clique sur *tester le jeu*, les fichiers liés à ce mode sont ouverts. Ces fichiers sont récupérés dans les archives du sous-dossier **mods** dans le dossier racine de Spring. L'extension de ces fichiers est *sdz* ou *sd7*. Pour tester des modifications sur un mode de jeu, il est alors nécessaire de compresser l'archive contenant les fichiers sources. Pour éviter la tache rébarbative de compression, elle est automatisée par le fichier *make_mod.bat* dans le dossier mods. Il lance la compression du sous-dossier correspondant au mod et lance spring une fois la compression réalisée. Cette archive contient des fichiers de configuration et du code source **LUA**.

## fichiers de configuration

Spring peut être lancé directement en lui donnant un fichier de configuration décrivant les informations. Ce fichier de configuration est utilisé dans Prog&Play pour décrire les missions. Si *Mission1.txt* est toujours à la racine du dossier, il est possible de le charger par : 
```Shell
C:\Users\Bruno\ProgPlayLIP6\spring-0.82.5.1>Spring Mission1.txt 
```
Une autre possibilité, plus simple, est de glisser-déposer ce fichier de configuration sur l'exécutable. 

Ces fichiers de configuration, que nous appellerons dans la suite *"fichier missions"* sont centraux au fonctionnement de Spring. Lorsque l'utilisateur navigue dans le menu et choisit finalement un mode de jeu, c'est un redémarrage de Spring qui s'exécute en prenant en argument le fichier de configuration sélectionné (ou construit comme nous le verrons plus tard).

## Autopsie d'un fichier Mission

Des informations sur ce fichier sont disponibles sur le [site de Spring](https://springrts.com/wiki/Script.txt). Un exemple détaillé est [disponible sur github](https://github.com/spring/spring/blob/100.0/doc/StartScriptFormat.txt)
Un fichier mission est construit sur la base de plusieurs sections. Présenté ci-dessous le haut du fichier décrivant la mission 3 (accessible depuis le dossier missions qui est un sous-dossier dans le dossier du mode de jeu).  Le haut du fichier est le plus intéressant :  
```ini
[GAME] {
Mapname=Marble_Madness_Map; //with .smf extension
Gametype=Kernel Panic Campaign 2.3; //the primary mod NAME (archive works too, but name is prefered)
StartPosType=3;     // 0 fixed, 1 random, 2 choose in game, 3 choose before game (see StartPosX) 
MyPlayerName=Player; // our ingame-name (needs to match one players Name= field)
[MODOPTIONS]  {
gamemode=3;    // 0 cmdr dead->game continues, 1 cmdr dead->game ends,   fixedallies=0;   // enable in game alliance   hidemenu=1;    // set a value to avoid starting menu   language=en;   // en english, fr franÃ§ais   missionname=Mission3; // mission name used to define script file and launcher file   scenario=default;  // default: use campaign.lua scenario, noScenario: no scenario are used         // [appliqScenarioTitle]: the title of the appliq scenario to use  }
[...]
```
Il permet d'indiquer la carte et le mode à charger. Si StartPosType prend la valeur 3, il faut indiquer les coordonnées des bases de chaque équipe (cf exemples mis en liens). La section **MODOPTIONS** permet de fournir des informations qui pourront être récupérées par le script LUA qui décrit permet de jouer les missions :    

* L'option *hidemenu* permet d'éviter que le menu s'affiche lorsque la mission est chargée, pour pouvoir jouer directement (*hidemenu* fonctionne par sa présence seule, quelque soit sa valeur).
* L'option *missionname* donne le nom de la mission. Ce nom est utilisé pour charger le bon fichier json plus détaillé permettant de renseigner toutes les informations relatives au contenu de la mission. Dans la précédente version de Prog&Play, chaque mission était liée à un fichier lua permettant de la jouer. Maintenant un unique programme lua gère toutes les missions de manière générique : *MissionPlayer.lua*. Si l'option *hardcoded=true;* est présent dans *MODOPTIONS*, l'ancien mode de chargement sera utilisé, et le programme cherchera un fichier avec le nom *{missionname}.lua*. Dans le cas contraire *MissionPlayer.lua* sera utilisé et il cherchera à charger un fichier de donnée *{missionname}.json*.

Toutes les informations de cette section sont récupérables sous la forme d'une table, dans n'importe quel contexte par **Spring.GetModOptions()**. Cet accès sera abondamment utilisé dans les différents modules.
D'autres informations, liées à la scénarisation adaptative par Appliq, travaux que nous décrirons plus tard, peuvent être placées (par le biais d'un script) dans cette section, nous y reviendrons.
```ini
[...]
[PLAYER0]  {
Name=Player;  // pure info
Spectator=0;
Team=0;     // the team this player controlls  }

// players in this will share the same units (start with one commander etc.)
[TEAM0]  {
TeamLeader=0;  // player number that is the "leader"                   // if this is an AI controlled team, TeamLeader is the                   // player number of the AI controlling team                   // see AI.Host
AllyTeam=0;
RGBColor=0.500000 0.500000 1.000000;
Side=System; // or Hacker or Network
StartPosX=1792; // Use these in combination with StartPosType=3   StartPosZ=1792; // Use these in combination with StartPosType=3  }

// teams in ally team share los etc and cant break alliance, every team must  // be in exactly one ally team
[ALLYTEAM0]  {
NumAllies=0;
}
```
Le reste du fichier permet de déclarer des informations sur : 

* Un Joueur
* Des IAs
* Une Team
* Une équipe d'alliée

Il permet aussi de lier ces entités entre elles. L'idée étant qu'un joueur ou une IA peut contrôler une team qui peut faire partie d'une team d'alliés.

# Scripts LUA dans Spring

## LUA

Comme indiqué plus haut, les jeux fonctionnant sur Spring sont codés en LUA. LUA est un langage haut niveau, faiblement typé. Il est implémenté en C et est utilisé pour étendre des applications, souvent des jeux. 
Extrait du manuel officiel : 

> *Lua is an embedded language. That means that Lua is not a stand-alone package, but a library that can be linked with other applications so as to incorporate Lua facilities into these applications.*

Source : http://www.lua.org/pil/24.html
Le langage est léger, donc le manuel est rapidement lu : http://www.lua.org/pil/contents.html. L'élément central en LUA est "la table" qui est une forme de tableau associatif très flexible. Il est donc important de savoir les utiliser ([lien](http://www.lua.org/pil/2.5.html))

> *Tables in Lua are not a data structure; they are the data structure*

Source : http://www.lua.org/pil/11.html 

## fichiers LUA dans Spring

L'ensemble des informations que nous développons ici est détaillé sur le site de Spring  (https://springrts.com/wiki/Lua_Scripting). Cette page présente des liens vers les pages d'intérêt pour la programmation en LUA dans le contexte de Spring. Les pages les plus pertinentes pour Prog&Play sont :

* Les deux tutoriels :
	* Commencer en LUA dans Spring https://springrts.com/wiki/Lua_Beginners_FAQ, **sa lecture est fondamentale** 
	* Le tutoriel de création de widgets https://springrts.com/wiki/Lua:Tutorial_GettingStarted
	
* Les différentes opérations de lecture ou de modifications de l'état du jeu :
	* côté serveur (code synchronisé)
		- https://springrts.com/wiki/Lua_SyncedCtrl
		- https://springrts.com/wiki/Lua_SyncedRead
	* côté client (code non synchronisé)
		- https://springrts.com/wiki/Lua_UnsyncedCtrl
		- https://springrts.com/wiki/Lua_UnsyncedRead
* Pour les fonctions concernant les unités, comme *Spring.GiveOrderToUnit* (dans Lua_SyncedCtrl) les constantes définies à https://springrts.com/wiki/Lua_CMDs#Commands sont utiles.

### Spring en tant que contexte

Nous l'avons dit, le code *Lua* est embarqué dans Spring. Certaines fonctions usuelles doivent être remplacées par leurs homologues valides dans le contexte de Spring. Par exemple : 

* *print(ma_variable)* doit être remplacé par *Spring.Echo(ma_variable)*, le contenu sera affiché dans le fichier *infolog.txt* à la racine du dossier (le dossier contenant *spring.exe*)
* Les fichiers et scripts sont chargés par des fonctions comme *VFS.Include, VFS.LoadFile, VFS.FileExists* (cf https://springrts.com/wiki/Lua_VFS) 

Conformément à la logique de LUA qui est d'étendre les fonctionnalités d'une application C, nous avons accès à une API riche pour lire et manipuler l'état du jeu. Une large quantité de fonctions commençant par **Spring.uneFonction(params)** sont utilisables (décrites dans les liens donnés précédemment).

### code synchronisé et non synchronisé, gadgets et widgets, Lua_UI et Lua_rules

Dans le document dont nous avons conseillé la lecture (https://springrts.com/wiki/Lua_Beginners_FAQ),  ces deux passages sont importants : 

___
#### What is the difference between unsynced and synced lua code?

Synced code is code that runs, identically and at the same time, on every connected client. In practice, this means code which controls the game state. Unsynced code is code that will run differently (or maybe not at all) on each connected client. Typically, this means the user interface.
For example, lua code to make units explode if they fell down a cliff would need to be synced. But, code that warned a player when one of their own units was getting near a cliff edge, would need to be unsynced.

#### What is the difference between LuaUI, LuaRules, widgets and gadgets?

Spring allows various Lua States, each with differing functionality. Inside each Lua state, developers can write addons, which are self-contained pieces of code. There is:
* LuaUI: Used for unsynced GUI related code. Addons in here are often called widgets. Clients can (if the game permits it) control which widgets are running. Widgets contain only unsynced code. They can be bundled inside the game, or loaded from the users "Spring/LuaUI/Wigets" directory.
* LuaRules: Addons in here are often called gadgets. Clients cannot choose which gadgets run. Gadgets can include both synced and unsynced code, and must be bundled inside the game.

___
La différentiation entre code synchronisé et code non synchronisé est fondamentale et pose des difficultés dans le développement. Il est souvent nécessaire de communiquer entre code synchronisé et code non synchronisé (infos disponibles ici : https://springrts.com/wiki/LuaTutorials::InterCommunications) 

Les widgets et les gadgets agissent comme des plug-ins qu'on nomme *addon*. Ils s'intègrent à Spring en implémentant des fonctions dans la liste détaillée ici : https://springrts.com/wiki/Lua:Callins . Ces fonctions sont appelées par Spring, ils peuvent être vus comme des crochets (hooks) placés dans Spring. Tout addon doit implémenter *Initialize()* qui est appelé lorsque le plug-in est chargé et *Shutdown()* qui est appelé lorsque l'addon ou le jeu est fermé. 

[ImageF11]: ./images/capture4.png  "F11" 
![écran d'activation ou de désactivation de widget obtenu par la touche F11 en cours de mission \label{F11}][ImageF11]

Dans le dossier du mode de jeu, on trouve donc notamment :

* Un dossier LuaUI. Il contient donc des *widgets*. Le code présent ici est non synchronisé (en effet UI = UserInterface). Les widgets peuvent être désactivés par l'utilisateur (touche F11 en cours de jeu, cf figure \ref{F11}).
* Un dossier LuaRules. Il contient donc des *gadgets*. Le code présent peut être synchronisé ou non synchronisé. Un seul fichier est présent ici : *mission_runner.lua*. Nous détaillerons ce fichier plus loin.

Un tableau récapitulatif liant les pages du wiki en ligne avec leurs contextes d'exécution est disponible à : https://springrts.com/wiki/Category:Lua .

### Vue résumée des fichiers LUA composant Prog&Play

Nous l'avons déjà précisé, Prog&Play est construit "au-dessus" de KP campaign. Donc lorsque le mode **KP campaign** est chargé, les widgets et les gadgets de KP campaign sont chargés aussi. Cette dépendance est visible dans le fichier **Modinfo.lua** à la racine du dossier. Ce fichier est notamment utilisé par Spring pour afficher les informations relatives au mode de jeu lorsque Spring est lancé. Outre les widgets et gadgets de KP campaign qui sont chargés, le mode campagne de Prog&Play est actuellement composé d'un gadget et de plusieurs widgets (la plupart liées à l'interface avec le joueur par des menus). Nous représentons les principaux fichiers ainsi que leurs relations dans la figure \ref{cc}. Les widgets sont représentés en jaune, les gadgets en vert (unique), les fichiers de configuration en gris. Les légendes des fichiers sont en italique sur fond violet. Les relations décrivent les liens entre les fichiers. Les relations grises et en pointillés concernent seulement la lecture ou l'écriture de fichiers textes. Les relations en bleu décrivent des communications intermodules. Tous les fichiers LUA ne sont pas forcément des widgets et des gadgets, c'est le cas de **MissionPlayer.lua** qui joue pourtant un rôle fondamental dans le programme.

Enfin, nous rappelons qu’un gadget peut avoir du code synchronisé et du code non synchronisé. Cet aspect est visible dans la structure même du module *mission_runner.lua*. 
```lua
Ligne 19] 
if (gadgetHandler:IsSyncedCode()) then 
Ligne 127] 
else 
```
[carteConceptuelle]: ./images/capture5.png  "résumé" 
![Carte représentant les principaux fichiers et leurs relations \label{cc}][carteConceptuelle] 

### Investigation des communications inter-module dans KP campaign.

Les communications intermodules dans KP campaign sont importantes, difficiles à saisir sans explication et touchent l'ensemble des modules. Il est donc opportun de présenter KP campaign en suivant la trace des différentes communications pour bien comprendre son fonctionnement.

La page https://springrts.com/wiki/LuaTutorials::InterCommunications le précise, différentes techniques peuvent être utilisées pour effectuer cette communication selon le contexte (synchronisé, non synchronisé).

Nous nous plaçons dans le cas ou Spring a redémarré avec un fichier *MissionN.txt* en argument. Le widget de sélection de missions *pp_spring_direct_launch.lua* responsable des menus permettant de redémarrer Spring avec en argument un fichier de mission. Lorsque ce redémarrage est effectué, le widget, qui normalement est censé s'activer, n'affiche plus ses menus et le joueur ne voit que le terrain de jeu. Cette suppression du menu est effectuée de la manière suivante : dans la méthode *initialilize* du gadget pp_, on peut voir le bloc suivant : 
```lua
if Spring.GetModOptions()["hidemenu"]==nil then
	Spring.SendCommands({'NoSound 1'}) -- Disable sound
	ViewPoint=Spring.GetModOptions()["viewpoint"] 
			   or Spring.GetModOptions()["viewpoint0"] 
			   or Spring.GetModOptions()["viewpoint1"]
	ViewPoint=GetFromQuote(ViewPoint)
	InitializeTimer = Spring.GetTimer()
	HideView = (ViewPoint==nil)
	FunctionsList.SwitchOn()
```
Tout n'est pas à comprendre en détail[^1], mais la logique est de regarder si hidemenu est dans la section ModOptions, s'il ne l'est pas, exécuter une autre fonction : *FunctionsList.SwitchOn()*. La fonction SwitchOn est définie ainsi : 
```lua
local function SwitchOn(menu)
	if not IsActive then
		IsActive = true
		HideView = true
		RemoveAllFrames()
		if type(menu)=="function" then
			menu()
		end
		Spring.SendCommands("endgraph 0")
		Spring.SendCommands("hideinterface 1")
	end
end
```
*RemoveAllFrames()* est une fonction définie ailleurs dans le module pour mettre à *nil* tous les éléments susceptibles d'être affichés.
Enfin, deux commandes sont envoyées par le biais de la fonction *Spring.SendCommands*. Cette fonction permet d'émuler une commande utilisateur (lorsqu'il appuie sur enter au cours du jeu). La liste complète des commandes possibles est définie à : https://springrts.com/wiki/UI_commands . On y apprend :

* */EndGraph* : Enables/Disables the statistics graphs shown at the end of the game
* */HideInterface* : Hide/Show the GUI controlls

Durant les missions, ces commandes sont désactivées. Pour les tester, il est possible de faire *entrée* lors d'une mission.

[^1]: traduction : Je n'ai pas compris en détail, mais je tente de m'en dégager la culpabilité en suggérant que ce n'est pas capital. *viewpoint* ne semble pas présent dans les fichiers de missions employés habituellement, donc *HideView* devrait être *nil*. Ce code est probablement un héritage de code emprunté à KP campaign. Il y a beaucoup de code "passif" dans les modules de Prog&Play et tout n'est pas à comprendre.

#### Afficher un menu personnalisé lorsque l'utilisateur appuie sur echap

Lorsqu’au cours d'une mission, le joueur appuie sur Echap un certain nombre de choses peuvent se produire selon le contexte (vidéo de présentation, tutoriel, mission).

Le code qui permet cela est dans le widget *pp_mission_gui* : 

```lua
function widget:KeyPress(key, mods, isRepeat, label, unicode)
	-- intercept ESCAPE pressure
	if key == KEYSYMS.ESCAPE then
		if not WG.rooms.Video.closed then
			WG.rooms.Video:Close()
			if briefing ~= nil then
				briefing.delayDrawing = false
			end
		else
			if not WG.rooms.TutoView.closed then
				WG.rooms.TutoView:Close()
			end
			if winPopup == nil then
				local event = {logicType = "ShowMissionMenu",
								state = "menu"}
				MissionEvent (event)
			else
				if winPopup.closed then 
					winPopup:Open()
				end
			end
		end
		return true
	end
end
```
On voit l'utilisation du handler *KeyPress* dont la documentation, ainsi que la liste des autres handlers est disponible en ligne à https://springrts.com/wiki/Lua:Callins . Cela permet donc d'intercepter l'appui sur echap est d'agir selon les instructions dans la fonction. Les dix premières lignes permettent de fermer la fenêtre du tutoriel ou de la vidéo. Il y est réalisé une communication widget à widget, visible par l'utilisation de **WG**. Plus précisément il s'agit ici de *pp_gui_rooms.lua* qui est accédé par *WG.rooms*. En effet, les premières lignes du fichier de ce dernier, on lit : 
```lua
local rooms = widget
WG.rooms = rooms
rooms.Window = {}
rooms.Tab = {}
```
Il est donc compris que le widget représenté par ce fichier sera récupéré sous le nom rooms, et que ses deux classes *Window* et *Tab* sont accessibles de l'extérieur. Or, ce n'est pas Window et Tab qui sont appelés dans le bloc de code précédent, mais *Vidéo* et *TutoView*. Ces deux instances sont produites par ce bloc de code de pp_mission_gui :
```lua
local roomList = VFS.DirList(ROOM_DIRNAME, "room_*.lua", VFSMODE)
for _, file in ipairs(roomList) do
  local s = assert(VFS.LoadFile(file, VFSMODE))
  chunk = assert(loadstring(s, file))
  setfenv(chunk, rooms)
  local success, e = pcall(chunk(), file)
end
```
Il permet d'exécuter tous les fichiers lua d'un sous dossier tout en contrôlant la présence d'éventuelles erreurs. Ligne par ligne :

* on s'assure que le fichier existe et on le charge comme une chaine de caractère
* on charge la chaine de caractère comme une fonction
* on associe cette fonction au widget actuel
* on exécute cette fonction en contrôlant d'éventuelles erreurs, pcall étant l'équivalent du try-catch en lua.

Ces fichiers Lua, utilisent les Classes rendues disponibles de l'extérieur (e.g *rooms.Window = {}*) pour produire des instances particulières. Ainsi room_Tuto.lua produit l'instance *TutoView* et room_Video.lua produit *Video*.

Le code de *widget:KeyPress* permet aussi d'introduire la fonction MissionEvent qui permet d'afficher le menu en utilisant la classe Window. Se faisant, il crée un objet nommé *winPopup*, d'où la condition *if winPopup == nil*. Or, il est souhaitable d'appeler cette fonction dans le cadre d'une communication gadget->widget, d'où l'utilisation d'une autre technique de communication intermodule que WG qui est seulement utilisé pour la communication Gadget à Gadget. 
```lua
function widget:Initialize()
	widgetHandler:RegisterGlobal("EmulateEscapeKey", EmulateEscapeKey)
	widgetHandler:RegisterGlobal("MissionEvent", MissionEvent)
	widgetHandler:RegisterGlobal("TutorialEvent", TutorialEvent)
end
```
L'utilisation de *RegisterGlobal* permet aux gadgets d'appeler ces fonctions (en l'occurrence, l'unique gadget mission_runner.lua). On voit donc que MissionEvent est appelé : 

* Dans la partie non synchronisée, par *Script.LuaUI.MissionEvent(e)*
* Dans la partie synchronisée, par *SendToUnsynced("MissionEvent")*

Dans le deuxième cas, un argument est envoyé par le biais de l'enregistrement d'une variable globale : 
```lua
if missionScript ~= nil and gameOver == 0 then
-- update gameOver
local outputState
gameOver,outputState = missionScript.Update(Spring.GetGameFrame())
-- if required, show GuiMission
if gameOver == -1 or gameOver == 1 then
  _G.event = {logicType = "ShowMissionMenu",
	state = "", outputstate=outputState}
  if gameOver == -1 then
	_G.event.state = "lost"
  else
	_G.event.state = "won"
  end
  SendToUnsynced("MissionEvent")
  _G.event = nil
end
```
L'envoi est recupéré dans *gadget:RecvFromSynced(...)* qui retransmet l'information aux widgets par l'emploi de *Script.LuaUI*. 
```lua
function gadget:RecvFromSynced(...)
  local arg1, arg2 = ...
  if arg1 == "mouseDisabled" then
    mouseDisabled = arg2
  elseif arg1 == "enableCameraAuto" then
    if Script.LuaUI("CameraAuto") then
      local specialPositions = {}
      for k, v in spairs(SYNCED.cameraAuto["specialPositions"]) do
        specialPositions[k] = {v[1], v[2]}
      end
      Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], specialPositions) -- function defined and registered in cameraAuto widget
    end
  elseif arg1 == "TutorialEvent" then
    if Script.LuaUI("TutorialEvent") then
      Script.LuaUI.TutorialEvent() -- function defined and registered in mission_gui widget
    end
  elseif arg1 == "MissionEvent" then
    if Script.LuaUI("MissionEvent") then
      local e = {}
        for k, v in spairs(SYNCED.event) do
        e[k] = v
        end
      Script.LuaUI.MissionEvent(e) -- function defined and registered in mission_gui widget
    end
  end
end
```
Le code étudié correspond au menu affiché lorsque que missionScript (module MissionPlayer.lua) renvoi 1 ou -1 lors de son update signifiant respectivement réussite ou échec. Mais il est imaginable qu'on souhaite afficher un message en cours de jeu selon un évènement particulier, ou tout simplement au démarrage. Ainsi, mission_runner.lua enregistre aussi des fonctions destinées à être utilisées de l'exterieur : 
```lua
function gadget:Initialize()
  gadgetHandler:RegisterGlobal("showMessage", showMessage)
  gadgetHandler:RegisterGlobal("showTuto", showTuto)
end
```
Par ce biais, MissionPlayer.lua peut appeler cette fonction par le biais de *Script.LuaRules.showMessage* pour afficher des messages lorsqu'un évènement en cours de jeu le stipule.

#### Utiliser os et io 

**os** et **io** sont des bibliothèques LUA de coeur. **os**, comme son nom l'indique, [permet de nombreuses opérations utilisant l'os](http://lua-users.org/wiki/OsLibraryTutorial) (obtenir la date, l'heure, lancer un exexutable etc...). Sans plus de surprises, **io** [permet de lire et d'écrire des fichiers](http://lua-users.org/wiki/IoLibraryTutorial) en dehors de Spring. Malgrès leur utilité, ces bibliothèques ne sont utilisables que dans du code non synchronisé[^5]. Par ailleurs, de manière générale, on peut s'attendre à ce que le code non synchronisé offre plus de libertés que le code synchronisé car ce dernier est *bloquant*.  Bref, il est parfois necessaire d'utiliser os et io. Comme ces informations sont parfois nécessaires au code synchronisé, il faut donc leur envoyer ces informations par le biais d'une communication intermodule. 

[^5]: Cela vaut peut-être aussi pour d'autres bibliothèques. Je n'ai pas trouvé de ressources en ligne. De plus, cette information selon laquelle io et os ne sont pas utilisable dans du code synchronisé est une découverte empirique. Je n'ai pas non plus trouvé de ressources. Si elles existent, il faut éditer ce document en fonction.

Le code que nous présentons utilise la fonction de message qui permet de charger des fichiers JSON de manière externe (çad placés à l'exterieur de l'archive). Cette forme de communication est rudimentaire car elle passe par l'envoi de texte seulement, ce qui peut necessiter de serialiser et de déserialiser des variables dans des cas complexes.
Partie dans le widget pp_mission_gui.lua :
```lua
if(missionName~=nil)and(Spring.GetModOptions()["hardcoded"]~="yes") then --TODO: Should be placed elsewhere than in pp_mission_gui
  local jsonName=missionName..".json"
  if(missionName~=nil)and(Spring.GetModOptions()["jsonlocation"]~="internal") then
    Spring.Echo("external")
    local file = assert(io.open(jsonPath..jsonName))
    local jsonFile = file:read'*a'
    Spring.SendLuaRulesMsg("mission"..jsonFile)
    file:close()
  else 
    jsonFile=VFS.LoadFile(jsonPath..jsonName)
    Spring.SendLuaRulesMsg("mission"..jsonFile)
  end
end
```
Partie dans le gadger MissionRunner.lua :
```lua
function gadget:RecvLuaMsg(msg, player)
  if msg == "Show briefing" then
    showBriefing=true  
  end
  if((msg~=nil)and(string.len(msg)>7)and(string.sub(msg,1,7)=="mission")) then
    local jsonfile=string.sub(msg,8,-1)
    startTheGame(jsonfile)
  end
end
```
On voit que gadget:RecvLuaMsg est aussi utilisé aussi pour la demande d'affichage de briefing dans le jeu. Pour différencier les messages, la convention choisie est rajouter le préfixe *mission* au fichier JSON chargé. Il faut donc le supprimer une fois que le message est recupéré, c'est le sens de *local jsonfile=string.sub(msg,8,-1)*

# Travaux

Jusqu'à présent nous avons décrit le fonctionnement de *KP campaign* sans rentrer dans le détail des travaux de la période de développement 2015-2016. 

## Scenarisation adaptative en utilisant Appliq

KP campaign propose une suite de missions. Le mode scénario, indiqué par le bouton "nouvelle partie" dans l'écran de selection présenté en figure/ref{ecranSelec}, force la résolution *linéaire* des missions. Un tel scénario laisse peu de possibilités au professeur qui souhaite travailler un certain nombre de missions seulement. Par ailleurs, il est souhaitable d'orienter l'élève vers des missions différentes selon ses performances à la mission courante (par exemple passer par des missions de renforcement). Face à cette problématique qui est plus générale aux jeux sérieux, Bertrand Marne a développé durant sa thèse de doctorat Appliq, une application web permettant de construire des scénarios adaptatifs. L'application est basée sur spip et est hébergée sur le site *jeux sérieux* de l'équipe (http://seriousgames.lip6.fr/appliq/). Une documentation ainsi qu'un tutoriel sont disponibles en ligne, donc nous n'irons pas dans les détails de l'application. 

[ecranSelec]: ./images/capture7.png  "ecranSelec"  
![Écran de selection du mode de résolution des missions (libre ou scénarisé) \label{ecranSelec}][ecranSelec] 

Lorsqu'un parcours est créé, un fichier `XML` le décrivant est téléchargeable. Nous avons développé une classe *AppliqManager* permettant d'interpréter et de le parcourir pour pouvoir intégrer le parcours conçu dans KP compaign. La documentation de cette classe est fournie dans un dossier à part. Elle a été générée par l'outil libre **Ldoc** permettant de générer de la documentation de modules Lua. 
Les scénarios appliq sont constitués d'activités et de liens entre ces activités. Un lien est défini par un output (sortie d'activité) et un input (entrée d'activité). Toute activité peut avoir plusieurs input et output. Par ailleurs, une activité fait travailler des buts pédagogiques et ludiques. Cette information est incluse dans le *XML*. Notre classe *AppliqManager* [^2] implémente toutes les fonctions logiquement attendues pour travailler avec ces informations (cf documentation).

[^2]: Si les tables peuvent être considérées comme des objets, il n'y a pas vraiment de classe en Lua, on devrait parler plutôt de table à laquelle sont associées des valeurs et des fonctions. Ceci étant dit, le langage est suffisamment flexible pour de développer dans le paradigme objet en utilisant la notion de prototype cf : http://www.lua.org/pil/16.1.html .
*AppliqManager* est utilisé à plusieurs endroits dans le projet :

* Lors du la selection d'un mode de jeu il est recherché la présence de fichiers XML dans le dossier **Appliq** du dossier de Spring, si un fichier est présent et que son parsing ne cause pas d'erreur, son nom est alors affiché. Source : fonction SelectScenario() dans pp_spring_direct_launch.lua. Si ce mode de jeu est choisi, alors la mission courante est donnée par la fonction *startRoute* de AppliqManager. Source : (fonction RunScenario(i) dans pp_spring_direct_launch.lua ). Plusieurs informations sont alors stockées dans le fichier *MissionN.txt* : 
	* L'indication que le mode de parcours est géré par Appliq
	* L'identifiant du parcours choisi
	* La progression du joueur indiquée par la suite des états de sorties empruntés au cours des différentes missions (en l'occurrence, qu'une seule valeur dans ce contexte)
	* L'état d'entrée de l'activité (inputState). Cet état d'entrée permet de connaître *"d'où vient le joueur"*. La mission peut être paramétrée par cet état d'entrée pour simplifier, aider, complexifier, cacher la redondance, etc.)[^3].
* À la fin d'une mission. Lorsque le menu de fin apparait, les boutons sont liés à des fonctions permettant de recharger Spring avec une nouvelle mission. Si les informations de ModOptions indiquent que le contexte de jeu est un scénario Appliq, alors le comportement du bouton *continuer* change : AppliqManager s'informe de l'état de sortie de la mission (outputState) et sélectionne l'activité suivante en suivant les informations sur le parcours chargé. Il effectue les mêmes opérations qu'au démarrage (cf puce précédente) mais avec de nouvelles valeurs pour la progression et l'inputState. Cette intervention d'AppliqManager est visible dans la fonction *MissionEvent* du widget *pp_mission_gui*. Deux fonctions sont alors utilisées : setProgression et next.
```lua
AppliqManager:setProgression(progression) -- Pour charger la progression
AppliqManager:next(e.outputstate) -- pour trouver la nouvelle activité
```
La condition pour pouvoir utiliser AppliqManager est que le module décrivant la mission fournisse l'état de sortie de cette dernière lorsqu'elle est finie. Si ce n'est pas le cas, alors AppliqManager est contraint de choisir au hasard la mission suivante.

[^3]: Nous notons au passage qu'une fonction (updateValues dans RestartScript.lua) a été construite pour faciliter l'insertion d'informations dans le fichier txt avec le support d'une bibliothèque Lua nommée *pickle* permettant la sérialisation. Il est ainsi possible de stocker des tables imbriquées dans la section modoptions du fichier.