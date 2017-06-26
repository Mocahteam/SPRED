VFS.Include("LuaUI/Widgets/editor/TextColors.lua")

actions_list = {
	{
		type = "win",
		filter = "Game",
		typeText = "Player wins",
		text = "[en]<Player> wins with state <State>.[en][fr]<Joueur> gagne avec l'�tat <Etat>.[fr]",
		attributes = {
			{
				text = "[en]<Player>[en][fr]<Joueur>[fr]",
				type = "player",
				id = "team"
			},
			{
				text = "[en]<State>[en][fr]<Etat>[fr]",
				type = "text",
				id = "outputState",
				hint = "[en]This string will be used as output state for the scenario editor[en][fr]Cette information sera utilis�e comme un �tat de sortie pour l'�diteur de sc�nario[fr]"
			}
		}
	},
	{
		type = "lose",
		filter = "Game",
		typeText = "Player loses",
		text = "[en]<Player> loses with state <State>.[en][fr]<Joueur> perd avec l'�tat <Etat>.[fr]",
		attributes = {
			{
				text = "[en]<Player>[en][fr]<Joueur>[fr]",
				type = "player",
				id = "team"
			},
			{
				text = "[en]<State>[en][fr]<Etat>[fr]",
				type = "text",
				id = "outputState",
				hint = "[en]This string will be used as output state for the scenario editor[en][fr]Cette information sera utilis�e comme un �tat de sortie pour l'�diteur de sc�nario[fr]"
			}
		}
	},
	{
		type = "wait",
		filter = "Game",
		typeText = "Wait",
		text = "[en]Wait <Time> seconds.[en][fr]Attendre <Temps> secondes.[fr]",
		attributes = {
			{
				text = "[en]<Time>[en][fr]<Temps>[fr]",
				type = "text",
				id = "time",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des op�rateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "waitCondition",
		filter = "Game",
		typeText = "Wait for condition",
		text = "[en]Wait for <Condition> to be true.[en][fr]Attendre que <Condition> soit vraie.[fr]",
		attributes = {
			{
				text = "<Condition>",
				type = "condition",
				id = "condition",
				hint = "[en]The condition can be chosen within the conditions of this event, which may not be part of the trigger of this event.[en][fr]La condition peut �tre choisie parmi les conditions de cet �v�nement[fr]"
			}
		}
	},
	{
		type = "waitTrigger",
		filter = "Game",
		typeText = "Wait for trigger",
		text = "[en]Wait for <Trigger> to be true.[en][fr]Attendre que <D�clencheur> soit vrai.[fr]",
		attributes = {
			{
				text = "[en]<Trigger>[en][fr]<D�clencheur>[fr]",
				type = "text",
				id = "trigger",
				hint = "[en]This field must be filled with a boolean expression of the conditions of this event. For example, given an event with 3 conditions C1, C2 and C3, the trigger can be \"C1 or C2\".[en][fr]Ce champs doit �tre compl�t� avec une expression bool�enne compos� des conditions de cet �v�nement. Par exemple, consid�rant un �v�nement avec 3 conditions C1, C2 et C3, le d�clencheur pourrait �tre \"C1 or C2\".[fr]"
			}
		}
	},
	{
		type = "enableWidget",
		filter = "Game",
		typeText = "Enable Widget",
		text = "[en]Enable <Widget>.[en][fr]Activer <Widget>.[fr]",
		attributes = {
			{
				text = "<Widget>",
				type = "widget",
				id = "widget"
			}
		}
	},
	{
		type = "disableWidget",
		filter = "Game",
		typeText = "Disable Widget",
		text = "[en]Disable <Widget>.[en][fr]D�sactiver <Widget>.[fr]",
		attributes = {
			{
				text = "<Widget>",
				type = "widget",
				id = "widget"
			}
		}
	},
	{
		type = "enableLOS",
		filter = "Game",
		typeText = "Enable Line of Sight",
		text = "[en]Enable line-of-sight (default), only units close to units' player will be visible.[en][fr]Activer les lignes de vues, seules les unit�s proches des unit�s du joueur seront visibles.[fr]",
		attributes = {}
	},
	{
		type = "disableLOS",
		filter = "Game",
		typeText = "Disable Line of Sight",
		text = "[en]Disable line-of-sight which makes the whole map permanently visible to everyone.[en][fr]D�sactiver les lignes de vues qui rend visible toute la carte � tous les joueurs.[fr]",
		attributes = {}
	},
	{
		type = "centerCamera",
		filter = "Control",
		typeText = "Center camera to position",
		text = "[en]Center camera to <Position>.[en][fr]Centrer la cam�ra sur <Position>.[fr]",
		attributes = {
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "cameraAuto",
		filter = "Control",
		typeText = "Change camera auto state",
		text = "[en]Camera auto is now <State>.[en][fr]La cam�ra automatique est maintenant <Etat>.[fr]",
		attributes = {
			{
				text = "[en]<State>[en][fr]<Etat>[fr]",
				type = "toggle",
				id = "toggle"
			}
		}
	},
	{
		type = "mouse",
		filter = "Control",
		typeText = "Change mouse state",
		text = "[en]Mouse is now <State>.[en][fr]La souris est maintenant <Etat>.[fr]",
		attributes = {
			{
				text = "[en]<State>[en][fr]<Etat>[fr]",
				type = "toggle",
				id = "toggle"
			}
		}
	},
	{
		type = "createUnits",
		filter = "Unit",
		typeText = "Create Units in Zone",
		text = "[en]Create <Number> units of type <UnitType> for <Team> within <Zone>.[en][fr]Cr�er <Nombre> d'unit�s du type <Type> pour <Equipe> dans <Zone>.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "text",
				id = "number",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des op�rateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<UnitType>[en][fr]<Type>[fr]",
				type = "unitType",
				id = "unitType"
			},
			{
				text = "[en]<Team>[en][fr]<Equipe>[fr]",
				type = "team",
				id = "team"
			},
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "kill",
		filter = "Unit",
		typeText = "Kill units",
		text = "[en]Kill <UnitSet>.[en][fr]Tuer <Ensemble>.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			}
		}
	},
	{
		type = "hp",
		filter = "Unit",
		typeText = "Set HP of units",
		text = "[en]Set hit points of <UnitSet> to <Percentage> %.[en][fr]D�finir les point de vie de <Ensemble> � <Pourcentage> %.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Percentage>[en][fr]<Pourcentage>[fr]",
				type = "text",
				id = "percentage",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des op�rateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "transfer",
		filter = "Unit",
		typeText = "Transfer units",
		text = "[en]Transfer <UnitSet> to <Team>.[en][fr]Transf�rer <Ensemble> � <Equipe>.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Team>[en][fr]<Equipe>[fr]",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "teleport",
		filter = "Unit",
		typeText = "Teleport units",
		text = "[en]Teleport <UnitSet> to <Position>.[en][fr]T�l�porter <Ensemble> vers <Position>.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "order",
		filter = "Order",
		typeText = "Order units (untargeted order)",
		text = "[en]Order <UnitSet> to begin <Command> with <Parameters>.[en][fr]Ordonner � <Ensemble> de r�aliser <Commande> avec les param�tres <Param�tres>.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Command>[en][fr]<Commande>[fr]",
				type = "command",
				id = "command"
			},
			{
				text = "[en]<Parameters>[en][fr]<Param�tres>[fr]",
				type = "textSplit",
				id = "parameters",
				hint = "[en]Parameters can be specified as numbers separated by ||. Please refer to the game documentation to know which parameter to use.[en][fr]Plusierus param�tres peuvent �tre d�finis sous forme de nombre s�par�s par ||. Veuillez vous r�f�rer � la documentation du jeu pour conna�tre les param�tres possibles.[fr]"
			}
		}
	},
	{
		type = "orderPosition",
		filter = "Order",
		typeText = "Order units to position",
		text = "[en]Order <UnitSet> to begin <Command> towards <Position>.[en][fr]Ordonner � <Ensemble> de r�aliser <Commande> � <Psotion>.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Command>[en][fr]<Commande>[fr]",
				type = "command",
				id = "command"
			},
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "orderTarget",
		filter = "Order",
		typeText = "Order units to target",
		text = "[en]Order <UnitSet> to begin <Command> towards <Target>.[en][fr]Ordonner � <Ensemble> de r�aliser <Commande> sur <Cible>.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Command>[en][fr]<Commande>[fr]",
				type = "command",
				id = "command"
			},
			{
				text = "[en]<Target>[en][fr]<Cible>[fr]",
				type = "unitset",
				id = "target"
			}
		}
	},
	{
		type = "messageGlobal",
		filter = "Message",
		typeText = "Display message",
		text = "[en]Display <Message> and <Pause> the game.[en][fr]Afficher <Message> et mettre en <Pause> le jeu.[fr]",
		attributes = {
			{
				text = '<Message>',
				type = "textSplit",
				id = "message",
				hint = "[en]Multiple messages can be defined using || to split them. A random one will be picked each time this action is called.[en][fr]Plusieurs messages peuvent �tre d�finis en les s�parant avec des ||. L'un de ces messages sera choisi al�atoirement � chaque fois que cette action sera trait�e.[fr]"
			},
			{
				text = "<Pause>",
				type = "boolean",
				id = "boolean"
			}
		}
	},
	{
		type = "messagePosition",
		filter = "Message",
		typeText = "Display message at position",
		text = "[en]Display <Message> at <Position> for <Time> seconds.[en][fr]Afficher <Message> sur <Position> pendant <Temps> secondes.[fr]",
		attributes = {
			{
				text = '<Message>',
				type = "textSplit",
				id = "message",
				hint = "[en]Multiple messages can be defined using || to split them. A random one will be picked each time this action is called.[en][fr]Plusieurs messages peuvent �tre d�finis en les s�parant avec des ||. L'un de ces messages sera choisi al�atoirement � chaque fois que cette action sera trait�e.[fr]"
			},
			{
				text = "<Position>",
				type ="position",
				id = "position"
			},
			{
				text = "[en]<Time>[en][fr]<Temps>[fr]",
				type = "text",
				id = "time",
				hint = "[en]You can put 0 in this field for an infinite duration. You can also use variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez indiquer 0 pour une dur�e infinie. Vous pouvez �galement utiliser des variables et des op�rateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "messageUnit",
		filter = "Message",
		typeText = "Display message above units",
		text = "[en]Display <Message> over units of <UnitSet> for <Time> seconds.[en][fr]Afficher <Message> au dessus des unit�s de <Ensemble> pendant <Temps> secondes.[fr]",
		attributes = {
			{
				text = "<Message>",
				type = "textSplit",
				id = "message",
				hint = "[en]Multiple messages can be defined using || to split them. A random one will be picked each time this action is called.[en][fr]Plusieurs messages peuvent �tre d�finis en les s�parant avec des ||. L'un de ces messages sera choisi al�atoirement � chaque fois que cette action sera trait�e.[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Time>[en][fr]<Temps>[fr]",
				type = "text",
				id = "time",
				hint = "[en]You can put 0 in this field for an infinite duration. You can also use variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez indiquer 0 pour une dur�e infinie. Vous pouvez �galement utiliser des variables et des op�rateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "bubbleUnit",
		filter = "Message",
		typeText = "Display message in a bubble above units",
		text = "[en]Display <Message> in a bubble over <UnitSet> for <Time> seconds.[en][fr]Afficher <Message> dans une bulle au dessus de <Ensemble> pendant <Temps> secondes.[fr]",
		attributes = {
			{
				text = "<Message>",
				type = "textSplit",
				id = "message",
				hint = "[en]Multiple messages can be defined using || to split them. A random one will be picked each time this action is called.[en][fr]Plusieurs messages peuvent �tre d�finis en les s�parant avec des ||. L'un de ces messages sera choisi al�atoirement � chaque fois que cette action sera trait�e.[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Time>[en][fr]<Temps>[fr]",
				type = "text",
				id = "time",
				hint = "[en]You can put 0 in this field for an infinite duration. You can also use variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez indiquer 0 pour une dur�e infinie. Vous pouvez �galement utiliser des variables et des op�rateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "showBriefing",
		filter = "Message",
		typeText = "Show briefing",
		text = "[en]Show the briefing (The briefing is automatically shown on start, use this action only to show the briefing again in game).[en][fr]Afficher le briefing (Le briefing est automatiquement afficher au d�marrage d'une partie, n'utilisez cette action seulement pour afficher � nouveau de briefing en cours de partie).[fr]",
		attributes = {}
	},
	{
		type = "addToGroup",
		filter = "Group",
		typeText = "Add units to group",
		text = "[en]Add <UnitSet> to <Group>.[en][fr]Ajouter <Ensemble> � <Groupe>.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Group>[en][fr]<Groupe>[fr]",
				type = "group",
				id = "group"
			}
		}
	},
	{
		type = "removeFromGroup",
		filter = "Group",
		typeText = "Remove units from group",
		text = "[en]Remove <UnitSet> from <Group>.[en][fr]Retirer <Ensemble> de <Groupe>.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Group>[en][fr]<Groupe>[fr]",
				type = "group",
				id = "group"
			}
		}
	},
	{
		type = "union",
		filter = "Group",
		typeText = "Union between 2 Unitsets",
		text = "[en]Set <Group> to the union between <UnitSet1> and <UnitSet2>.[en][fr]D�finir <Groupe> comme l'union de <Ensemble1> et <Ensemble2>.[fr]",
		attributes = {
			{
				text = "[en]<Group>[en][fr]<Groupe>[fr]",
				type = "group",
				id = "group"
			},
			{
				text = "[en]<UnitSet1>[en][fr]<Ensemble1>[fr]",
				type = "unitset",
				id = "unitset1"
			},
			{
				text = "[en]<UnitSet2>[en][fr]<Ensemble2>[fr]",
				type = "unitset",
				id = "unitset2"
			}
		}
	},
	{
		type = "intersection",
		filter = "Group",
		typeText = "Intersection between 2 Unitsets",
		text = "[en]Set <Group> to the intersection between <UnitSet1> and <UnitSet2>.[en][fr]D�finir <Groupe> comme l'intersection de <Ensemble1> et <Ensemble2>.[fr]",
		attributes = {
			{
				text = "[en]<Group>[en][fr]<Groupe>[fr]",
				type = "group",
				id = "group"
			},
			{
				text = "[en]<UnitSet1>[en][fr]<Ensemble1>[fr]",
				type = "unitset",
				id = "unitset1"
			},
			{
				text = "[en]<UnitSet2>[en][fr]<Ensemble2>[fr]",
				type = "unitset",
				id = "unitset2"
			}
		}
	},
	{
		type = "showZone",
		filter = "Zone",
		typeText = "Show zone in game",
		text = "[en]Show <Zone> in game.[en][fr]Rendre visible <Zone> dans le jeu.[fr]",
		attributes = {
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "hideZone",
		filter = "Zone",
		typeText = "Hide zone in game",
		text = "[en]Hide <Zone> in game.[en][fr]Cacher <Zone> dans le jeu.[fr]",
		attributes = {
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "changeVariable",
		filter = "Variable",
		typeText = "Set number variable",
		text = "[en]Set <Variable> to <Number>.[en][fr]Affecter � <Variable> la valeur <Nombre>.[fr]",
		attributes = {
			{
				text = "<Variable>",
				type = "numberVariable",
				id = "variable",
				hint = "[en]Variables can be defined by going to the menu available through the event panel.[en][fr]Les variables peuvent �tre d�finies � travers le menu accessible sous le panneau de gestion des �v�nements.[fr]"
			},
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "text",
				id = "number",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des op�rateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "changeVariableRandom",
		filter = "Variable",
		typeText = "Change the value of a variable randomly",
		text = "[en]Set <Variable> to a random integer between <Min> and <Max>.[en][fr]Affecter � <Variable> une valeur al�atoire comprise entre <Min> et <Max>.[fr]",
		attributes = {
			{
				text = "<Variable>",
				type = "numberVariable",
				id = "variable",
				hint = "[en]Variables can be defined by going to the menu available through the event panel.[en][fr]Les variables peuvent �tre d�finies � travers le menu accessible sous le panneau de gestion des �v�nements.[fr]"
			},
			{
				text = "<Min>",
				type = "text",
				id = "min",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des op�rateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "<Max>",
				type = "text",
				id = "max",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des op�rateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "setBooleanVariable",
		filter = "Variable",
		typeText = "Set boolean variable",
		text = "[en]Set <Variable> to <Boolean>.[en][fr]Affecter � <Variable> la valeur <Bool�en>.[fr]",
		attributes = {
			{
				text = "<Variable>",
				type = "booleanVariable",
				id = "variable",
				hint = "[en]Variables can be defined by going to the menu available through the event panel.[en][fr]Les variables peuvent �tre d�finies � travers le menu accessible sous le panneau de gestion des �v�nements.[fr]"
			},
			{
				text = "[en]<Boolean>[en][fr]<Bool�en>[fr]",
				type = "boolean",
				id = "boolean"
			}
		}
	},
	{
		type = "script",
		filter = "Script",
		typeText = "Execute custom script",
		text = "[en]Execute custom LUA script <Script>.[en][fr]Ex�cuter le script LUA <Script>.[fr]",
		attributes = {
			{
				text = "<Script>",
				type = "text",
				id = "script"
			}
		}
	}
}

-- Disable PP actions when not in a PP version of Spring
if not Game.isPPEnabled then
	for i, a in ipairs(actions_list) do
		if a.type == "feedback" then
			table.remove(actions_list, i)
			break
		end
	end
end

-- COLOR TEXT
for i, a in ipairs(actions_list) do
	for ii, attr in ipairs(a.attributes) do
		if textColors[attr.type] then
			for iii, keyword in ipairs(textColors[attr.type].keywords) do
				a.text = string.gsub(a.text, keyword, textColors[attr.type].color..keyword.."\255\255\255\255")
				attr.text = string.gsub(attr.text, keyword, textColors[attr.type].color..keyword.."\255\255\255\255")
			end
		end
	end
end

-- ADD FILTER TO THE NAME
for i, a in ipairs(actions_list) do
	a.typeText = a.filter.." - "..a.typeText
end