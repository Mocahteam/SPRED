-- $Id: mission_gui.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Mission GUI",
    desc      = "Turning this off might disrupt the mission.",
    author    = "quantum, muratet",
    date      = "Jul 15, 2012",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true, --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- You must import the KEYSYM table if you want to access keys by name
include('keysym.h.lua')

VFS.Include ("LuaUI/Widgets/libs/RestartScript.lua") -- contain DoTheRestart function

local campaign = VFS.Include ("campaign.lua") -- the default campaign of Prog&Play
local lang = Spring.GetModOptions()["language"] -- get the language
local scenarioType = Spring.GetModOptions()["scenario"] -- get the type of scenario
local missionName = Spring.GetModOptions()["missionname"] -- get the name of the current mission

local rooms = WG.rooms -- availabe in all widgets
local Window = rooms.Window
local Tab = rooms.Tab

-- Set label
local previousMission = "Previous mission"
local replayMission = "Replay mission"
local nextMission = "Next mission"
local quitGame = "Quit the game"
local quitMission = "Quit the mission"
local closeMenu = "Close menu"
local showBriefing = "Show briefing"
local victory = "You won the mission"
local victoryCampaign = "Congratulations !!! You complete the campaign"
local loss = "You lost the mission"
if lang == "fr" then
	previousMission = "Mission précédente"
	replayMission = "Rejouer mission"
	nextMission = "Mission suivante"
	quitGame = "Quitter le jeu"
	quitMission = "Quitter la mission"
	closeMenu = "Fermer menu"
	showBriefing = "Voir briefing"
	victory = "Vous avez gagné la mission"
	victoryCampaign = "Félicitations !!! Vous avez terminé la campagne"
	loss = "Vous avez perdu la mission"
end

-- Defines a template window for the end mission menu
local template_endMission = {
	lineArray = {""},
	closed = true,
	noMove = true,
	--noAnimation = true,
	tabs = {
		-- The previousMission tab
		{preset = function(tab)
				-- By default this tab is disable, activation depend on mission events (see MissionEvent function)
				tab.title = "\255\50\50\50"..previousMission.."\255\255\255\255"
				tab.isAboveColors = {
										bottomLeft  = {0.3, 0.3, 0.3, 0.3},
										topLeft     = {0.3, 0.3, 0.3, 0.3},
										topRight    = {0.3, 0.3, 0.3, 0.3},
										bottomRight = {0.3, 0.3, 0.3, 0.3}
									}
				tab.topLeftColor     = {0.3, 0.3, 0.3, 0.3}
				tab.topRightColor    = {0.3, 0.3, 0.3, 0.3}
				tab.bottomLeftColor  = {0.3, 0.3, 0.3, 0.3}
				tab.bottomRightColor = {0.3, 0.3, 0.3, 0.3}
				tab.position = "bottom"
			end
		},
		-- The replayMission tab
		{preset = function(tab)
				tab.title = replayMission
				tab.position = "bottom"
				tab.OnClick = function()
					tab.parent:Close()
					Script.LuaUI.TraceAction("replay "..missionName.."\n")
					DoTheRestart("Missions/"..Game.modShortName.."/"..missionName..".txt", lang, scenarioType)
				end
			end
		},
		-- The nextMission tab
		{preset = function(tab)
				-- By default this tab is disable, activation depend on mission events (see MissionEvent function)
				tab.title = "\255\50\50\50"..nextMission.."\255\255\255\255"
				tab.isAboveColors = {
										bottomLeft  = {0.3, 0.3, 0.3, 0.3},
										topLeft     = {0.3, 0.3, 0.3, 0.3},
										topRight    = {0.3, 0.3, 0.3, 0.3},
										bottomRight = {0.3, 0.3, 0.3, 0.3}
									}
				tab.topLeftColor     = {0.3, 0.3, 0.3, 0.3}
				tab.topRightColor    = {0.3, 0.3, 0.3, 0.3}
				tab.bottomLeftColor  = {0.3, 0.3, 0.3, 0.3}
				tab.bottomRightColor = {0.3, 0.3, 0.3, 0.3}
				tab.position = "bottom"
			end
		},
		-- The quitGame tab
		{preset = function(tab)
				tab.title = quitGame
				tab.position = "right"
				tab.OnClick = function()
					tab.parent:Close()
					Script.LuaUI.TraceAction("quit_game\n")
					Spring.SendCommands("quitforce")
				end
			end
		},
		-- The quitMission tab
		{preset = function(tab)
				tab.title = quitMission
				tab.position = "right"
				tab.OnClick = function()
					tab.parent:Close()
					Script.LuaUI.TraceAction("quit "..missionName.."\n")
					WG.switchOnMenu()
				end
			end
		},
		-- The closeMenu tab
		{preset = function(tab)
				tab.title = closeMenu
				tab.position = "right"
				tab.OnClick = function()
					tab.parent:Close()
					if tab.parent.launchTuto ~= nil then
						tab.parent.launchTuto()
					end
				end
			end
		},
		-- The showBriefing tab
		{preset = function(tab)
				tab.title = showBriefing
				tab.position = "top"
				tab.OnClick = function()
					tab.parent:Close()
					Script.LuaUI.TraceAction("show_briefing\n")
					if tab.parent.launchTuto ~= nil then
						tab.parent.launchTuto()
					else
						Spring.SendLuaRulesMsg("Show briefing")
					end
				end
			end
		}
	}
}

-- This function returns a deep copy of a given table. The function below also
-- copies the metatable to the new table if there is one, so the behaviour of
-- the copied table is the same as the original.
local function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, _copy(getmetatable(object)))
    end
    return _copy(object)
end

local winPopup = nil
local briefing = nil
local tutoPopup = false

function MissionEvent(e)
	if e.logicType == "ShowMissionMenu" then
		-- close tuto window if it oppened
		if tutoPopup then
			if not WG.rooms.TutoView.closed then
				WG.rooms.TutoView:Close()
			end
		end
		-- close briefing window if it oppened
		WG.Message:DeleteAll()
		-- load templated mission
		local popup = deepcopy(template_endMission)
		local victoryState = ""
		-- update window
		if e.state ~= "menu" then
			if e.state == "won" then
				if scenarioType == "default" then
					if campaign[missionName].nextMission ~= nil then
						popup.lineArray = {victory}
					else
						popup.lineArray = {victoryCampaign}
					end
				elseif scenarioType == "noScenario" then
					popup.lineArray = {victory}
				else
					-- TODO: use appliqManager to define accurate popup.lineArray property
				end
				victoryState = "won"
			else
				popup.lineArray = {loss}
				victoryState = "loss"
			end
			
			if e.feedback ~= nil then
				table.insert(popup.lineArray,"")
				local ind_s = 1
				for i = 1,#e.feedback do
					if e.feedback:sub(i,i) == "\n" then
						table.insert(popup.lineArray,string.sub(e.feedback,ind_s,i-1))
						ind_s = i+1
					elseif i == #e.feedback then
						table.insert(popup.lineArray,string.sub(e.feedback,ind_s))
					end
				end
				table.insert(popup.lineArray,"")
			end
			
			-- Enable PreviousMission and NextMission tabs
			-- PreviousMission tab is activated if we are on the default scenario and a previous mission is defined
			local activatePreviousMission = (scenarioType == "default" and campaign[missionName] and campaign[missionName].previousMission ~= nil)
			if activatePreviousMission then
				popup.tabs[1].preset = function(tab)
						tab.title = previousMission
						tab.position = "bottom"
						tab.OnClick = function()
							tab.parent:Close()
							Script.LuaUI.TraceAction("previous "..campaign[missionName].previousMission.."\n")
							DoTheRestart("Missions/"..Game.modShortName.."/"..campaign[missionName].previousMission..".txt", lang, scenarioType)
						end
					end
			end
			-- Next tab is activated if we are on the default scenario and a next mission is defined OR if we interpret an Appliq scenario (TODO: use appliq manager to define next mission)
			local activateNextMission = (scenarioType == "default" and campaign[missionName] and campaign[missionName].nextMission ~= nil) -- or (scenarioType ~= "noScenario" and appliqManager.nextMission() ~= nil) ??????
			-- Of course, we can pass to the next mission if current mission is won
			if e.state == "won" and activateNextMission then
				popup.tabs[3].preset = function(tab)
						tab.title = nextMission
						tab.position = "bottom"
						tab.OnClick = function()
							tab.parent:Close()
							Script.LuaUI.TraceAction("next "..campaign[missionName].nextMission.."\n")
							-- set nextLauncher depending on type of scenario
							local nextLauncher = ""
							if scenarioType == "default" then
								nextLauncher = "Missions/"..Game.modShortName.."/"..campaign[missionName].nextMission..".txt"
							else
								-- TODO: define nextLauncher with appliqManager
							end
							DoTheRestart(nextLauncher, lang, scenarioType)
						end
					end
			end
				
			if e.feedback == nil then
				popup.tabs[6] = nil -- disable "Close tab" and "Show briefing"
				Script.LuaUI.MissionEnded(victoryState)
			else
				popup.tabs[6] = {
					preset = function(tab)
						tab.title = "Publier sur facebook"
						tab.position = "right"
						tab.topLeftColor     = {0.23, 0.35, 0.6, 1}
						tab.topRightColor    = {0.23, 0.35, 0.6, 1}
						tab.bottomLeftColor  = {0.23, 0.35, 0.6, 1}
						tab.bottomRightColor = {0.23, 0.35, 0.6, 1}
						tab.OnClick = function()
							Script.LuaUI.TraceAction("publish\n")
							Spring.SetConfigString("publish", "true", 1) -- this value will be read by the engine to publish results on facebook
						end
					end
				}
				popup.tabs[7] = nil
			end
			
		else
			popup.lineArray = {"Menu"}
		end
		
		-- close presious window if require
		if winPopup ~= nil then
			winPopup:Close()
			winPopup = nil
		end
		-- create new one with preset popup config
		winPopup = Window:CreateCentered(popup)
		-- and open it
		winPopup:Open()
		-- set tutorial launcher if tutoPopup has been created
		if tutoPopup then
			winPopup.launchTuto = function ()
				if WG.rooms.TutoView.closed then
					WG.rooms.TutoView:Open()
				end
			end
		else
			winPopup.launchTuto = nil
		end
	elseif e.logicType == "ShowMessage" then
	    if e.image then 
	      briefing = WG.Message:Show{
	        texture = ":n:LuaUI/Images/"..e.image,
	        text = e.message,
	        width = e.imageWidth,
	        height = e.imageHeight,
	        pause = e.pause,
	      }
	    else
	      briefing = WG.Message:Show{text = e.message, width = e.width, pause = e.pause}
	    end
		if not WG.rooms.Video.closed then
			briefing.delayDrawing = true
		end
	elseif e.logicType == "PauseAction" then
		Spring.SendCommands"pause"
	elseif e.logicType == "MarkerPointAction" then
		local height = Spring.GetGroundHeight(e.x, e.y)
		Spring.MarkerAddPoint(e.x, height, e.y, e.text)
		if e.centerCamera then
		  Spring.SetCameraTarget(e.x, height, e.y, 1)
		end
	end
end

function TutorialEvent()
	if not tutoPopup then	
		tutoPopup = true
		WG.rooms.TutoView:Open()
	end
end

function widget:KeyPress(key, mods, isRepeat, label, unicode)
	-- intercept ESCAPE pressure
	if key == KEYSYMS.ESCAPE then
		if not WG.rooms.Video.closed then
			WG.rooms.Video:Close()
			if briefing ~= nil then
				briefing.delayDrawing = false
			end
		else
			if not WG.rooms.TutoView.closed then
				WG.rooms.TutoView:Close()
			end
			if winPopup == nil then
				local event = {logicType = "ShowMissionMenu",
								state = "menu"}
				MissionEvent (event)
			else
				if winPopup.closed then 
					winPopup:Open()
				end
			end
		end
		return true
	end
end

function EmulateEscapeKey ()
	widget:KeyPress(KEYSYMS.ESCAPE, nil, nil, nil, nil)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
	widgetHandler:RegisterGlobal("EmulateEscapeKey", EmulateEscapeKey)
	widgetHandler:RegisterGlobal("MissionEvent", MissionEvent)
	widgetHandler:RegisterGlobal("TutorialEvent", TutorialEvent)
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("EmulateEscapeKey")
	widgetHandler:DeregisterGlobal("MissionEvent")
	widgetHandler:DeregisterGlobal("TutorialEvent")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------