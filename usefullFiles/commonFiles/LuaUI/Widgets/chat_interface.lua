function widget:GetInfo()
	return {
		name = "Chat",
		desc = "Chat between users",
		author = "lorthioir, muratet",
		date = "June 29, 2017",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true
	}
end

local Chili, Screen0
local textBox, editBox
local history = {}
local position = 1
local window = nil

local colorTable = { -- associative table between a number and its character
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


function initChili() -- Initialize Chili variables
	
	if (not WG.Chili) then -- If the widget is not loaded, we try to load it
		widgetHandler:EnableWidget("Chili Framework")
	end
	if (not WG.Chili) then -- If the widget is still not loaded, we disable this widget
		widgetHandler:RemoveWidget()
	else
		-- Get ready to use Chili
		Chili = WG.Chili
		Screen0 = Chili.Screen0
	end
end


function sendText()
	if editBox.text and editBox.text ~= "" then
		table.insert(history, editBox.text)
		position = #history+1
		teamOnTwoDigit = ""
		if Spring.GetMyTeamID() < 10 then
			teamOnTwoDigit = "0"..Spring.GetMyTeamID()
		else
			teamOnTwoDigit = Spring.GetMyTeamID()
		end
		local playersInfo = Spring.GetPlayerRoster()
		for id,playerInfo in ipairs(playersInfo) do
			-- playerInfo[1] => name
			-- playerInfo[2] => playerID
			-- playerInfo[3] => teamID
			-- playerInfo[4] => ... (see Spring documentation)
			if (type(playerInfo) == "table" and playerInfo[2] == Spring.GetMyPlayerID()) then
				Spring.SendLuaRulesMsg ("CHATMSG"..teamOnTwoDigit..playerInfo[1]..": "..editBox.text)
				editBox:SetText("")		
			end
		end
	end
end


function NewChatMsg(newMsg, teamID)
	-- get team color
	r, g, b, a = Spring.GetTeamColor(teamID)
	-- add message to UI
	textBox:SetText(textBox.text.."\255"..colorTable[math.floor(254*r)+1]..colorTable[math.floor(254*g)+1]..colorTable[math.floor(254*b)+1]..newMsg.."\255\255\255\255\n")
	scrollPanel.scrollPosY = scrollPanel.contentArea[4]
	scrollPanel:InvalidateSelf()
	-- trace this message
	if Script.LuaUI.TraceAction then
		Script.LuaUI.TraceAction("chat_msg "..newMsg) -- registered by pp_meta_trace_manager.lua
	end
end


function widget:Initialize()
	initChili()
	
	if Chili ~= nil then
		window = Chili.Window:New{parent = Screen0, x='0%', y='70%', width='30%', height='30%'}
		
		scrollPanel = Chili.ScrollPanel:New{parent = window, x='0%', y='0%', width='100%', height='82%'}
    
		textBox = Chili.TextBox:New{parent = scrollPanel, x='0%', y='0%', width='100%', height='100%', text=""}
		textBox.font.shadow = false
		
		editBox = Chili.EditBox:New{parent = window, x='0%', y='85%', width='100%', height='15%'}
		editBox.OnKeyPress = {
			function (self, key)	
			
				if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
					sendText()
				end
				if key == Spring.GetKeyCode("up") then
					if position > 1 then
						position = position - 1
						editBox:SetText(history[position])
					end
				end
				if key == Spring.GetKeyCode("down") then
					if position < #history then
						position = position + 1
						editBox:SetText(history[position])
					end
				end
				
			end
		}
		
		-- Add black filter
		Chili.Image:New {
			parent = window,
			x = "0%",
			y = "0%",
			width = "100%",
			height = "82%",
			file = "bitmaps/editor/blank.png",
			keepAspect = false,
			color = {0, 0, 0, 0.8}
		}
	end
	
	widgetHandler:RegisterGlobal("NewChatMsg", NewChatMsg)
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("NewChatMsg")
	if window ~= nil then
		window:Dispose()
		window = nil
	end
end
	
	
function widget:KeyPress(key, mods)
	if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
		Screen0:FocusControl(editBox)
		return true
	end
end
