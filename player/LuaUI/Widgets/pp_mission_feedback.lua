function widget:GetInfo()
  return {
    name      = "Feedbacks Widget",
    desc      = "Used to display feedbacks to the player during the game",
    author    = "meresse, mocahteam",
    date      = "Jun 20, 2016",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true
  }
end

local json = VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local fontHandler = loadstring(VFS.LoadFile(LUAUI_DIRNAME.."modfonts.lua", VFS.ZIP_FIRST))()

local white = "\255\255\255\255"
local red = "\255\255\0\0"
local green = "\255\0\255\0"
local blue = "\255\0\0\255"

local vsx = 0

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
		s = s.."Votre score : "..color..score.." / 100"..white.."\n"
	end
	if json_obj.num_attempts ~= nil and export_score then
		s = s.."Nombre de de tentative(s) de résolution de la mission : "..json_obj.num_attempts.."\n"
	end
	if json_obj.execution_time ~= nil and export_score then
		s = s.."Temps d'éxecution de ton programme : "..json_obj.execution_time.." s\n"
		s = s.."Temps d'éxecution référence : "..json_obj.ref_execution_time.." s\n"
	end
	if json_obj.exec_mean_wait_time ~= nil and export_score then
		s = s.."Temps d'attente moyen entre deux tentatives : "..json_obj.exec_mean_wait_time.." s\n"
	end
	if json_obj.resolution_time ~= nil and export_score then
		s = s.."Temps de résolution de la mission : "..json_obj.resolution_time.." s\n"
		s = s.."Temps de résolution référence : "..json_obj.ref_resolution_time.." s\n"
	end
	if json_obj.feedbacks ~= nil and #json_obj.feedbacks > 0 then
		if #json_obj.feedbacks == 1 then
			s = s.."\nUn conseil pour améliorer votre programme :\n\n"
		else
			s = s.."\nQuelques conseils pour améliorer votre programme :\n\n"
		end
		for i = 1,#json_obj.feedbacks do
			s = s..color..json_obj.feedbacks[i]..white.."\n"
			if #json_obj.feedbacks > 1 and i < #json_obj.feedbacks then
				s = s.."\n"
			end
		end
	end
	if json_obj.warnings ~= nil and #json_obj.warnings > 0 then
		s = s.."\nAttention :\n\n"
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
	local json_obj = json.decode(str)
	if json_obj.won ~= nil then -- the mission is over
		local state = ""
		if json_obj.won then
			state = "won"
		else
			state = "lost"
		end
		local width = 0.5 * vsx
		local feedback_and_score_string = getFeedbackMessage(json_obj, true)
		feedback_and_score_string = breakLine(feedback_and_score_string,width)
		e = {logicType = "ShowMissionMenu", state = state, feedback = feedback_and_score_string}
	else -- the mission is not over yet
		local width = 0.85 * vsx
		local feedback_only_string = getFeedbackMessage(json_obj, false)
		--feedback_only_string = breakLine(feedback_only_string,width)
		e = {logicType = "ShowMessage", message = feedback_only_string, width = width, pause = true}
	end
	Script.LuaUI.MissionEvent(e) -- registered by pp_mission_gui.lua
end

function widget:Initialize()
	Spring.SetConfigString("Feedbacks Widget", "enabled", 1) -- inform the engine and mission_runner
	widgetHandler:RegisterGlobal("handleFeedback", handleFeedback)
end

function widget:Shutdown()
	Spring.SetConfigString("Feedbacks Widget", "disabled", 1) -- inform the engine and mission_runner
	widgetHandler:DeregisterGlobal("handleFeedback", handleFeedback)
end
