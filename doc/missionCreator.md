# Mission Creator : Introduction

## Préparatifs

Ce mode va vous permettre de modifier et produire dans Prog&Play.
Instructions :

1. Téléchargez et décompressez le dossier [Missions](./Missions.zip) et le placer au même niveau que *Spring.exe* de telle sorte que *dossier_de_spring/Missions/jsonFiles/Mission1.json* soit un chemin valide.
2. Téléchargez et placez le dossier [KP_campaign_2.4.sdz](./KP_campaign_2.4.sdz) dans le sous-dossier mods, qui se trouve au même niveau que *Spring.exe* 
3. Tester le nouveau mode de jeu en lançant Spring, sélectionnant le mode KP campaign **2.4**, et en choisissant le mode *jouer une mission précise*, et jouer la *mission 1*. Si la mission 1 ne semble pas fonctionner correctement, appelez votre encadrant.

## Modification des missions

### Vue d'ensemble des informations

Le dossier de missions que vous avez décompressé contient des fichiers de données qui décrivent et paramètrent les missions. Pour un premier contact avec ces fichiers, faites une copie de sauvegarde de *Mission1.json* avant de l'ouvrir avec votre éditeur de texte pour l'observer. Sa structure, similaire aux autres fichiers du dossier est composée des 7 grandes sections suivantes :

- **armies** : Décrivant les armées du joueur, de l'IA ou de l'allié
- **settings** : Décrivant quelques informations globales sur la mission
- **messages** : Décrivant les différents messages pouvant être utilisés à différentes occasions (briefing, indicateurs localisés qu'on apelle marker)
- **positions** : Les différentes positions d'intérêt de la mission, utilisables aussi à différentes occasions (placement des unités, des markers, évaluation des conditions...)

Une mission est construite sur la base *si condition alors actions* on appelle cela un événement (event).

- **conditions** : décrit les conditions possibles (ex : *telle* unité placée à *telle* position)
- **actions** : décrit les actions (ex : écrire un message, terminer le jeu en condition *réussite* ou *échec*)
- **events** : Fait le lien entre une ou des conditions avec une ou plusieurs actions, ne contient pas d'informations spécifiques.

### Premier test

- Changez le type d'unité du joueur dans la *mission1*: un *byte* plutôt qu'un *bit*
- Faites en sorte qu'il apparaisse plus proche de la position d'arrivée (à la position x=1700, z=1700 par exemple)
- Relancez Spring (ou *echap->quitter la mission* si vous êtes en jeu) et testez si vos modifications ont fonctionné.

### Forme du fichier : le format JSON

Comme il est prévu de faire des modifications plus élaborées qu'un changement de valeurs dans les fichiers de mission, il est nécessaire de comprendre un peux mieux le format *JSON*. Ce format, qui se prononce "*Jayson"* est une manière légère de stocker des informations dans un fichier. La capture d'écran annotée représente tout ce que vous avez à savoir sur le format. Une erreur de syntaxe est vite arrivée, prenez l'habitude de coller et testez votre fichier JSON dans un validateur, par exemple http://www.jsonlint.com . Faites le régulièrement.

![Partie annotée du fichier de Mission1.json concernant les positions. Notez bien la présence de séparateur entre les deux éléments de la liste ](./images/captureMissionCreator.png) 

Le saut de ligne n'a pas d'importance, il permet d'aérer les données et peut être négligé pour compresser les informations.

# Mission Creator : Exercices

Pour les exercices, vous pouvez vous aider des fichiers JSON existants et de la documentation en fin de document.

## Exercice 1

Faire un équivalent de la mission 1 en y apportant successivement les améliorations suivantes : 

- Montez de 200 points la position d'arrivée et descendez de 200 points (une case sur la carte = 50pts) la position de départ. 
- Placez un bit ennemi au milieu de la trajectoire amenant au point d'arrivée
- Mettez la vie au minimum de votre bit pour qu'il perde le combat s'il s'aventure proche du bit ennemi
- Changez le briefing pour informer de cette nouvelle difficulté
- Écrivez un message au-dessus de l'ennemi lorsque votre unité passe à coté (*"ennemi detecté !"*)
- Resolvez votre propre mission

## Exercice 2 

À partir d'une mission existante, créez votre propre mission. 

# Documentation simplifiée

## Les identifiants

Les informations du JSON sont liées les unes aux autres par un jeu d'identifiants (id), souvent la première valeur des tableaux associatifs que vous pouvez lire. Retenez que :

- Les armées sont créees à une position
- Les événements sont liéees à une ou plusieurs conditions (parties trigger), et une ou plusieurs actions (actions)
- Les actions peuvent concerner des positions, messages et unités.

Tous ces liens sont construits en utilisant les **id**, il faut donc vérifier qu'ils soient concordants.

## Les positions

Les positions peuvent être utilisées dans beaucoup d'endroits différents. On retrouve régulièrement ce type de structure impliquant l'id de la position et un autre attribut *"validZone"*. ValidZone indique la zone approximative à laquelle une condition ou une action est liée :

* Si c'est une condition, par exemple dans la mission1, c'est pour la rendre valide même si la position exacte n'est pas obtenue : 
```json
{
"id":"WellPlaced",
"object":"unitID",
"attribute":"position",
"value":
	{
	"positionId":"arrival",
	"validZone":"100"
	}
},
```
Cette condition est vraie si l'unité d'id unitID est à la position arrival à plus au moins 100 points.

* Si c'est une action ou une création d'unités, c'est pour randomiser la position. Exemple de la mission 3 dans laquelle on fait se déplacer le BYTE allié à une position aléatoire :
```json
{
"id":"AllyMoving",
"toBeRepeated":"yes",
"delay":"0",
"type":"move",
"object":"lostUnit",
"position":
	{
	"positionId":"byteStartingPosition",
	"validZone":"100"
	}
},
```

Dans la Mission6, l'utilisation de **validZone** permet de randomiser le placement des unités. Ainsi, on retrouve à plusieurs endroits dans la description des unités :
```json
{"positionId":"positionArmy","validZone":"130"}
```
Ce qui permet de randomiser leurs placements et éviter ainsi un entassement au même endroit. *validZone* peut être désactivé en lui donnant la valeur *"no"*.

## Les armées

Commentons le fichier de la mission3 qui laisse apparaître une unité au joueur, une unité alliée et une unité ennemie. Sa structure est la suivante :
```json
{
"armies" :
[
	{
	"faction" : "PLAYER",
	"units" : 
		[
		[liste des unités du joueur]
		]
	},
	{
	"faction" : "ALLY",
	"units" : 
		[	
		[liste des unités de l'allié]
		]
	},
	{
	"faction" : "ENNEMY",
	"units" : 
		[	
		[liste des unités de l'ennemi]
		]
	}
],
```
Il est important de remarquer qu'une liste de valeurs est attendue dans la partie units. Regardons comment une unité est créée :
```json
{
"id":"unitID",
"visibleAtStart":"yes",
"type":"bit",
"position":
	{
	"positionId":"start",
	"validZone":"no"
	},
"orientation" :"n",
"health":{
	"relativeValue":"0.25",
	"autoHeal":"disabled"
	}
}
```
Les informations les plus importantes sont :

* id : pour se référer à cette unité ailleurs dans le fichier
* type : le type d'unité (bit,byte,assembler ou kernel)
* position : la position (cf partie précédente)
* relativeValue : la valeur relative de sa santé comparée à sa santé max (1 => santé max)

## Les settings
Prenons l'exemple de la mission 1 :
```json
"settings":
	{
		"mouse":"disabled",
		"health":{
			"relativeValue":"0.25",
			"autoHeal":"disabled"
		},
		"camera":
		{
			"auto":"enabled",
			"specialPositions":
			[
				{
				"positionId":"arrival"
				}
			]
		}	
	},
```
La variable la plus importante est **specialPositions** qui attend une liste d'identifiants de positions. La caméra sera optimisée pour garder dans la même vue la liste de positions donnée.

## Les messages

Prenons l'exemple de la mission 1 :

```json
[
	{
	"id":"rallying",
	"content":
		{
		"fr":"Point de ralliement",
		"en":"Rallying point"
		}
	},
	{
	"id":"BRIEFING",
	"content":
		{
		"fr":"Mission 1\n \n \nVous allez devoir constituer et commander un groupe d'intervention spéciale pour mener une attaque éclair sur un poste de commandement peu défendu. Si vous atteignez cet objectif final, nos ennemis s'en trouveront désorientés et nous exploiterons cet avantage pour mettre un terme à la  \"guerre numérique\".\n \nUn rapport vous est parvenu vous indiquant qu'un BYTE (OCTET) se trouverait au point de ralliement (1983, 1279). Déplacez votre unique entité à cette position pour tenter de rallier à notre cause le BYTE solitaire. Bon courage...\n \n..gray..Appuyez sur Echap pour continuer",
		"en":"Mission 1\n \n \nYou have to form and command a rapid deployment force in order to lightning strike an ennemy headquarters weakly defended. If you reach this final objective, ennemies will be desoriented and we will use this advantage to end this \"digital war\".\n \nYou received a report that indicates that a BYTE would be at the rallying point (1983, 1279). Move your single unit to this position for trying to rallying the solitary BYTE to our cause. Good luck...\n \n..gray..Press Escape to continue"	
		}
	}
],
```
La structure est explicite, il n'est pas nécessaire de commenter.
Le message dont l'id est **BRIEFING** est par convention le message affiché dans le briefing (il est possible de changer sa valeur mais pas son id). Il est possible de donner, dans *content*, une liste de message. Le message sera alors choisi de manière aléatoire dans la liste. Voir par exemple la mission 3 :
```json
{
"id":"crying",
"content":
	[
	{"fr":"Aidez moi !!!" ,"en":"Help me !!!"},
	{"fr":"S'il vous plait..." ,"en":"Please..."},
	{"fr":"AAaarghh" ,"en":"AAaarghh"},
	{"fr":"J'ai besoin d'aide" ,"en":"I need help"},
	{"fr":"Que faites vous ?" ,"en":"What do you do?"},
	{"fr":"Je ne tiendrai\npas longtemps" ,"en":"I won't resist\na long time"},
	{"fr":"Mon energie diminue" ,"en":"My energy weakens"},
	{"fr":"Il m'en met\nplein la gueule" ,"en":"He beats me up"},
	{"fr":"Noooonnn" ,"en":"Noooonnn"}
	]
}
```


## Les positions

Mission 1 encore :
```json
"positions":
	[
		{
		"id":"arrival",
		"coordinates":"absolute",
		"x":"1983",
		"z":"1279"
		},
		{
		"id":"start",
		"coordinates":"absolute",
		"x":"1792",
		"z":"1792"
		}
	],
```
Explicite. Pas de commentaire particulier à faire.

Les positions de la Mission 3 complètent ce qu'on peut faire avec les positions
```json
{
"id":"byteStartingPosition",
"type":"static",
"coordinates":"relative",
"origin":"bitPosition",
"dx":"0",
"dz":"-100"
},
{
"id":"byteCurrentPosition",
"type":"dynamic",
"updatedAccording":"lostUnit",
"coordinates":"absolute",
"x":"1056",
"z":"1792"
},
```
La première position est **relative**, elle est construite à partir d'une autre position (*bitPosition* en l'occurence). La deuxième position est **dynamique**. Elle se met à jour au cours du jeu pour designer la position de l'unité lostUnit.

## Les conditions

Beaucoup de conditions sont possibles et il serait rébarbatif de les détailler ici. Le mieux est de se baser sur des exemples dans les fichiers :

- mission 1 pour la position (position) ou la mort (dead) d'une unité
- mission 3 pour le temps (frame number, noter que 16frames = 1s), le déplacement d'une unité (moving), le fait qu'une unité soit attaquée (underAttack)
- mission 7 pour la santé (health)

Les conditions s'appliquent à une unité ou à un groupe d'unité. C'est visible dans la mission 7 par exemple ou toutes les unités d'un groupe doivent être soignées :
```json
{
"id":"fullHealthEveryone",
"object":"armyWithoutAssembler",
"attribute":"health",
"value":
	{
	"group":"all",
	"mode":"upTo",
	"tresholdRatio":"1"
	}
}
```
Si la valeur *"any"* était donnée à l'attribut *""group""*, alors la condition aurait été vérifiée si au moins une unité du groupe vérifie la condition. 
**Note :** il est possible de définir des groupes d'unités, c'est ce qui est réalisé dans la mission 7 pour exclure l'assembleur du groupe des unités à soigner (ctrl+F groupOfArmies dans le fichier).

## Les actions

Plusieurs actions sont possibles, le mieux est de s'inspirer des différentes missions. La mission 3 exhibe la plupart des actions existantes. Deux informations importantes sont à noter :

* Le succès et la défaite sont des actions, cf mission 1.
```json
{
"id":"defeat",
"toBeRepeated":"no",
"delay":"0",
"type":"end",
"outputState":"1111",
"result":"defeat"
},
{
"id":"victory",
"toBeRepeated":"no",
"delay":"0",
"type":"end",
"outputState":"1111",
"result":"success"
}
```

* Certains attributs se retrouvent dans toutes les actions : 	
	- "toBeRepeated" indiquant si l'action doit être répétée tant que la condition qui l'active est vraie (cf event)
	- "delay" : donnant un delai en nombre de frames (16 frames = 1s) avant que l'action s'applique

## Les événements (events)

La structure des événements est facile à comprendre, mais quelques subtilités sont à noter. Prenons l'événement suivant de la mission 3.
```json
{
"idEvent":"hasStopped",
"trigger":"(not lostUnitisMoving)and(allyUnderAttack)",
"actions":
	[
	{"actionId":"AllyMoving"},
	{"actionId":"AllyCryingForHelp"},
	{"actionId":"deletingMarker"}
	]
}
```
Cet événement est activé si et seulement si : la condition *lostUnitisMoving* est fausse et la condition *allyUnderAttack* est vraie. Il va alors se mettre à se déplacer et à se plaindre. On remarque la dernière action, *deletingMarker* qui, si on étudie le fichier, a un delai de 160 frames. L'action *AllyCryingForHelp*, elle, a un délai de 100 frames. Ainsi, le marqueur est affiché 60/16 environ 4s.