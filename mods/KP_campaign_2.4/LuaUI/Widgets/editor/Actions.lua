local r = "\255\255\0\0"
local g = "\255\0\255\0"
local b = "\255\0\0\255"
local y = "\255\255\255\0"
local w = "\255\255\255\255"
actions_list = {
	{
		type = "createUnitAtPosition",
		filter = "Unit",
		typeText = "Create Unit at Position",
		text = "Create unit of type "..r.."<UnitType>"..w.." for "..g.."<Team>"..w.." at "..b.."<Position>",
		attributes = {
			{
				text = r.."<UnitType>",
				type = "unitType",
				id = "unitType"
			},
			{
				text = g.."<Team>",
				type = "team",
				id = "team"
			},
			{
				text = b.."<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "moveUnitToPosition",
		filter = "Unit",
		typeText = "Move Unit to Position",
		text = "Move "..y.."<Unit>"..w.." to "..b.."<Position>",
		attributes = {
			{
				text = y.."<Unit>",
				type = "unit",
				id = "unit"
			},
			{
				text = b.."<Position>",
				type = "position",
				id = "position"
			}
		}
	}
}