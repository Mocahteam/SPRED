VFS.Include("LuaUI/Widgets/editor/TextColors.lua")

conditions_list = {
	{
		type = "start",
		filter = "Game",
		typeText = "Game start",
		text = "[en]When game starts.[en][fr]Lorsque le jeu démarre.[fr]",
		attributes = {}
	},
	{
		type = "elapsedTime",
		filter = "Game",
		typeText = "Time elapsed",
		text = "[en]Seconds elapsed <Comparison> <Number>.[en][fr]Nombre de secondes écoulées <Comparaison> <Nombre>.[fr]",
		attributes = {
			{
				text = "[en]<Comparison>[en][fr]<Comparaison>[fr]",
				type = "comparison",
				id = "comparison"
			},
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "text",
				id = "number",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des opérateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "repeat",
		filter = "Game",
		typeText = "Periodically true",
		text = "[en]True every <Number> seconds since the begining of the mission.[en][fr]Vrai chaque <Nombre> secondes depuis le début de la mission.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "text",
				id = "number",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des opérateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "widgetEnabled",
		filter = "Game",
		typeText = "Widget is enabled",
		text = "[en]True if <Widget> is enabled for <Team>.[en][fr]Vrai si <Widget> est activé pour <Equipe>.[fr]",
		attributes = {
			{
				text = "<Widget>",
				type = "widget",
				id = "widget"
			},
			{
				text = "[en]<Team>[en][fr]<Equipe>[fr]",
				type = "teamWithAll",
				id = "team"
			}
		}
	},
	{
		type = "zone",
		filter = "Unit",
		typeText = "Units are in a zone",
		text = "[en]<Number> units of <UnitSet> are in <Zone>.[en][fr]<Nombre> d'unités de <Ensemble> sont dans <Zone>.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "numberComparison",
				id = "number",
				hint = "[en]In case of \"Exactly\", \"At least\" or \"At most\" is selected, you can put numbers, variables and operators in editing field (example : \"(var1 + 3) / 2\").[en][fr]Si vous sélectionnez \"Exactement\", \"Au moins\" ou \"Au plus\", vous pouvez indiquer des nombres, des variables et des opérateurs dans le champs de saisie (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "underAttack",
		filter = "Unit",
		typeText = "Units are under attack",
		text = "[en]<Number> units of <UnitSet> are being attacked by <Attacker>.[en][fr]<Nombre> d'unités de <Ensemble> sont attaquées par <Attaquant>.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "numberComparison",
				id = "number",
				hint = "[en]In case of \"Exactly\", \"At least\" or \"At most\" is selected, you can put numbers, variables and operators in editing field (example : \"(var1 + 3) / 2\").[en][fr]Si vous sélectionnez \"Exactement\", \"Au moins\" ou \"Au plus\", vous pouvez indiquer des nombres, des variables et des opérateurs dans le champs de saisie (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Attacker>[en][fr]<Attaquant>[fr]",
				type = "unitset",
				id = "attacker"
			}
		}
	},
	{
		type = "attacking",
		filter = "Unit",
		typeText = "Units are attacking",
		text = "[en]<Number> units of <UnitSet> are attacking <Target>.[en][fr]<Nombre> d'unités de <Ensemble> attaquent <Cible>.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "numberComparison",
				id = "number",
				hint = "[en]In case of \"Exactly\", \"At least\" or \"At most\" is selected, you can put numbers, variables and operators in editing field (example : \"(var1 + 3) / 2\").[en][fr]Si vous sélectionnez \"Exactement\", \"Au moins\" ou \"Au plus\", vous pouvez indiquer des nombres, des variables et des opérateurs dans le champs de saisie (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Target>[en][fr]<Cible>[fr]",
				type = "unitset",
				id = "target"
			}
		}
	},
	{
		type = "dead",
		filter = "Unit",
		typeText = "Units are dead",
		text = "[en]<Number> units of <UnitSet> are dead.[en][fr]<Nombre> d'unités de <Ensemble> sont mortes.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "numberComparison",
				id = "number",
				hint = "[en]In case of \"Exactly\", \"At least\" or \"At most\" is selected, you can put numbers, variables and operators in editing field (example : \"(var1 + 3) / 2\").[en][fr]Si vous sélectionnez \"Exactement\", \"Au moins\" ou \"Au plus\", vous pouvez indiquer des nombres, des variables et des opérateurs dans le champs de saisie (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			}
		}
	},
	{
		type = "kill",
		filter = "Unit",
		typeText = "Units killed specific units",
		text = "[en]<UnitSet> killed <Number> units of <Target>.[en][fr]<Ensemble> a tué <Nombre> unités de <Cible>.[fr]",
		attributes = {
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "numberComparison",
				id = "number",
				hint = "[en]In case of \"Exactly\", \"At least\" or \"At most\" is selected, you can put numbers, variables and operators in editing field (example : \"(var1 + 3) / 2\").[en][fr]Si vous sélectionnez \"Exactement\", \"Au moins\" ou \"Au plus\", vous pouvez indiquer des nombres, des variables et des opérateurs dans le champs de saisie (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<Target>[en][fr]<Cible>[fr]",
				type = "unitset",
				id = "target"
			}
		}
	},
	{
		type = "killed",
		filter = "Unit",
		typeText = "Units have been killed by other units",
		text = "[en]<Number> units of <UnitSet> have been killed by <Attacker>.[en][fr]<Nombre> d'unités de <Ensemble> ont été tuées par <Attaquant>.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "numberComparison",
				id = "number",
				hint = "[en]In case of \"Exactly\", \"At least\" or \"At most\" is selected, you can put numbers, variables and operators in editing field (example : \"(var1 + 3) / 2\").[en][fr]Si vous sélectionnez \"Exactement\", \"Au moins\" ou \"Au plus\", vous pouvez indiquer des nombres, des variables et des opérateurs dans le champs de saisie (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Attacker>[en][fr]<Attaquant>[fr]",
				type = "unitset",
				id = "attacker"
			}
		}
	},
	{
		type = "hp",
		filter = "Unit",
		typeText = "HP of units",
		text = "[en]Hit points of <Number> units of <UnitSet> are <Comparison> <Percentage> %.[en][fr]Les points de vie de <Nombre> unités de <Ensemble> sont <Comparaison> <Pourcentage> %.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "numberComparison",
				id = "number",
				hint = "[en]In case of \"Exactly\", \"At least\" or \"At most\" is selected, you can put numbers, variables and operators in editing field (example : \"(var1 + 3) / 2\").[en][fr]Si vous sélectionnez \"Exactement\", \"Au moins\" ou \"Au plus\", vous pouvez indiquer des nombres, des variables et des opérateurs dans le champs de saisie (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Comparison>[en][fr]<Comparaison>[fr]",
				type = "comparison",
				id = "comparison"
			},
			{
				text = "[en]<Percentage>[en][fr]<Pourcentage>[fr]",
				type = "text",
				id = "hp",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des opérateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "order",
		filter = "Unit",
		typeText = "Units are doing command",
		text = "[en]<Number> units of <UnitSet> are doing <Command>.[en][fr]<Nombre> d'unités de <Ensemble> réalisent <Commande>.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "numberComparison",
				id = "number",
				hint = "[en]In case of \"Exactly\", \"At least\" or \"At most\" is selected, you can put numbers, variables and operators in editing field (example : \"(var1 + 3) / 2\").[en][fr]Si vous sélectionnez \"Exactement\", \"Au moins\" ou \"Au plus\", vous pouvez indiquer des nombres, des variables et des opérateurs dans le champs de saisie (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<Command>[en][fr]<Commande>[fr]",
				type = "command",
				id = "command"
			}
		}
	},
	{
		type = "type",
		filter = "Unit",
		typeText = "Units are of specific type",
		text = "[en]<Number> units of <UnitSet> are of type <UnitType>.[en][fr]<Nombre> d'unités de <Ensemble> sont du type <Type>.[fr]",
		attributes = {
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "numberComparison",
				id = "number",
				hint = "[en]In case of \"Exactly\", \"At least\" or \"At most\" is selected, you can put numbers, variables and operators in editing field (example : \"(var1 + 3) / 2\").[en][fr]Si vous sélectionnez \"Exactement\", \"Au moins\" ou \"Au plus\", vous pouvez indiquer des nombres, des variables et des opérateurs dans le champs de saisie (exemple : \"(var1 + 3) / 2\").[fr]"
			},
			{
				text = "[en]<UnitSet>[en][fr]<Ensemble>[fr]",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "[en]<UnitType>[en][fr]<Type>[fr]",
				type = "unitType",
				id = "type"
			}
		}
	},
	{
		type = "numberVariable",
		filter = "Variable",
		typeText = "Compare the value of a variable",
		text = "[en]<Variable> <Comparison> <Number>.[en][fr]<Variable> <Comparaison> <Nombre>.[fr]",
		attributes = {
			{
				text = "<Variable>",
				type = "numberVariable",
				id = "variable",
				hint = "[en]Variables can be defined by going to the menu available through the event panel.[en][fr]Les variables peuvent être définies à travers le menu accessible sous le panneau de gestion des événements.[fr]"
			},
			{
				text = "[en]<Comparison>[en][fr]<Comparaison>[fr]",
				type = "comparison",
				id = "comparison"
			},
			{
				text = "[en]<Number>[en][fr]<Nombre>[fr]",
				type = "text",
				id = "number",
				hint = "[en]You can put numbers, variables and operators in this field (example: \"(var1 + 3) / 2\").[en][fr]Vous pouvez utiliser des nombres, des variables et des opérateurs dans ce champs (exemple : \"(var1 + 3) / 2\").[fr]"
			}
		}
	},
	{
		type = "booleanVariable",
		filter = "Variable",
		typeText = "Variable is true",
		text = "[en]<Variable> is true.[en][fr]<Variable> est vraie.[fr]",
		attributes = {
			{
				text = "<Variable>",
				type = "booleanVariable",
				id = "variable",
				hint = "[en]Variables can be defined by going to the menu available through the event panel.[en][fr]Les variables peuvent être définies à travers le menu accessible sous le panneau de gestion des événements.[fr]"
			}
		}
	},
	{
		type = "script",
		filter = "Script",
		typeText = "Evaluate custom boolean",
		text = "[en]Evaluate custom boolean returned by LUA script <Script>.[en][fr]Evaluer un booléen retourné par le script LUA <Script>.[fr]",
		attributes = {
			{
				text = "<Script>",
				type = "text",
				id = "script"
			}
		}
	}
}

-- COLOR TEXT
for i, c in ipairs(conditions_list) do
	for ii, attr in ipairs(c.attributes) do
		if textColors[attr.type] then
			for iii, keyword in ipairs(textColors[attr.type].keywords) do
				c.text = string.gsub(c.text, keyword, textColors[attr.type].color..keyword.."\255\255\255\255")
				attr.text = string.gsub(attr.text, keyword, textColors[attr.type].color..keyword.."\255\255\255\255")
			end
		end
	end
end

-- ADD FILTER TO THE NAME
for i, c in ipairs(conditions_list) do
	c.typeText = c.filter.." - "..c.typeText
end