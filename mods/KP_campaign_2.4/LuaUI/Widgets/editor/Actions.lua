actions_list = {
	{
		type = "createUnitAtPosition",
		typeText = "Create Unit at Position",
		text = "Create unit of type <UnitType> for <Team> at <Position>",
		attributes = {
			{
				text = "<UnitType>",
				type = "unitType"
			},
			{
				text = "<Team>",
				type = "team"
			},
			{
				text = "<Position>",
				type = "position"
			}
		}
	},
	{
		type = "moveUnitToPosition",
		typeText = "Move Unit to Position",
		text = "Move <Unit> to <Position>",
		attributes = {
			{
				text = "<Unit>",
				type = "unit"
			},
			{
				text = "<Position>",
				type = "position"
			}
		}
	}
}