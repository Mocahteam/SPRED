conditions_list = {
	{
		type = "start",
		filter = "Game",
		typeText = "Game start",
		text = "When game starts",
		attributes = {}
	},
	{
		type = "unitEntersZone",
		filter = "Unit",
		typeText = "Unit enters Zone",
		text = "<Unit> enters <Zone>",
		attributes = {
			{
				text = "<Unit>",
				type = "unit"
			},
			{
				text = "<Zone>",
				type = "zone"
			}
		}
	}
}