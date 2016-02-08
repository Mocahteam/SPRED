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


local rooms = WG.rooms -- availabe in all widgets
local Window = rooms.Window
local Tab = rooms.Tab
local lang = rooms.lang

-- Set label
local previousMission = "Previous mission"
local replayMission = "Replay mission"
local nextMission = "Next mission"
local quitGame = "Quit the game"
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
	closeMenu = "Fermer menu"
	showBriefing = "Voir briefing"
	victory = "Vous avez gagné la mission"
	victoryCampaign = "Félicitations !!! Vous avez terminé la campagne"
	loss = "Vous avez perdu la mission"
end


-- create the "mission_ended.conf" file in order to inform game engine that a mission is ended
local function createTmpFile()
	if not VFS.FileExists("mission_ended.conf") then
		local f = io.open("mission_ended.conf", "w")
		if f ~= nil then
			f:write("This file has been created by Mission GUI Widget in order to inform game engine that a mission is ended. This file will be deleted the next time the game restarts.")
			f:flush()
			f:close()
		end
	end
end

-- Define an empty tab
local emptyTab = {
	title = "title",
	isAboveColors = {
		bottomLeft  = {0.3, 0.3, 0.3, 0.3},
		topLeft     = {0.3, 0.3, 0.3, 0.3},
		topRight    = {0.3, 0.3, 0.3, 0.3},
		bottomRight = {0.3, 0.3, 0.3, 0.3}
	},
	topLeftColor     = {0.3, 0.3, 0.3, 0.3},
	topRightColor    = {0.3, 0.3, 0.3, 0.3},
	bottomLeftColor  = {0.3, 0.3, 0.3, 0.3},
	bottomRightColor = {0.3, 0.3, 0.3, 0.3},
	position = "bottom"
}

-- Defines a template window for the end mission menu
local template_endMission = {
	lineArray = {""},
	closed = true,
	noMove = true,
	--noAnimation = true,
	tabs = {
		{preset = function(tab)
				tab.title = previousMission
				tab.position = "bottom"
				tab.OnClick = function()
					tab.parent:Close()
					Spring.SendLuaRulesMsg("Previous mission")
				end
			end
		},
		{preset = function(tab)
				tab.title = replayMission
				tab.position = "bottom"
				tab.OnClick = function()
					tab.parent:Close()
					Spring.SendLuaRulesMsg("Replay mission")
				end
			end
		},
		{preset = function(tab)
				tab.title = nextMission
				tab.position = "bottom"
				tab.OnClick = function()
					tab.parent:Close()
					Spring.SendLuaRulesMsg("Next mission")
				end
			end
		},
		{preset = function(tab)
				tab.title = quitGame
				tab.position = "right"
				tab.OnClick = function()
					tab.parent:Close()
					Spring.SendCommands("quitforce")
				end
			end
		},
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
		{preset = function(tab)
				tab.title = showBriefing
				tab.position = "top"
				tab.OnClick = function()
					tab.parent:Close()
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
	if e.logicType == "GuiEndMissionAction" then
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
		-- update window
		if e.gameOver ~= "menu" then
			if e.gameOver == "won" then
				popup.lineArray = {victory}
			elseif e.gameOver == "wonCampaign" then
				popup.lineArray = {victoryCampaign}
			else
				popup.lineArray = {loss}
			end
			-- disable "Close tab" and "Show briefing"
			popup.tabs[5] = nil
			-- inform the game that mission is over with a temporary file
			createTmpFile()
		else
			popup.lineArray = {"Menu"}
		end
		
		if e.posMission == "first" or e.posMission == "replay" then
			popup.tabs[1] = deepcopy(emptyTab)
			popup.tabs[1].title = "\255\50\50\50"..previousMission.."\255\255\255\255"
		end
		if e.posMission == "last" or e.gameOver == "lost" or e.posMission == "replay" then
			popup.tabs[3] = deepcopy(emptyTab)
			popup.tabs[3].title = "\255\50\50\50"..nextMission.."\255\255\255\255"
		end
		-- create window
		if winPopup ~= nil then
			winPopup:Close()
			winPopup = nil
		end
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
	elseif e.logicType == "GuiMessageAction" then
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
				MissionEvent{logicType = "GuiEndMissionAction",
						gameOver = "menu",
						posMission = "replay"}
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