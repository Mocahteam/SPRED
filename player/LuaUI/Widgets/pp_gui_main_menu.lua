function widget:GetInfo()
  return {
    name      = "PP GUI Main Menu",
    desc      = "Turning this off might disrupt the mission.",
    author    = "quantum, muratet, mocahteam",
    date      = "Jul 15, 2012",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true, --  loaded by default?
  }
end

-- You must import the KEYSYM table if you want to access keys by name
include('keysym.h.lua')

VFS.Include ("LuaUI/Widgets/libs/RestartScript.lua") -- contain DoTheRestart function
VFS.Include("LuaUI/Widgets/libs/AppliqManager.lua")

local xmlFiles = VFS.DirList("scenario/", "*.xml")
local AppliqManager
if(xmlFiles[1]~=nil)then
  AppliqManager=appliqManager:new(xmlFiles[1])
  AppliqManager:parse()
end

VFS.Include("LuaUI/Widgets/libs/Pickle.lua",nil) 

local lang = Spring.GetModOptions()["language"] -- get the language
local scenarioType = Spring.GetModOptions()["scenario"] -- get the type of scenario default or index of scenario in appliq file
local missionName = Spring.GetModOptions()["missionname"] -- get the name of the current mission
local traceOn = Spring.GetModOptions()["activetraces"] ~= nil and Spring.GetModOptions()["activetraces"] == "1"

local mode = Spring.GetModOptions()["scenariomode"]

-- see Widget:Initialize() for default value of these variables
local rooms
local Window
local Tab

-- Set label
local saveMessage="Your progression has been saved under the name : "
local saveError="Base file missing to save your progression, save aborted!!!"
local replayMission = "Replay mission"
local nextMission = "Next mission"
local quitGame = "Quit the game"
local quitMission = "Quit the mission"
local closeMenu = "Close menu"
local showBriefing = "Show briefing"
local victory = "You won the mission"
local victoryCampaign = "Congratulations !!! You complete the campaign"
local loss = "You lost the mission"
local continue = "continue"
local saveProgression="Save progression"
local saveName="Please, give a name of your save:"
local saveConfirm1="A file with the name "
local saveConfirm2=" already exists.\nDo you want override it?"
local scoreComputing="Analysis of your work, please wait..."
local cancelLabel="Cancel"
local okLabel="OK"
local yesLabel="Yes"
local noLabel="No"
if lang == "fr" then
  saveMessage="Votre progression a �t� sauvegard�e sous le nom : "
  saveError="Fichier de base manquant pour r�aliser la sauvegarde, op�ration annul�e !!!"
  continue= "continuer"
  replayMission = "Rejouer mission"
  nextMission = "Mission suivante"
  quitGame = "Quitter le jeu"
  quitMission = "Quitter la mission"
  closeMenu = "Fermer menu"
  showBriefing = "Voir briefing"
  victory = "Vous avez gagn� la mission"
  victoryCampaign = "F�licitations !!! Vous avez termin� la campagne"
  loss = "Vous avez perdu la mission"
  saveProgression="Sauvegarder"
  saveName="Merci d'indiquer un nom � votre sauvegarde :"
  saveConfirm1="Un fichier avec le nom "
  saveConfirm2=" existe d�j�.\nSouhaitez-vous le remplacer ?"
  scoreComputing="Analyse de votre travail en cours, merci de patienter..."
  cancelLabel="Annuler"
  yesLabel="Oui"
  noLabel="Non"
end

local activateSave=false
if mode=="appliq" and AppliqManager~=nil then
  activateSave=true
end

-- Save UI
local saveWindow = nil
local saveNameEditBox = nil
local saveBackground = nil

local function doTheSave(gameName, fileName)
	local savingContent=VFS.LoadFile("Savegames/"..gameName.."/currentSave.sav")
	if savingContent ~= nil then
		local file=io.open("Savegames/"..gameName.."/"..fileName,"wb")
		file:write(savingContent)
		file:flush()
		file:close()
		Script.LuaUI.TraceAction("save progression\n")
		MissionEvent({logicType = "ShowMessage",message = saveMessage.."\""..fileName.."\"", width = 500,pause = false})
	else
		MissionEvent({logicType = "ShowMessage",message = saveError, width = 500,pause = false})
	end
	--close save window
	if saveWindow ~= nil then
		saveWindow:Dispose()
		saveBackground:Dispose()
		saveWindow = nil
		saveNameEditBox = nil
		saveBackground = nil
	end
end

local function displayConfirmSave(gameName, fileName)
	if saveWindow ~= nil then
		-- In this case we want to keep the background, so we don't dispose it
		saveWindow:Dispose()
		saveWindow = nil
		saveNameEditBox = nil
	end
	-- build UI to confirm saving
	saveWindow = WG.Chili.Window:New{
		parent = WG.Chili.Screen0,
		x = "27%",
		y = "44%",
		width  = "46%",
		height = "12%",
		minWidth = 0,
		minHeight = 0,
		draggable = false,
		resizable = false,
	}
	WG.Chili.Label:New {
		parent = saveWindow,
		x = "0%",
		y = "0%",
		width = "100%",
		height = "58%",
		minWidth = 0,
		minHeight = 0,
		caption = saveConfirm1.."\""..fileName.."\""..saveConfirm2,
		fontsize = 20,
		align = "center",
		valign = "top",
		padding = {8, 2, 8, 2},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
		}
	}
	WG.Chili.Button:New {
		parent = saveWindow,
		x = "15%",
		y = "60%",
		width = "20%",
		height = "40%",
		caption = yesLabel,
		minWidth = 0,
		minHeight = 0,
		OnClick = {
			function ()
				doTheSave(gameName, fileName)
			end
		},
		padding = {8, 0, 8, 0},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 15,
			autoAdjust = true,
			maxSize = 15,
		}
	}
	WG.Chili.Button:New {
		parent = saveWindow,
		x = "65%",
		y = "60%",
		width = "20%",
		height = "40%",
		caption = noLabel,
		minWidth = 0,
		minHeight = 0,
		OnClick = {
			function ()
				--close save window
				if saveWindow ~= nil then
					saveWindow:Dispose()
					saveBackground:Dispose()
					saveWindow = nil
					saveNameEditBox = nil
					saveBackground = nil
				end
			end
		},
		padding = {8, 0, 8, 0},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 15,
			autoAdjust = true,
			maxSize = 15,
		}
	}
end

local function processSaving ()
	if saveNameEditBox ~= nil then
		local fileName=saveNameEditBox.text..".sav"
		local gameName=Game.gameShortName or Game.modShortName
		if VFS.FileExists("Savegames/"..gameName.."/"..fileName) then
			displayConfirmSave(gameName, fileName)
		else
			doTheSave(gameName, fileName)
		end
	end
end

local function displaySaveWindow()
	if saveWindow ~= nil then
		saveWindow:Dispose()
		saveBackground:Dispose()
		saveWindow = nil
		saveNameEditBox = nil
		saveBackground = nil
	end
	saveWindow = WG.Chili.Window:New{
		parent = WG.Chili.Screen0,
		x = "25%",
		y = "42%",
		width  = "50%",
		height = "16%",
		minWidth = 0,
		minHeight = 0,
		draggable = false,
		resizable = false,
	}
	saveBackground = WG.Chili.Image:New {
		parent = WG.Chili.Screen0,
		x = "0%",
		y = "0%",
		width = "100%",
		height = "100%",
		minWidth = 0,
		minHeight = 0,
		file = "bitmaps/editor/blank.png",
		keepAspect = false,
		color = {0, 0, 0, 0.9}
	}
	saveBackground.OnClick = {
		function()
			return true -- Stop Clic event
		end
	}
	WG.Chili.Label:New {
		parent = saveWindow,
		x = "0%",
		y = "0%",
		width = "100%",
		height = "33%",
		minWidth = 0,
		minHeight = 0,
		caption = saveName,
		fontsize = 20,
		align = "left",
		valign = "top",
		padding = {8, 2, 8, 2},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
		}
	}
	saveNameEditBox = WG.Chili.EditBox:New {
		parent = saveWindow,
		x = "0%",
		y = "33%",
		width = "100%",
		height = "33%",
		align = "left",
		text = "",
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 16,
			autoAdjust = true,
			maxSize = 16
		}
	}
	WG.Chili.Button:New {
		parent = saveWindow,
		x = "15%",
		y = "67%",
		width = "20%",
		height = "33%",
		caption = okLabel,
		minWidth = 0,
		minHeight = 0,
		OnClick = {processSaving},
		padding = {8, 0, 8, 0},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 15,
			autoAdjust = true,
			maxSize = 15,
		}
	}
	WG.Chili.Button:New {
		parent = saveWindow,
		x = "65%",
		y = "67%",
		width = "20%",
		height = "33%",
		caption = cancelLabel,
		minWidth = 0,
		minHeight = 0,
		OnClick = {
			function ()
				saveWindow:Dispose()
				saveBackground:Dispose()
				saveWindow = nil
				saveNameEditBox = nil
				saveBackground = nil
			end
		},
		padding = {8, 0, 8, 0},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 15,
			autoAdjust = true,
			maxSize = 15,
		}
	}
	WG.Chili.Screen0:FocusControl(saveNameEditBox)
end

-- Defines a template window for the end mission menu
local template_endMission = {
  lineArray = {""},
  closed = true,
  noMove = true,
  --noAnimation = true,
  tabs = {
    -- The replayMission tab
    {preset = function(tab)
        tab.title = replayMission
        tab.position = "bottom"
        tab.OnClick = function()
          tab.parent:Close()
		  Script.LuaUI.TraceAction("replay "..missionName.."\n")
		  DoTheRestart("_script.txt", {}) -- _script.txt is the launcher file used by the previous start, so we can reuse it for replay the game
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
    -- the save progression Tab
    {preset = function(tab)
        tab.title = saveProgression
        tab.position = "right"
        tab.OnClick = function()
			displaySaveWindow()
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
    -- update main menu content depending on e.state ("menu", "won" or "lost") and "testmap" modoption
    if e.state ~= "menu" then
		
		if (Spring.GetModOptions()["testmap"]~=nil) then
			-- if we are in testmap case, the main menu is only simple message
			-- the button "return back to editor" is permanently displayed in UI
			local message = ""
			if e.state == "won" then
				message = victory
			else
				message = loss     
			end
			MissionEvent({logicType = "ShowMessage",message = message, width = 500,pause = false})
			return
		end
		
		-- define popup base text depending on victory state
		if e.state == "won" then
			popup.lineArray = {victory}
		else
			popup.lineArray = {loss}
		end

		-- Of course, we can pass to the next mission if current mission is won
		if mode=="appliq" and AppliqManager~=nil then     
			local currentoptions=Spring.GetModOptions()       
			AppliqManager:selectScenario(tonumber(currentoptions["scenario"]))
			AppliqManager:startRoute()
			--Spring.Echo(e.outputstate)
			--Spring.Echo("current Act ID")
			--Spring.Echo(AppliqManager.currentActivityID)
			local progression=unpickleProgression(currentoptions["progression"])
			--AppliqManager:setProgression(unpickle(currentoptions["progression"]))
			--Spring.Echo(e.outputstate)
			AppliqManager:setProgression(progression)
			local outputs=AppliqManager:listPossibleOutputsFromCurrentActivity()
			local nextMiss=AppliqManager:next(e.outputstate)  
			local mission=AppliqManager.currentActivityID
			if(nextMiss==nil) then     
				Spring.Echo("IMPORTANT WARNING : no (or invalid) output state given while appliq mode is on. As a result a random output state has been picked, please fix your mission")
				local selectedOutput=outputs[math.random(#outputs)]
				AppliqManager:next(selectedOutput)         
			elseif (nextMiss=="end") then
				Spring.Echo("end of scenario")
				popup.lineArray = {victoryCampaign}
				continue="\255\50\50\50"..continue.."\255\255\255\255"
			else
				local currentInput=AppliqManager:getCurrentInputName()
				--Spring.Echo(currentoptions["progression"])
				-- Spring.Echo(currentInput)
				--Spring.Echo(e.outputstate)         
				--Spring.Echo(mission)           
				currentoptions["currentinput"]=currentInput  
				currentoptions["missionname"]=mission
				currentoptions["currentinput"]=currentInput
				currentoptions["progression"]=pickle(AppliqManager.progressionOutputs)
			end          
			popup.tabs[2].preset = function(tab)
				tab.title = "\255\50\50\50"..nextMission.."\255\255\255\255"
				tab.OnClick = function()
				end
			end
			-- enable continue
			popup.tabs[3].preset = function(tab)
				tab.title = continue
				tab.position = "bottom"
				tab.OnClick = function() --TODO: It would be nice to reduce the amount of code in this function
					if(nextMiss~="end")then
						tab.parent:Close()
						--DoTheRestart("Missions/"..Game.modShortName.."/mission2.txt",options)      
						genericRestart("Missions/"..mission..".editor", {["MODOPTIONS"]=currentoptions}) -- COMMENT THIS LINE IF YOU WANT TO SEE SOME MAGIC (or some Spring.Echo)
					end
				end
			end
		end
		
		if traceOn then
			table.insert(popup.lineArray, "")
			table.insert(popup.lineArray, scoreComputing)
		end

		-- disable "Close tab" and "Show briefing"
		popup.tabs[6] = nil
	  
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
  elseif e.logicType == "UpdateFeedback" then
	-- update winPopup text if feedback is set
	if e.feedback ~= nil and winPopup ~= nil and traceOn then
		Spring.Echo ("Feedback to update : "..e.feedback.."FIN")
		-- remove the last line (score computing label)
		table.remove(winPopup.lineArray)
		-- add lines feedbacks to the popup
		local ind_s = 1
		for i = 1,#e.feedback do
			if e.feedback:sub(i,i) == "\n" then
				table.insert(winPopup.lineArray,string.sub(e.feedback,ind_s,i-1))
				ind_s = i+1
			elseif i == #e.feedback then
				table.insert(winPopup.lineArray,string.sub(e.feedback,ind_s))
			end
		end
		table.insert(winPopup.lineArray,"")
		-- make a copy in order to recreate it
		local popup = deepcopy(winPopup)
		-- reset position in order to recompute them when we rebuild the popup
		popup.x2 = nil
		popup.y2 = nil
		winPopup:Close()
		-- rebuild the popup
		winPopup = Window:CreateCentered(popup)
		winPopup:Open()
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
	  if WG.rooms.Video and not WG.rooms.Video.closed then
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
  if WG.rooms.Video and not WG.rooms.Video.closed then
    WG.rooms.Video:Close()
  end
  if not tutoPopup then 
    tutoPopup = true
    WG.rooms.TutoView:Open()
  end
end

function widget:KeyPress(key, mods, isRepeat, label, unicode)
	-- intercept ESCAPE pressure
	if key == KEYSYMS.ESCAPE then
		if WG.rooms.Video and not WG.rooms.Video.closed then
			WG.rooms.Video:Close()
			if briefing ~= nil then
				briefing.delayDrawing = false
			end
		else
			if WG.rooms.TutoView and not WG.rooms.TutoView.closed then
				WG.rooms.TutoView:Close()
			end
			if Spring.GetModOptions()["testmap"]~=nil then
				Spring.SendLuaRulesMsg("Show briefing")
			else
				if winPopup == nil then
					local event = {logicType = "ShowMissionMenu",
					state = "menu"}
					MissionEvent (event)
				else
					if winPopup.closed then
						-- make a copy in order to recreate it and be sure it is centered
						local popup = deepcopy(winPopup)
						-- reset position in order to recompute them when we rebuild the popup
						popup.x2 = nil
						popup.y2 = nil
						-- rebuild the popup
						winPopup = Window:CreateCentered(popup)
						winPopup:Open()
					else
						winPopup:Close()
						if winPopup.launchTuto ~= nil then
							winPopup.launchTuto()
						end
					end
				end
			end
		end
		return true
	end
end

function EmulateEscapeKey ()
  widget:KeyPress(KEYSYMS.ESCAPE, nil, nil, nil, nil)
end

function widget:Initialize()
  widgetHandler:RegisterGlobal("EmulateEscapeKey", EmulateEscapeKey)
  widgetHandler:RegisterGlobal("MissionEvent", MissionEvent)
  widgetHandler:RegisterGlobal("TutorialEvent", TutorialEvent)
  
  rooms = WG.rooms -- WG is available in all widgets
  Window = rooms.Window
  Tab = rooms.Tab
  
end


function widget:Shutdown()
  widgetHandler:DeregisterGlobal("EmulateEscapeKey")
  widgetHandler:DeregisterGlobal("MissionEvent")
  widgetHandler:DeregisterGlobal("TutorialEvent")
end