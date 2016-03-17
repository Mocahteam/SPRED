conditions_list = {
	{
		type = "start",
		filter = "game"
		typeText = "Game start",
		text = "When game starts",
		attributes = {}
	},
	{
		type = "unitEntersZone",
		filter = "unit"
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