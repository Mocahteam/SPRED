function widget:GetInfo()
  return {
    name      = "PP Show Feedbacks",
    desc      = "Used to display feedbacks to the player during the game and add help button in UI",
    author    = "meresse, mocahteam",
    date      = "Jun 20, 2016",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true
  }
end

local json = VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local fontHandler = loadstring(VFS.LoadFile(LUAUI_DIRNAME.."modfonts.lua", VFS.ZIP_FIRST))()
local lang = Spring.GetModOptions()["language"] -- get the language
local LANG_SCORE = "Your score: "
local LANG_TENTATIVE = "Number of attempts to resolve the mission: "
local LANG_PROGRAM_EXECUTION = "Program execution time: "
local LANG_PROGRAM_REFERENCE = "Reference execution time: "
local LANG_AVERAGE_TIME = "Average wait time between two attempts: "
local LANG_MISSION_TIME = "Mission resolution time: "
local LANG_REFERENCE_TIME = "Reference resolution time: "
local LANG_ONE_ADVICE = "Help: "
local LANG_SEVERAL_ADVICE = "Advices to improve the program: "
local LANG_WARNING = "Warning: "
if lang == "fr" then
	LANG_SCORE = "Votre score : "
	LANG_TENTATIVE = "Nombre de tentative(s) de résolution de la mission : "
	LANG_PROGRAM_EXECUTION = "Temps d'éxecution de ton programme : "
	LANG_PROGRAM_REFERENCE = "Temps d'éxecution référence : "
	LANG_AVERAGE_TIME = "Temps d'attente moyen entre deux tentatives : "
	LANG_MISSION_TIME = "Temps de résolution de la mission : "
	LANG_REFERENCE_TIME = "Temps de résolution référence : "
	LANG_ONE_ADVICE = "Aide : "
	LANG_SEVERAL_ADVICE = "Quelques conseils pour améliorer votre programme : "
	LANG_WARNING = "Attention : "
end

local white = "\255\255\255\255"
local red = "\255\255\0\0"
local green = "\255\0\255\0"
local blue = "\255\0\0\255"

local vsx = 0

local traceOn = Spring.GetModOptions()["activetraces"] ~= nil and Spring.GetModOptions()["activetraces"] == "1"

local HelpButton = nil -- the button to ask an help notification

function widget:DrawScreenEffects(dse_vsx, dse_vsy)
	vsx = dse_vsx
end

function splitLine(line, sep)
    if div == '' then return line end
    local pos, arr = 1, {}
    for s, e in function() return string.find(line,sep,pos,true) end do
        table.insert(arr,string.sub(line,pos,s-1))
        pos = e + 1
    end
    table.insert(arr,string.sub(line,pos))
    return arr
end

-- breaks line to avoid text running off screen
function breakLine(line, maxWidth)
	local arr = splitLine(line," ")
	local res = {}
	local j = 1
	while j <= table.getn(arr) do
		local l = ""
		while j <= table.getn(arr) and fontHandler.GetTextWidth(fontHandler.StripColors(l), fontHandler.GetFontSize()) <= maxWidth do
			local ind_s = string.find(arr[j],"\n")
			if ind_s then
				local ftok = string.sub(arr[j],1,ind_s-1)
				local stok = string.sub(arr[j],ind_s+1)
				l = l..ftok
				table.remove(arr,j)
				if stok ~= "" then
					table.insert(arr,j,stok)
				end
				break
			else
				l = l..arr[j].." "
				j = j + 1
			end
		end
		table.insert(res,l)
	end
    return table.concat(res,"\n")
end

function getFeedbackMessage(json_obj, export_score)
	local s = ""
	local color = ""
	if json_obj.score ~= nil and export_score then
		local score = json_obj.score
		Spring.SetConfigString("score", score, 1) -- save the value for the engine
		if score < 25 then
			color = red
		elseif score >= 25 and score < 75 then
			color = blue
		else
			color = green
		end
		s = s..LANG_SCORE..color..score.." / 100"..white.."\n"
	end
	if json_obj.num_attempts ~= nil and export_score then
		s = s..LANG_TENTATIVE..json_obj.num_attempts.."\n"
	end
	-- if json_obj.execution_time ~= nil and export_score then
		-- s = s..LANG_PROGRAM_EXECUTION..json_obj.execution_time.." s\n"
		-- s = s..LANG_PROGRAM_REFERENCE..json_obj.ref_execution_time.." s\n"
	-- end
	-- if json_obj.exec_mean_wait_time ~= nil and export_score then
		-- s = s..LANG_AVERAGE_TIME..json_obj.exec_mean_wait_time.." s\n"
	-- end
	-- if json_obj.resolution_time ~= nil and export_score then
		-- s = s..LANG_MISSION_TIME..json_obj.resolution_time.." s\n"
		-- s = s..LANG_REFERENCE_TIME..json_obj.ref_resolution_time.." s\n"
	-- end
	if json_obj.feedbacks ~= nil and #json_obj.feedbacks > 0 then
		if #json_obj.feedbacks == 1 then
			s = s.."\n"..LANG_ONE_ADVICE.."\n\n"
		else
			s = s.."\n"..LANG_SEVERAL_ADVICE.."\n\n"
		end
		for i = 1,#json_obj.feedbacks do
			s = s..color..json_obj.feedbacks[i]..white.."\n"
			if #json_obj.feedbacks > 1 and i < #json_obj.feedbacks then
				s = s.."\n"
			end
		end
	end
	if json_obj.warnings ~= nil and #json_obj.warnings > 0 then
		s = s.."\n"..LANG_WARNING.."\n\n"
		for i = 1,#json_obj.warnings do
			s = s..red..json_obj.warnings[i]..white.."\n"
			if #json_obj.warnings > 1 and i < #json_obj.warnings then
				s = s.."\n"
			end
		end
	end
	return s
end

function handleFeedback(str)
	-- check if the feedback is consistent
	if str == "" or str == "{}" then
		e = {logicType = "UpdateFeedback", feedback = ""}
	else
		local json_obj = json.decode(str)
		if json_obj.won ~= nil then -- the mission is over
			local width = 0.5 * vsx
			local feedback_and_score_string = getFeedbackMessage(json_obj, true)
			feedback_and_score_string = breakLine(feedback_and_score_string,width)
			e = {logicType = "UpdateFeedback", feedback = feedback_and_score_string}
		else -- the mission is not over yet
			local width = 0.85 * vsx
			local feedback_only_string = getFeedbackMessage(json_obj, false)
			feedback_only_string = breakLine(feedback_only_string,width)
			e = {logicType = "ShowMessage", message = feedback_only_string, width = width, pause = false}
		end
	end
	Script.LuaUI.MissionEvent(e) -- registered by pp_gui_main_menu.lua
end

function askHelp()
	Spring.SetConfigString("helpPlease", "enabled", 1) -- inform the game engine that we want a feedback
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("handleFeedback", handleFeedback)
	
	if traceOn then -- Traces are on => we display the button
		if (not WG.Chili) then -- If the chili widget is not found, remove this widget
			Spring.Echo("PP Mission Tester: Chili is not defined, remove himself")
			return
		end

		local helpLabel
		if Spring.GetModOptions()["language"] == "en" then
			helpLabel = "Help"
		else
			helpLabel = "Aide"
		end
		
		HelpButton = WG.Chili.Button:New{
			parent = WG.Chili.Screen0,
			x = "85%",
			y = "0%",
			width = "15%",
			height = "5%",
			caption = helpLabel,
			OnClick = { askHelp },
			font = {
				font = "LuaUI/Fonts/Asimov.otf",
				size = 30,
				autoAdjust = true,
				maxSize = 30,
				color = { 0.2, 1, 0.8, 1 }
			}
		}
	end
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("handleFeedback", handleFeedback)
	
	if HelpButton then
		HelpButton:Dispose()
	end
end
