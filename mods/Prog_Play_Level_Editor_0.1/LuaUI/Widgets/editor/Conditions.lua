VFS.Include("LuaUI/Widgets/editor/TextColors.lua")
local lang = Spring.GetModOptions()["language"]

if lang == "fr" then
	conditions_list = {
		{
			type = "start",
			filter = "Partie",
			typeText = "La partie commence",
			text = "Lorsque la partie commence.",
			attributes = {}
		},
		{
			type = "elapsedTime",
			filter = "Partie",
			typeText = "Temps \233coul\233",
			text = "<Nombre> secondes se sont \233coul\233es.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				}
			}
		},
		{
			type = "repeat",
			filter = "Partie",
			typeText = "Periodiquement vrai",
			text = "Vrai toutes les <Nombre> secondes \224 partir du d\233but de la missions.",
			attributes = {
				{
					text = "<Nombre>",
					type = "number",
					id = "number"
				}
			}
		},
		{
			type = "unit_zone",
			filter = "Zone",
			typeText = "L'unit\233 est dans la zone",
			text = "L'unit\233 <Unit\233> est dans <Zone>.",
			attributes = {
				{
					text = "<Unit\233>",
					type = "unit",
					id = "unit"
				},
				{
					text = "<Zone>",
					type = "zone",
					id = "zone"
				}
			}
		},
		{
			type = "team_zone",
			filter = "Zone",
			typeText = "Les unit\233s de l'\233quipe sont dans la zone",
			text = "<Nombre> unit\233s de l'\233quipe <Equipe> sont dans <Zone>.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Equipe>",
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
			type = "group_zone",
			filter = "Zone",
			typeText = "Les unit\233s du groupe sont dans la zone",
			text = "<Nombre> unit\233s du groupe <Groupe> sont dans <Zone>.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Groupe>",
					type = "group",
					id = "Group"
				},
				{
					text = "<Zone>",
					type = "zone",
					id = "zone"
				}
			}
		},
		{
			type = "type_zone",
			filter = "Zone",
			typeText = "Les unit\233s d'un certain type sont dans la zone",
			text = "<Nombre> unit\233s de type <Type> sont dans <Zone>.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Type>",
					type = "unitType",
					id = "unitType"
				},
				{
					text = "<Zone>",
					type = "zone",
					id = "zone"
				}
			}
		},
		{
			type = "unit_underAttack",
			filter = "Attaqu\233",
			typeText = "L'unit\233 est attaqu\233e",
			text = "L'unit\233 <Unit\233> se fait attaquer.",
			attributes = {
				{
					text = "<Unit\233>",
					type = "unit",
					id = "unit"
				}
			}
		},
		{
			type = "team_underAttack",
			filter = "Attaqu\233",
			typeText = "Les unit\233s de l'\233quipe sont attaqu\233es",
			text = "<Nombre> unit\233s de l'\233quipe <Equipe> se font attaquer.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Equipe>",
					type = "team",
					id = "team"
				}
			}
		},
		{
			type = "group_underAttack",
			filter = "Attaqu\233",
			typeText = "Les unit\233s du groupe sont attaqu\233es",
			text = "<Nombre> unit\233s du groupe <Groupe> se font attaquer.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Groupe>",
					type = "group",
					id = "group"
				}
			}
		},
		{
			type = "type_underAttack",
			filter = "Attaqu\233",
			typeText = "Les unit\233s d'un certain type sont attaqu\233es",
			text = "<Nombre> unit\233s de type <Type> se font attaquer.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Type>",
					type = "unitType",
					id = "unitType"
				}
			}
		},
		{
			type = "unit_dead",
			filter = "Mort",
			typeText = "L'unit\233 est morte",
			text = "L'unit\233 <Unit\233> est morte.",
			attributes = {
				{
					text = "<Unit\233>",
					type = "unit",
					id = "unit"
				}
			}
		},
		{
			type = "team_dead",
			filter = "Mort",
			typeText = "Les unit\233s de l'\233quipe sont mortes",
			text = "<Nombre> unit\233s de l'\233quipe <Equipe> sont mortes.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Equipe>",
					type = "team",
					id = "team"
				}
			}
		},
		{
			type = "group_dead",
			filter = "Mort",
			typeText = "Les unit\233s du groupe sont mortes",
			text = "<Nombre> unit\233s du groupe <Groupe> sont mortes.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Groupe>",
					type = "group",
					id = "group"
				}
			}
		},
		{
			type = "type_dead",
			filter = "Mort",
			typeText = "Les unit\233s d'un certain type sont mortes",
			text = "<Nombre> unit\233s de type <Type> sont mortes.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Type>",
					type = "unitType",
					id = "unitType"
				}
			}
		},
		{
			type = "killed",
			filter = "Tuer",
			typeText = "L'\233quipe a tu\233 une certaine unit\233",
			text = "L'\233quipe <Equipe> a tu\233 <Unit\233>.",
			attributes = {
				{
					text = "<Equipe>",
					type = "team",
					id = "team"
				},
				{
					text = "<Unit\233>",
					type = "unit",
					id = "unit"
				}
			}
		},
		{
			type = "killed_unit",
			filter = "Tuer",
			typeText = "L'\233quipe a tu\233 un certain nombre d'unit\233s",
			text = "L'\233quipe <Equipe> a tu\233 <Nombre> unit\233s.",
			attributes = {
				{
					text = "<Equipe>",
					type = "team",
					id = "team"
				},
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				}
			}
		},
		{
			type = "killed_team",
			filter = "Tuer",
			typeText = "L'\233quipe a tu\233 un certain nombre d'unit\233s d'une \233quipe",
			text = "L'\233quipe <Equipe> a tu\233 <Nombre> unit\233s de l'\233quipe <Cible>.",
			attributes = {
				{
					text = "<Equipe>",
					type = "team",
					id = "team"
				},
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Cible>",
					type = "team",
					id = "targetTeam"
				}
			}
		},
		{
			type = "killed_group",
			filter = "Tuer",
			typeText = "L'\233quipe a tu\233 un certain nombre d'unit\233s d'un groupe",
			text = "L'\233quipe <Equipe> a tu\233 <Nombre> unit\233s du groupe <Groupe>.",
			attributes = {
				{
					text = "<Equipe>",
					type = "team",
					id = "team"
				},
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Groupe>",
					type = "group",
					id = "group"
				}
			}
		},
		{
			type = "killed_type",
			filter = "Tuer",
			typeText = "L'\233quipe a tu\233 un certain nombre d'unit\233s d'un certain type",
			text = "L'\233quipe <Equipe> a tu\233 <Nombre> unit\233s de type <Type>.",
			attributes = {
				{
					text = "<Equipe>",
					type = "team",
					id = "team"
				},
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Type>",
					type = "unitType",
					id = "unitType"
				}
			}
		},
		{
			type = "unit_hp",
			filter = "PV",
			typeText = "PV de l'unit\233",
			text = "Les points de vie de l'unit\233 <Unit\233> sont \224 <Pourcentage> %.",
			attributes = {
				{
					text = "<Unit\233>",
					type = "unit",
					id = "unit"
				},
				{
					text = "<Pourcentage>",
					type = "numberComparison",
					id = "hp"
				}
			}
		},
		{
			type = "group_hp",
			filter = "PV",
			typeText = "PV des unit\233s du groupe",
			text = "Les points de vie de <Nombre> unit\233s du groupe <Groupe> sont \224 <Pourcentage> %.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Groupe>",
					type = "group",
					id = "group"
				},
				{
					text = "<Pourcentage>",
					type = "numberComparison",
					id = "hp"
				}
			}
		},
		{
			type = "team_hp",
			filter = "PV",
			typeText = "PV des unit\233s de l'\233quipe",
			text = "Les points de vie de <Nombre> unit\233s de l'\233quipe <Equipe> sont \224 <Pourcentage> %.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Equipe>",
					type = "team",
					id = "team"
				},
				{
					text = "<Pourcentage>",
					type = "numberComparison",
					id = "hp"
				}
			}
		},
		{
			type = "unit_order",
			filter = "Ordre",
			typeText = "L'unit\233 est en train d'effectuer un ordre",
			text = "L'unit\233 <Unit\233> est en train d'effectuer l'ordre <Ordre>.",
			attributes = {
				{
					text = "<Unit\233>",
					type = "unit",
					id = "unit"
				},
				{
					text = "<Ordre>",
					type = "command",
					id = "command"
				}
			}
		},
		{
			type = "group_order",
			filter = "Ordre",
			typeText = "Les unit\233s du groupe sont en train d'effectuer un ordre",
			text = "<Nombre> unit\233s du groupe <Groupe> sont en train d'effectuer l'ordre <Ordre>.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Groupe>",
					type = "group",
					id = "group"
				},
				{
					text = "<Ordre>",
					type = "command",
					id = "command"
				}
			}
		},
		{
			type = "team_order",
			filter = "Ordre",
			typeText = "Les unit\233s de l'\233quipe sont en train d'effectuer un ordre",
			text = "<Nombre> unit\233s de l'\233quipe <Equipe> sont en train d'effectuer l'ordre <Ordre>.",
			attributes = {
				{
					text = "<Nombre>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Equipe>",
					type = "team",
					id = "team"
				},
				{
					text = "<Ordre>",
					type = "command",
					id = "command"
				}
			}
		},
		{
			type = "variableVSnumber",
			filter = "Variable",
			typeText = "Comparaison entre une variable et un nombre.",
			text = "<Variable> est <Comparaison> <Nombre>.",
			attributes = {
				{
					text = "<Variable>",
					type = "numberVariable",
					id = "variable"
				},
				{
					text = "<Comparaison>",
					type = "comparison",
					id = "comparison"
				},
				{
					text = "<Nombre>",
					type = "number",
					id = "number"
				}
			}
		},
		{
			type = "variableVSvariable",
			filter = "Variable",
			typeText = "Comparaison entre deux variables",
			text = "<Variable> est <Comparaison> <Variable>.",
			attributes = {
				{
					text = "<Variable>",
					type = "numberVariable",
					id = "variable1"
				},
				{
					text = "<Comparaison>",
					type = "comparison",
					id = "comparison"
				},
				{
					text = "<Variable>",
					type = "numberVariable",
					id = "variable2"
				}
			}
		},
		{
			type = "booleanVariable",
			filter = "Variable",
			typeText = "Variable est vraie",
			text = "<Variable> est vraie.",
			attributes = {
				{
					text = "<Variable>",
					type = "booleanVariable",
					id = "variable"
				}
			}
		},
	{
		type = "script",
		filter = "Script",
		typeText = "Evaluer booléen personnalisé",
		text = "Evaluer un booléen personnalisé retourné par le script LUA <Script>.",
		attributes = {
			{
				text = "<Script>",
				type = "text",
				id = "script"
			}
		}
	}
	}
else
	conditions_list = {
		{
			type = "start",
			filter = "Game",
			typeText = "Game start",
			text = "When game starts.",
			attributes = {}
		},
		{
			type = "elapsedTime",
			filter = "Game",
			typeText = "Time elapsed",
			text = "<Number> seconds have elapsed.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				}
			}
		},
		{
			type = "repeat",
			filter = "Game",
			typeText = "Periodically true",
			text = "True every <Number> seconds from the begining of the mission.",
			attributes = {
				{
					text = "<Number>",
					type = "number",
					id = "number"
				}
			}
		},
		{
			type = "unit_zone",
			filter = "Zone",
			typeText = "Unit is in a zone",
			text = "<Unit> is in <Zone>.",
			attributes = {
				{
					text = "<Unit>",
					type = "unit",
					id = "unit"
				},
				{
					text = "<Zone>",
					type = "zone",
					id = "zone"
				}
			}
		},
		{
			type = "team_zone",
			filter = "Zone",
			typeText = "Units of team are in a zone",
			text = "<Number> units of <Team> are in <Zone>.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Team>",
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
			type = "group_zone",
			filter = "Zone",
			typeText = "Units of group are in a zone",
			text = "<Number> units of <Group> are in <Zone>.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Group>",
					type = "group",
					id = "Group"
				},
				{
					text = "<Zone>",
					type = "zone",
					id = "zone"
				}
			}
		},
		{
			type = "type_zone",
			filter = "Zone",
			typeText = "Units of specific type are in a zone",
			text = "<Number> units of type <UnitType> are in <Zone>.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<UnitType>",
					type = "unitType",
					id = "unitType"
				},
				{
					text = "<Zone>",
					type = "zone",
					id = "zone"
				}
			}
		},
		{
			type = "unit_underAttack",
			filter = "Attacked",
			typeText = "Unit is under attack",
			text = "<Unit> is under attack.",
			attributes = {
				{
					text = "<Unit>",
					type = "unit",
					id = "unit"
				}
			}
		},
		{
			type = "team_underAttack",
			filter = "Attacked",
			typeText = "Units of team are under attack",
			text = "<Number> units of <Team> are under attack.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Team>",
					type = "team",
					id = "team"
				}
			}
		},
		{
			type = "group_underAttack",
			filter = "Attacked",
			typeText = "Units of group are under attack",
			text = "<Number> units of <Group> are under attack.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Group>",
					type = "group",
					id = "group"
				}
			}
		},
		{
			type = "type_underAttack",
			filter = "Attacked",
			typeText = "Units of specific type are under attack",
			text = "<Number> units of type <UnitType> are under attack.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<UnitType>",
					type = "unitType",
					id = "unitType"
				}
			}
		},
		{
			type = "unit_dead",
			filter = "Dead",
			typeText = "Unit is dead",
			text = "<Unit> is dead.",
			attributes = {
				{
					text = "<Unit>",
					type = "unit",
					id = "unit"
				}
			}
		},
		{
			type = "team_dead",
			filter = "Dead",
			typeText = "Units of team are dead",
			text = "<Number> units of <Team> are dead.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Team>",
					type = "team",
					id = "team"
				}
			}
		},
		{
			type = "group_dead",
			filter = "Dead",
			typeText = "Units of group are dead",
			text = "<Number> units of <Group> are dead.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Group>",
					type = "group",
					id = "group"
				}
			}
		},
		{
			type = "type_dead",
			filter = "Dead",
			typeText = "Units of specific type are dead",
			text = "<Number> units of type <UnitType> are dead.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<UnitType>",
					type = "unitType",
					id = "unitType"
				}
			}
		},
		{
			type = "killed",
			filter = "Kill",
			typeText = "Team killed specific unit",
			text = "<Team> killed <Unit>.",
			attributes = {
				{
					text = "<Team>",
					type = "team",
					id = "team"
				},
				{
					text = "<Unit>",
					type = "unit",
					id = "unit"
				}
			}
		},
		{
			type = "killed_unit",
			filter = "Kill",
			typeText = "Team killed units",
			text = "<Team> killed <Number> units.",
			attributes = {
				{
					text = "<Team>",
					type = "team",
					id = "team"
				},
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				}
			}
		},
		{
			type = "killed_team",
			filter = "Kill",
			typeText = "Team killed units of target team",
			text = "<Team> killed <Number> units of <TargetTeam>.",
			attributes = {
				{
					text = "<Team>",
					type = "team",
					id = "team"
				},
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<TargetTeam>",
					type = "team",
					id = "targetTeam"
				}
			}
		},
		{
			type = "killed_group",
			filter = "Kill",
			typeText = "Team killed units of group",
			text = "<Team> killed <Number> units of <Group>.",
			attributes = {
				{
					text = "<Team>",
					type = "team",
					id = "team"
				},
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Group>",
					type = "group",
					id = "group"
				}
			}
		},
		{
			type = "killed_type",
			filter = "Kill",
			typeText = "Team killed units of specific type",
			text = "<Team> killed <Number> units of type <UnitType>.",
			attributes = {
				{
					text = "<Team>",
					type = "team",
					id = "team"
				},
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<UnitType>",
					type = "unitType",
					id = "unitType"
				}
			}
		},
		{
			type = "unit_hp",
			filter = "HP",
			typeText = "HP of unit",
			text = "Hit points of <Unit> are at <Percentage> %.",
			attributes = {
				{
					text = "<Unit>",
					type = "unit",
					id = "unit"
				},
				{
					text = "<Percentage>",
					type = "numberComparison",
					id = "hp"
				}
			}
		},
		{
			type = "group_hp",
			filter = "HP",
			typeText = "HP of units of group",
			text = "Hit points of <Number> units of <Group> are at <Percentage> %.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Group>",
					type = "group",
					id = "group"
				},
				{
					text = "<Percentage>",
					type = "numberComparison",
					id = "hp"
				}
			}
		},
		{
			type = "team_hp",
			filter = "HP",
			typeText = "HP of units of team",
			text = "Hit points of <Number> units of <Team> are at <Percentage> %.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Team>",
					type = "team",
					id = "team"
				},
				{
					text = "<Percentage>",
					type = "numberComparison",
					id = "hp"
				}
			}
		},
		{
			type = "unit_order",
			filter = "Order",
			typeText = "Unit is doing command",
			text = "<Unit> is doing <Command>.",
			attributes = {
				{
					text = "<Unit>",
					type = "unit",
					id = "unit"
				},
				{
					text = "<Command>",
					type = "command",
					id = "command"
				}
			}
		},
		{
			type = "group_order",
			filter = "Order",
			typeText = "Units of group are doing command",
			text = "<Number> units of <Group> are doing <Command>.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Group>",
					type = "group",
					id = "group"
				},
				{
					text = "<Command>",
					type = "command",
					id = "command"
				}
			}
		},
		{
			type = "team_order",
			filter = "Order",
			typeText = "Units of team are doing command",
			text = "<Number> units of <Team> are doing <Command>.",
			attributes = {
				{
					text = "<Number>",
					type = "numberComparison",
					id = "number"
				},
				{
					text = "<Team>",
					type = "team",
					id = "team"
				},
				{
					text = "<Command>",
					type = "command",
					id = "command"
				}
			}
		},
		{
			type = "variableVSnumber",
			filter = "Variable",
			typeText = "Comparison between variable and number",
			text = "<Variable> is <Comparison> <Number>.",
			attributes = {
				{
					text = "<Variable>",
					type = "numberVariable",
					id = "variable"
				},
				{
					text = "<Comparison>",
					type = "comparison",
					id = "comparison"
				},
				{
					text = "<Number>",
					type = "number",
					id = "number"
				}
			}
		},
		{
			type = "variableVSvariable",
			filter = "Variable",
			typeText = "Comparison between two variables",
			text = "<Variable> is <Comparison> <Variable>.",
			attributes = {
				{
					text = "<Variable>",
					type = "numberVariable",
					id = "variable1"
				},
				{
					text = "<Comparison>",
					type = "comparison",
					id = "comparison"
				},
				{
					text = "<Variable>",
					type = "numberVariable",
					id = "variable2"
				}
			}
		},
		{
			type = "booleanVariable",
			filter = "Variable",
			typeText = "Variable is true",
			text = "<Variable> is true.",
			attributes = {
				{
					text = "<Variable>",
					type = "booleanVariable",
					id = "variable"
				}
			}
		}
	},
	{
		type = "script",
		filter = "Script",
		typeText = "Evaluate custom boolean",
		text = "Evaluate custom boolean returned by LUA script <Script>.",
		attributes = {
			{
				text = "<Script>",
				type = "text",
				id = "script"
			}
		}
	}
end

-- COLOR TEXT
for i, c in ipairs(conditions_list) do
	for ii, attr in ipairs(c.attributes) do
		if textColors[attr.type] then
			c.text = string.gsub(c.text, attr.text, textColors[attr.type]..attr.text.."\255\255\255\255")
			attr.text = textColors[attr.type]..attr.text
		end
	end
end

-- ADD FILTER TO THE NAME
for i, c in ipairs(conditions_list) do
	c.typeText = c.filter.." - "..c.typeText
end