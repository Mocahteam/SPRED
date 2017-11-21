-- Color used

-- 255255255 => (empty)
-- 255255128 => unitset
-- 255255000 => team and teamWithAll
-- 255128255 => (empty)
-- 255128000 => toggle
-- 255000255 => textSplit
-- 255000128 => comparison
-- 255000000 => position

-- 128255255 => widget
-- 128255128 => condition
-- 128255000 => numberVariable 
-- 128128255 => booleanVariable
-- 128128128 => (empty)
-- 128128000 => zone
-- 128000255 => text
-- 128000128 => numberComparison
-- 128000000 => (empty)

-- 000255255 => boolean
-- 000255128 => (empty)
-- 000255000 => (empty)
-- 000128255 => command
-- 000128128 => group
-- 000128000 => (empty)
-- 000000255 => unitType
-- 000000128 => (empty)
-- 000000000 => (empty)

textColors = {
	unitset = {keywords = {"<UnitSet>", "<Ensemble>", "<Target>", "<Cible>", "<UnitSet1>", "<Ensemble1>", "<UnitSet2>", "<Ensemble2>", "<Attacker>", "<Attaquant>"},
		color = "\255\255\255\128"},
	team = {keywords = {"<Team>", "<Equipe>"},
		color = "\255\255\255\0"},
	teamWithAll = {keywords = {"<Team>", "<Equipe>"},
		color = "\255\255\255\0"},
	toggle = {keywords = {"<State>", "<Etat>"},
		color = "\255\255\128\0"},
	textSplit = {keywords = {"<Parameters>", "<Param�tres>", "<Message>"},
		color = "\255\255\0\255"},
	comparison = {keywords = {"<Comparison>", "<Comparaison>"},
		color = "\255\255\0\128"},
	position = {keywords = {"<Position>"},
		color = "\255\255\0\0"},
		
	widget = {keywords = {"<Widget>"},
		color = "\255\128\255\255"},
	condition = {keywords = {"<Condition>"},
		color = "\255\128\255\128"},
	numberVariable = {keywords = {"<Variable>"},
		color = "\255\128\255\0"},
	booleanVariable = {keywords = {"<Variable>"},
		color = "\255\128\128\255"},
	zone = {keywords = {"<Zone>"},
		color = "\255\128\128\0"},
	text = {keywords = {"<State>", "<Etat>", "<Time>", "<Temps>", "<Trigger>", "<D�clencheur>", "<Number>", "<Nombre>", "<Percentage>", "<Pourcentage>", "<Min>", "<Max>", "<Script>", "<Id>", "<Trace>"},
		color = "\255\128\0\255"},
	numberComparison = {keywords = {"<Number>", "<Nombre>"},
		color = "\255\128\0\128"},
		
	boolean = {keywords = {"<Pause>", "<Boolean>", "<Bool�en>"},
		color = "\255\0\255\255"},
	command = {keywords = {"<Command>", "<Commande>"},
		color = "\255\0\128\255"},
	group = {keywords = {"<Group>", "<Groupe>"},
		color = "\255\0\128\128"},
	unitType = {keywords = {"<UnitType>", "<Type>"},
		color = "\255\0\0\255"},
}

colorTable = { -- associative table between a number and its character
	"\0",
	"\1",
	"\2",
	"\3",
	"\4",
	"\5",
	"\6",
	"\7",
	"\8",
	"\9",
	"\10",
	"\11",
	"\12",
	"\13",
	"\14",
	"\15",
	"\16",
	"\17",
	"\18",
	"\19",
	"\20",
	"\21",
	"\22",
	"\23",
	"\24",
	"\25",
	"\26",
	"\27",
	"\28",
	"\29",
	"\30",
	"\31",
	"\32",
	"\33",
	"\34",
	"\35",
	"\36",
	"\37",
	"\38",
	"\39",
	"\40",
	"\41",
	"\42",
	"\43",
	"\44",
	"\45",
	"\46",
	"\47",
	"\48",
	"\49",
	"\50",
	"\51",
	"\52",
	"\53",
	"\54",
	"\55",
	"\56",
	"\57",
	"\58",
	"\59",
	"\60",
	"\61",
	"\62",
	"\63",
	"\64",
	"\65",
	"\66",
	"\67",
	"\68",
	"\69",
	"\70",
	"\71",
	"\72",
	"\73",
	"\74",
	"\75",
	"\76",
	"\77",
	"\78",
	"\79",
	"\80",
	"\81",
	"\82",
	"\83",
	"\84",
	"\85",
	"\86",
	"\87",
	"\88",
	"\89",
	"\90",
	"\91",
	"\92",
	"\93",
	"\94",
	"\95",
	"\96",
	"\97",
	"\98",
	"\99",
	"\100",
	"\101",
	"\102",
	"\103",
	"\104",
	"\105",
	"\106",
	"\107",
	"\108",
	"\109",
	"\110",
	"\111",
	"\112",
	"\113",
	"\114",
	"\115",
	"\116",
	"\117",
	"\118",
	"\119",
	"\120",
	"\121",
	"\122",
	"\123",
	"\124",
	"\125",
	"\126",
	"\127",
	"\128",
	"\129",
	"\130",
	"\131",
	"\132",
	"\133",
	"\134",
	"\135",
	"\136",
	"\137",
	"\138",
	"\139",
	"\140",
	"\141",
	"\142",
	"\143",
	"\144",
	"\145",
	"\146",
	"\147",
	"\148",
	"\149",
	"\150",
	"\151",
	"\152",
	"\153",
	"\154",
	"\155",
	"\156",
	"\157",
	"\158",
	"\159",
	"\160",
	"\161",
	"\162",
	"\163",
	"\164",
	"\165",
	"\166",
	"\167",
	"\168",
	"\169",
	"\170",
	"\171",
	"\172",
	"\173",
	"\174",
	"\175",
	"\176",
	"\177",
	"\178",
	"\179",
	"\180",
	"\181",
	"\182",
	"\183",
	"\184",
	"\185",
	"\186",
	"\187",
	"\188",
	"\189",
	"\190",
	"\191",
	"\192",
	"\193",
	"\194",
	"\195",
	"\196",
	"\197",
	"\198",
	"\199",
	"\200",
	"\201",
	"\202",
	"\203",
	"\204",
	"\205",
	"\206",
	"\207",
	"\208",
	"\209",
	"\210",
	"\211",
	"\212",
	"\213",
	"\214",
	"\215",
	"\216",
	"\217",
	"\218",
	"\219",
	"\220",
	"\221",
	"\222",
	"\223",
	"\224",
	"\225",
	"\226",
	"\227",
	"\228",
	"\229",
	"\230",
	"\231",
	"\232",
	"\233",
	"\234",
	"\235",
	"\236",
	"\237",
	"\238",
	"\239",
	"\240",
	"\241",
	"\242",
	"\243",
	"\244",
	"\245",
	"\246",
	"\247",
	"\248",
	"\249",
	"\250",
	"\251",
	"\252",
	"\253",
	"\254",
	"\255"
}