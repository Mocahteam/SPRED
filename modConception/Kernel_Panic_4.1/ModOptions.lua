
-- Caution:  keys must be lower case

local options=
{
	{
		key   = 'kpopt',
		name  = 'Kernel Panic!',
		desc  = 'Kernel Panic only specific options',
		type  = 'section'
	},
	{
		section='kpopt',
		key   = 'metaltogeo',
		name  = 'Datavent spots',
		desc  = 'Where will be the buildable locations?',
		type  = 'list',
		def   = '0',
		items = 
		{
			{
				key  = 'auto',
				name = 'Auto',
				desc = 'Geo if enough, metal otherwise\n',
			},
			{
				key  = 'metal',
				name = 'Metal',
				desc = 'Metal spots turn into buildable geos, geos get removed\n',
			},
			{
				key  = 'geo',
				name = 'Geo',
				desc = 'Only buildable spots are geos\n',
			},
			{
				key  = 'both',
				name = 'Both',
				desc = 'Both geos and metal spots are buildable\n',
			},
		},
	},
	{
		section='kpopt',
		key   = 'ons',
		name  = 'ONS (Shielded gamemode)',
		desc  = 'Protect buildings with invulnerable shields',
		type  = 'list',
		def   = '0',
		items = 
		{
			{
				key  = '0',
				name = 'ONS: Disabled',
				desc = 'No shields.\n',
			},
			{
				key  = '1',
				name = 'ONS: Homebase only',
				desc = 'Homebase shielded as long as one building is up\n',
			},
			{
				key  = '2',
				name = 'ONS: Weak',
				desc = 'Every extremities unshielded\n',
			},
			{
				key  = '3',
				name = 'ONS: Strong',
				desc = 'Furthest extremities unshielded\n',
			},
			{
				key  = '4',
				name = 'ONS: Ultra',
				desc = 'Buildings near enemies buildings unshielded\n',
			},
		},
	},
	{
		section='kpopt',
		key="sos",
		name="Save Our Mem",
		desc="Dead units leave \"memory leaks\" decreasing your amount of \"memory\" every second. You need to reclaim \"unreferenced memory\" by covering it with live units before you run out of \"memory\". Your \"memory\" is divided in \"sectors\", each new buildings give you a \"sector\", each lost building removes one. When a team run out of memory: Positive: Kill all mobile, near-kill all buildings. Negative: Instakills everything.",
		type="number",
		min = -999999,
		max = 999999,
		step = 1024,
		def = 0,
	},
	{
		section='kpopt',
		key="colorwars",
		name="Color Wars",
		desc="(in minutes) The one who controls the more territory when countdown reaches zero wins.",
		type="number",
		min = 0,
		max = 10080,
		step = 1,
		def = 0,
	},

	{
		key   = "homf_sec",
		name  = "Defense of the ENIACs - Heroes of Mainframe!",
		desc  = "Shoot'n'Run!",
		type  = "section"
	},
	{
		section="homf_sec",
		key="preplaced",
		name="Pre-placed Minifacs",
		desc="Start the game with datavents already covered.",
		type="bool",
		def=false
	},
	{
		section="homf_sec",
		key="homf",
		name="Play the Hero, not the General",
		desc="Shoot'n'Run!",
		type="bool",
		def=false
	},
	{
		section="homf_sec",
		key="homf_rightclick",
		name="Hero Right Click",
		desc="In hero mode, still enable controlling the rest of the army with right mouse button",
		type="bool",
		def=true
	},
	{
		section='homf_sec',
		key="homf_speed",
		name="Speed Multiplier",
		desc="How much faster heroes go",
		type="number",
		min = 0.1,
		max = 99,
		step = 0.1,
		def = 2,
	},
	{
		section='homf_sec',
		key="homf_hp",
		name="Health Multiplier",
		desc="How much more hitpoints heroes have",
		type="number",
		min = 1,
		max = 666,
		step = 1,
		def = 20,
	},
	{
		section='homf_sec',
		key="homf_regen",
		name="Regeneration Time",
		desc="How many seconds to fully heal",
		type="number",
		min = -3600,
		max = 3600,
		step = 0.2,
		def = 30,
	},
	{
		section='homf_sec',
		key="homf_dmg",
		name="Damage Multiplier",
		desc="How much stronger are heroes attacks",
		type="number",
		min = 1,
		max = 666,
		step = 0.5,
		def = 10,
	},
	{
		section='homf_sec',
		key="homf_range",
		name="Range Multiplier",
		desc="How much further heroes can hit",
		type="number",
		min = 0.1,
		max = 10,
		step = 0.1,
		def = 1.2,
	},
	{
		section='homf_sec',
		key="homf_impulsefactor",
		name="Impulse Factor",
		desc="Heroes Impulse Factor (gets multiplied by damage)",
		type="number",
		min = 0,
		max = 99,
		step = 0.2,
		def = 3,
	},
	{
		section='homf_sec',
		key="homf_aoe",
		name="Area of effect",
		desc="Heroes Area of effect",
		type="number",
		min = 1,
		max = 666,
		step = 8,
		def = 32,
	},
	{
		section="homf_sec",
		key="homf_hugground",
		name="Hug Ground",
		desc="Do weapon keep on moving or explode when hitting ground",
		type="bool",
		def=true
	},
	{
		section="homf_sec",
		key="homf_collidefriendly",
		name="Collide Friendly",
		desc="Do heroes weapons collide friendly",
		type="bool",
		def=true
	},

	{
		key   = 'evillesssec',
		name  = 'EvilLess!',
		desc  = 'Simplify the game',
		type  = 'section'
	},
	{
		section='evillesssec',
		key="nospecials",
		name="Remove special buildings and abilities",
		desc="\n- Removes SIGTERM, Obelisk, Firewall, ...\n- Removes NX flag, MineLauncher, Exploit, Dispatch from Connection, ...",
		type="bool",
		def=false
	},
	{
		section='evillesssec',
		key="systemonly",
		name="Force all factions to system",
		desc="\nDuring the first frame of the game,\nall HomeBases are turned into Kernels",
		type="bool",
		def=false
	},
--[[
	{
		section='kpopt',
		key="minelauncher",
		name="Div0's byte's minelauncher",
		desc="Enable the byte minelauncher in Division Zero.",
		type="bool",
		def=true
	},
	{
		section='kpopt',
		key="nx",
		name="Div0's pointer's NX flag",
		desc="Enable the pointer NX flag in Division Zero.",
		type="bool",
		def=true
	}
--]]
}
return options
