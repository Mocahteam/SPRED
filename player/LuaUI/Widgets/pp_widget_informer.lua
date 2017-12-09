function widget:GetInfo()
  return {
    name      = "PP Widget Informer",
    desc      = "Used to inform about states of widgets",
    author    = "meresse, muratet, mocahteam",
    date      = "Jun 20, 2016",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true,
	handler   = true
  }
end

local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")

function AskWidgetState (widgetName, idCond)
	local valsToSend={}
	valsToSend["widgetName"] = widgetName
	valsToSend["state"] = widgetHandler.knownWidgets and widgetHandler.knownWidgets[widgetName] and widgetHandler.knownWidgets[widgetName].active
	valsToSend["teamId"] = Spring.GetMyTeamID()
	valsToSend["idCond"] = idCond -- pingpong the value
	Spring.SendLuaRulesMsg("WidgetStateResult"..json.encode(valsToSend)) -- processed in MissionPlayer_Editor.lua
end

function widget:Initialize()
	widgetHandler:RegisterGlobal(widget, "AskWidgetState", AskWidgetState) -- first parameters due to handler = true in GetInfo()
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal(widget, "AskWidgetState") -- first parameters due to handler = true in GetInfo()
end
