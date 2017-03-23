function widget:GetInfo()
	return {
		name = "Set Spring-wide settings and Lua WhiteList",
		desc = "Reset settings and widgets to fit Kernel Panic",
		author = "zwzsg",
		date = "March 5th, 2009",
		license = "Public Domain",
		layer = 5,
		enabled = true,
		handler = true, -- Give the widget power to disable self definitively
	}
end

local function WidgetWhiteList()
	Spring.Echo("Enable some widgets")
	for n,w in pairs(widgetHandler.knownWidgets) do
		-- External widgets
		if n=="AdvPlayersList"
		or n=="Autoquit"
		or n=="CustomFormations2"
		or n=="Don't Move Everything"
		or n=="HealthBars"
		or n=="HighlightSelectedUnits" 
		or n=="Select n Center!"
		or n=="Start Point Remover"
		or n=="MiniMap Start Boxes"
		or n=="Action Finder" 
		or n=="Music"
		-- Internal widgets
		or n=="Write GameState"
		or n=="Heroes Right Click"
		or n=="Hide commands"
		or n=="Keep Morpheds Selected"
		or n=="Kernel Panic Automatic Tip Dispenser"
		or n=="Kernel Panic autospam"
		or n=="Kernel Panic Build Bar"
		or n=="Kernel Panic Console Commands"
		or n=="Kernel Panic Default Commands"
		or n=="Kernel Panic Hotkeys"
		or n=="Kernel Panic Geos Highlight"
		or n=="Kernel Panic Mission Briefing"
		or n=="Kernel Panic O.N.S. help tips"
		or n=="Spring Direct Launch 2"
		or n=="Kernel Panic Tooltip"
		or n=="Kernel Panic MidKnight's tooltip background" 
		or n=="noResBar NoMoveWarnings" then
			widgetHandler:EnableWidget(n)
		else
			widgetHandler:DisableWidget(n)
		end
	end
end

function widget:Initialize()
	WidgetWhiteList()
	local HasRanOnce=Spring.GetConfigInt("KPHasForceSettingRanOnce")
	if (HasRanOnce or 0)~=0 then -- if hasn't run once, then the gadget LuaUI_force.lua will do it after asking
		Spring.SendCommands({"movewarnings 0","buildwarnings 0"})
		Spring.SendCommands({"volume 100"})
		--Spring.SetConfigInt("AdvUnitShading",0)
		Spring.SetConfigInt("MoveWarnings",0)
		Spring.SetConfigInt("BuildWarnings",0)
		Spring.SetConfigInt("LuaAutoModWidgets",1)
		Spring.SetConfigInt("LuaModUICtrl",1)
		Spring.SetConfigInt("LuaUI",1)
		Spring.SetConfigInt("GroundDecals",1)
		Spring.SetConfigInt("CamMode",1)
		Spring.SetConfigInt("CrossSize",6)
		Spring.SetConfigInt("DynamicSky",0)
		Spring.SetConfigInt("AdvSky",0)
		Spring.SetConfigInt("UnitIconDist",500)
		Spring.SetConfigInt("UnitLodDist",500)
		Spring.SetConfigInt("SoundVolume",100)
		Spring.SetConfigInt("UnitReplyVolume",150)
		Spring.SetConfigInt("UnitReplySoundVolume",150)
		Spring.SetConfigInt("MaxSounds",96)
		Spring.SetConfigInt("snd_general",100)
		Spring.SetConfigInt("snd_volbattle",100)
		Spring.SetConfigInt("snd_volmaster",100)
		Spring.SetConfigInt("snd_volui",100)
		Spring.SetConfigInt("snd_volunitreply",100)
		Spring.SetConfigInt("MouseDragScrollThreshold",0)
		Spring.Echo("Spring settings changed to fit K.P. taking effect next game")
		-- Spring.Echo("Exiting Spring now, for changes to take effect")
		-- Spring.SendCommands("quit")
		-- Spring.SendCommands("quitforce")
	end
	widgetHandler:DisableWidget(self:GetInfo().name)
end
