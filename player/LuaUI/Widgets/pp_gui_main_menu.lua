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

local json = VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")

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

local feedbacks = {}
-- Exemple of data structure
--	{
--		feedback="Feedback 1",
--		clearness = 1,
--		utility = 1
--	},
--	{
--		feedback="Feedback 1",
--		clearness = 1,
--		utility = 1
--	},
--	...
--}
local currentFeedback = 1

-- associative table between a number and its character
local colorTable = {"\3", "\5",	"\8", "\10", "\13", "\15", "\18", "\20",
	"\23", "\25", "\28", "\30", "\33", "\35", "\38", "\40",
	"\43", "\45", "\48", "\50", "\53", "\55", "\58", "\60",
	"\63", "\65", "\68", "\70", "\73", "\75", "\78", "\80",
	"\83", "\85", "\88", "\90", "\93", "\95", "\98", "\100",
	"\103", "\105", "\108", "\110", "\113", "\115", "\118", "\120",
	"\123", "\125", "\128", "\130", "\133", "\135", "\138", "\140",
	"\143", "\145", "\148", "\150", "\153", "\155",	"\158", "\160",
	"\163", "\165", "\168", "\170", "\173", "\175", "\178", "\180",
	"\183", "\185", "\188", "\190", "\193", "\195", "\198", "\200",
	"\203", "\205", "\208", "\210", "\213", "\215", "\218", "\220",
	"\223", "\225", "\228", "\230", "\233", "\235", "\238", "\240",
	"\243", "\245", "\248", "\250", "\253"}

local mode = Spring.GetModOptions()["scenariomode"]

-- see Widget:Initialize() for default value of this variable
local rooms

local briefingPopup = nil
local tutoPopup = false

-- Set label
local LANG_REPLAY_MISSION = "Replay mission"
local LANG_QUIT_GAME = "Quit the game"
local LANG_QUIT_MISSION = "Quit the mission"
local LANG_SHOW_BRIEFING = "Show briefing"
local LANG_VICTORY = "You won the mission"
local LANG_VICTORY_CAMPAIGN = "Congratulations!!! You complete the campaign"
local LANG_LOSS = "You lost the mission"
local LANG_CONTINUE = "Continue"
local LANG_SAVE_PROGRESSION="Save progression"
local LANG_SAVE_MESSAGE="Your progression has been saved under the name: "
local LANG_SAVE_ERROR="Base file missing to save your progression, save aborted!!!"
local LANG_SAVE_NAME="Please, give a name of your save:"
local LANG_SAVE_CONFIRM1="A file with the name "
local LANG_SAVE_CONFIRM2=" already exists.\nDo you want override it?"
local LANG_SCORE="Your score: "
local LANG_SCORE_COMPUTING="Please wait..."
local LANG_NUM_ATTEMPTS = "Number of attempts: "
local LANG_CANCEL="Cancel"
local LANG_OK="OK"
local LANG_YES="Yes"
local LANG_NO="No"
local LANG_ADVICE = "Advices to improve your program: "
local LANG_VOTE = "No vote"
local LANG_NOT_CLEAR = "(Not clear)"
local LANG_CLEAR = "(Very clear)"
local LANG_NOT_USEFUL = "(Not useful)"
local LANG_USEFUL = "(Very useful)"
local LANG_CLOSE_BUTTON = "Close"
local LANG_ASSESS_FEEDBACK = "What do you think about this advice?"
local LANG_PROGRAM_EXECUTION = "Program execution time: "
local LANG_PROGRAM_REFERENCE = "Reference execution time: "
local LANG_AVERAGE_TIME = "Average wait time between two attempts: "
local LANG_MISSION_TIME = "Mission resolution time: "
local LANG_REFERENCE_TIME = "Reference resolution time: "
local LANG_WARNING_STATE = "Warning!!! State unknown"
if lang == "fr" then
	LANG_CONTINUE= "Continuer"
	LANG_REPLAY_MISSION = "Rejouer mission"
	LANG_QUIT_GAME = "Quitter le jeu"
	LANG_QUIT_MISSION = "Quitter la mission"
	LANG_SHOW_BRIEFING = "Voir briefing"
	LANG_VICTORY = "Vous avez gagné la mission"
	LANG_VICTORY_CAMPAIGN = "Félicitations !!! Vous avez terminé la campagne"
	LANG_LOSS = "Vous avez perdu la mission"
	LANG_SAVE_PROGRESSION="Sauvegarder"
	LANG_SAVE_MESSAGE="Votre progression a été sauvegardée sous le nom : "
	LANG_SAVE_ERROR="Fichier de base manquant pour réaliser la sauvegarde, opération annulée !!!"
	LANG_SAVE_NAME="Merci d'indiquer un nom à votre sauvegarde :"
	LANG_SAVE_CONFIRM1="Un fichier avec le nom "
	LANG_SAVE_CONFIRM2=" existe déjà.\nSouhaitez-vous le remplacer ?"
	LANG_SCORE="Votre score : "
	LANG_SCORE_COMPUTING="Merci de patienter..."
	LANG_NUM_ATTEMPTS="Nombre de tentative(s) : "
	LANG_CANCEL="Annuler"
	LANG_YES="Oui"
	LANG_NO="Non"
	LANG_ADVICE = "Quelques conseils pour améliorer votre programme : "
	LANG_VOTE = "Aucun vote"
	LANG_NOT_CLEAR = "(Pas clair)"
	LANG_CLEAR = "(Très clair)"
	LANG_NOT_USEFUL = "(Pas utile)"
	LANG_USEFUL = "(Très utile)"
	LANG_CLOSE_BUTTON = "Fermer"
	LANG_ASSESS_FEEDBACK = "Que pensez-vous de ce conseil ?"
	LANG_PROGRAM_EXECUTION = "Temps d'éxecution de ton programme : "
	LANG_PROGRAM_REFERENCE = "Temps d'éxecution référence : "
	LANG_AVERAGE_TIME = "Temps d'attente moyen entre deux tentatives : "
	LANG_MISSION_TIME = "Temps de résolution de la mission : "
	LANG_REFERENCE_TIME = "Temps de résolution référence : "
	LANG_WARNING_STATE = "Attention!!! Etat non connu"
end

local activateSave=false
if mode=="appliq" and AppliqManager~=nil then
  activateSave=true
end

-- Main menu UI
local mainMenuWindow = nil
local filterBackground = nil

-- Save UI
local saveWindow = nil
local saveNameEditBox = nil

-- Feedback UI
local feedbackPanel = nil
local feedbackCanvas = nil
local nextFeedbackBt = nil
local prevFeedbackBt = nil
local logComboEvent = true
local clearComboBox = nil
local usefulComboBox = nil
local scoreLabel = nil
local numAttemptLabel = nil
local assessLabel = nil
local mainMenuCloseButton = nil

-- UI builders
local function addWindow(_parent, _x, _y, _width, _height)
	return WG.Chili.Window:New{
		parent = _parent,
		x = _x,
		y = _y,
		width  = _width,
		height = _height,
		minWidth = 0,
		minHeight = 0,
		draggable = false,
		resizable = false,
	}
end

local function addLabel(_parent, _x, _y, _width, _height, _caption, _align, _valign)
	return WG.Chili.Label:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _width,
		height = _height,
		minWidth = 0,
		minHeight = 0,
		caption = _caption,
		fontsize = 20,
		align = _align,
		valign = _valign,
		padding = {8, 2, 8, 2},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
			shadow = false
		}
	}
end

local function addButton(_parent, _x, _y, _width, _height, _caption)
	return WG.Chili.Button:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _width,
		height = _height,
		caption = _caption,
		minWidth = 0,
		minHeight = 0,
		padding = {8, 0, 8, 0},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 15,
			autoAdjust = true,
			maxSize = 15,
			shadow = false,
		}
	}
end

local function addImage(_parent, _x, _y, _width, _height, _file, _keepAspect)
	return WG.Chili.Image:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _width,
		height = _height,
		file = _file,
		keepAspect = _keepAspect
	}
end

local function addEditBox(_parent, _x, _y, _width, _height, _align, _text)
	return WG.Chili.EditBox:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _width,
		height = _height,
		align = _align,
		text = _text,
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 16,
			autoAdjust = true,
			maxSize = 16,
			shadow = false
		}
	}
end

local function addPanel(_parent, _x, _y, _width, _height)
	return WG.Chili.Panel:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _width,
		height = _height,
		minWidth = 0,
		minHeight = 0
	}
end

local function addScrollPanel(_parent, _x, _y, _width, _height)
	return WG.Chili.ScrollPanel:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _width,
		height = _height
	}
end

local function addTextBox(_parent, _x, _y, _width, _height, _text)
	return WG.Chili.TextBox:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _width,
		height = _height,
		text = _text,
		fontsize = 16,
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			shadow = false
		}
	}
end

local function addComboBox(_parent, _x, _y, _width, _height, _items)
	return WG.Chili.ComboBox:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _width,
		height = _height,
		items = _items,
		fontsize = 20,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
			color = { 0.2, 1, 0.8, 1 },
			shadow = false
		}
	}
end
-- UI builders end

local function doTheSave(gameName, fileName)
	--close save window
	if saveWindow ~= nil then
		saveWindow:Dispose()
		saveWindow = nil
		saveNameEditBox = nil
	end
	
	local savingContent=VFS.LoadFile("Savegames/"..gameName.."/currentSave.sav")
	local notif = ""
	if savingContent ~= nil then
		local file=io.open("Savegames/"..gameName.."/"..fileName,"wb")
		file:write(savingContent)
		file:flush()
		file:close()
		if Script.LuaUI.TraceAction then
			Script.LuaUI.TraceAction("save_progression") -- registered by pp_meta_trace_manager.lua
		end
		notif = LANG_SAVE_MESSAGE.."\""..fileName.."\""
	else
		notif = LANG_SAVE_ERROR
	end
	-- Show notification
	local notifWindow = addWindow(WG.Chili.Screen0, "10%", "44%", "80%", "12%")
	addLabel(notifWindow, "0%", "0%", "100%", "58%", notif, "center", "linecenter")
	local okBut = addButton(notifWindow, "45%", "60%", "10%", "40%", LANG_OK)
	local function closeNotification()
		--close notification and show Main menu
		notifWindow:Dispose()
		if mainMenuWindow.hidden then
			mainMenuWindow:Show()
		end
	end
	okBut.OnClick = { closeNotification }
	okBut.OnKeyPress = {
		function (self, key)
			if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
				closeNotification()
				return true
			end
		end
	}
	WG.Chili.Screen0:FocusControl(okBut)
end

local function displayConfirmSave(gameName, fileName)
	if saveWindow ~= nil then
		-- In this case we want to keep the background, so we don't dispose it
		saveWindow:Dispose()
		saveWindow = nil
		saveNameEditBox = nil
	end
	-- build UI to confirm saving
	saveWindow = addWindow(WG.Chili.Screen0, "27%", "44%", "46%", "12%")
	
	addLabel(saveWindow, "0%", "0%", "100%", "58%", LANG_SAVE_CONFIRM1.."\""..fileName.."\""..LANG_SAVE_CONFIRM2, "center", "top")
	
	local yesBut = addButton(saveWindow, "15%", "60%", "20%", "40%", LANG_YES)
	yesBut.OnClick = {
		function ()
			doTheSave(gameName, fileName)
		end
	}
	yesBut.OnKeyPress = {
		function (self, key)
			if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
				doTheSave(gameName, fileName)
				return true
			end
		end
	}
	
	local noBut = addButton(saveWindow, "65%", "60%", "20%", "40%", LANG_NO)
	noBut.OnClick = {
		function ()
			--close save window
			if saveWindow ~= nil then
				saveWindow:Dispose()
				saveWindow = nil
				saveNameEditBox = nil
				if mainMenuWindow.hidden then
					mainMenuWindow:Show()
				end
			end
		end
	}
	WG.Chili.Screen0:FocusControl(yesBut)
end

-----------------------
-- Generate a name for a file from a string
-----------------------
local function generateSaveName(name)
	local saveName = name
	saveName = string.gsub(name, " ", "_")
	saveName = string.gsub(saveName, "[/;\\%.%*:%?\"<>|]", "")
	return saveName
end

local function processSaving ()
	if saveNameEditBox ~= nil then
		local fileName=generateSaveName(saveNameEditBox.text)..".sav"
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
		saveWindow = nil
		saveNameEditBox = nil
	end
	
	saveWindow = addWindow(WG.Chili.Screen0, "25%", "42%", "50%", "16%")
	
	addLabel(saveWindow, "0%", "0%", "100%", "33%", LANG_SAVE_NAME, "left", "top")
	
	saveNameEditBox = addEditBox(saveWindow, "0%", "33%", "100%", "33%", "left", "")
	saveNameEditBox.OnKeyPress = {
		function (self, key)
			if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
				processSaving()
				return true
			end
		end
	}
	
	local okBut = addButton(saveWindow, "15%", "67%", "20%", "33%", LANG_OK)
	okBut.OnClick = {processSaving}
	
	local cancelBut = addButton(saveWindow, "65%", "67%", "20%", "33%", LANG_CANCEL)
	cancelBut.OnClick = {
		function ()
			saveWindow:Dispose()
			saveWindow = nil
			saveNameEditBox = nil
			if mainMenuWindow.hidden then
				mainMenuWindow:Show()
			end
		end
	}
	WG.Chili.Screen0:FocusControl(saveNameEditBox)
end

local function updateFeedbackFields ()
	-- be sure that currentFeedback is included into [1, #feedbacks]
	if currentFeedback < 1 then
		currentFeedback = 1
	elseif currentFeedback > #feedbacks then
		currentFeedback = #feedbacks
	end
	-- show next/previous button depending on feedbacks number
	if nextFeedbackBt and prevFeedbackBt then
		if #feedbacks < 2 then
			if nextFeedbackBt.visible then
				nextFeedbackBt:Hide()
			end
			if prevFeedbackBt.visible then
				prevFeedbackBt:Hide()
			end
		else
			-- and current feedback selected
			if currentFeedback == 1 then
				if nextFeedbackBt.hidden then
					nextFeedbackBt:Show()
				end
				if prevFeedbackBt.visible then
					prevFeedbackBt:Hide()
				end
			elseif currentFeedback == #feedbacks then
				if nextFeedbackBt.visible then
					nextFeedbackBt:Hide()
				end
				if prevFeedbackBt.hidden then
					prevFeedbackBt:Show()
				end
			else
				if nextFeedbackBt.hidden then
					nextFeedbackBt:Show()
				end
				if prevFeedbackBt.hidden then
					prevFeedbackBt:Show()
				end
			end
		end
	end
	-- show comboboxes depending on feedbacks number (need at least one)
	if feedbackCanvas and clearComboBox and usefulComboBox then
		if #feedbacks <= 0 then
			feedbackCanvas:SetText("")
			if clearComboBox.visible then
				clearComboBox:Hide()
			end
			if usefulComboBox.visible then
				usefulComboBox:Hide()
			end
			if assessLabel.visible then
				assessLabel:Hide()
			end
		else
			feedbackCanvas:SetText(feedbacks[currentFeedback].feedback)
			if clearComboBox.hidden then
				clearComboBox:Show()
			end
			if usefulComboBox.hidden then
				usefulComboBox:Show()
			end
			if assessLabel.hidden then
				assessLabel:Show()
			end
			logComboEvent = false
			clearComboBox:Select(feedbacks[currentFeedback].clearness)
			usefulComboBox:Select(feedbacks[currentFeedback].utility)
			logComboEvent = true
		end
	end
end

local function loadPreviousFeedback ()
	if currentFeedback > 1 then
		currentFeedback = currentFeedback - 1
	end
	updateFeedbackFields()
	if Script.LuaUI.TraceAction and #feedbacks > 0 then
		Script.LuaUI.TraceAction("see_previous_feedback "..feedbacks[currentFeedback].feedback) -- registered by pp_meta_trace_manager.lua
	end
end

local function loadNextFeedback ()
	if currentFeedback < #feedbacks then
		currentFeedback = currentFeedback + 1
	end
	updateFeedbackFields()
	if Script.LuaUI.TraceAction and #feedbacks > 0 then
		Script.LuaUI.TraceAction("see_next_feedback "..feedbacks[currentFeedback].feedback) -- registered by pp_meta_trace_manager.lua
	end
end

local function displayFeedbackPanel(mainWindow, _x, _y, _width, _height)
	currentFeedback = 1
	
	feedbackPanel = addPanel(mainWindow, _x, _y, _width, _height)
	
	addLabel(feedbackPanel, "2%", "0%", "96%", "17%", LANG_ADVICE, "center", "linecenter")
	
	-- add scroll panel for long feedbacks
	local scrollPanel = addScrollPanel(feedbackPanel, "16%", "17%", "68%", "49%")
	-- add canvas to display feedback
	local _feedback = ""
	if feedbacks[1] then
		_feedback = feedbacks[1].feedback
	end
	feedbackCanvas = addTextBox(scrollPanel, "0%", "0%", "100%", "100%", _feedback)
	
	-- add previous feedback button
	prevFeedbackBt = addButton(feedbackPanel, "0%", "34%", "16%", "16%", "")
	prevFeedbackBt.backgroundColor = { 0, 0.2, 0.6, 1 }
	prevFeedbackBt.focusColor = { 0, 0.6, 1, 1 }
	prevFeedbackBt.OnClick = { loadPreviousFeedback }
	addImage(prevFeedbackBt, "10%", "10%", "80%", "80%", "bitmaps/launcher/arrow.png", true)
	
	-- add next feedback button
	nextFeedbackBt = addButton(feedbackPanel, "84%", "34%", "16%", "16%", "")
	nextFeedbackBt.backgroundColor = { 0, 0.2, 0.6, 1 }
	nextFeedbackBt.focusColor = { 0, 0.6, 1, 1 }
	nextFeedbackBt.OnClick = { loadNextFeedback }
	addImage(nextFeedbackBt, "10%", "10%", "80%", "80%", "bitmaps/launcher/arrow_reverse.png", true)
	
	-- add label to invite user to assess feedback
	assessLabel = addLabel(feedbackPanel, "2%", "66%", "96%", "17%", LANG_ASSESS_FEEDBACK, "center", "linecenter")
	
	-- add clearness combobox
	clearComboBox = addComboBox(feedbackPanel, "17%", "83%", "33%", "17%", { LANG_VOTE, "1 "..LANG_NOT_CLEAR, "2", "3", "4", "5 "..LANG_CLEAR })
	clearComboBox.OnSelect = {
		function()
			if logComboEvent and feedbacks[currentFeedback].clearness ~= clearComboBox.selected then
				if Script.LuaUI.TraceAction then
					Script.LuaUI.TraceAction("assess_feedback_clearness "..clearComboBox.caption.." feedback_begin\n"..feedbacks[currentFeedback].feedback.."\nfeedback_end") -- registered by pp_meta_trace_manager.lua
				end
			end
			feedbacks[currentFeedback].clearness = clearComboBox.selected
		end
	}
	
	-- add usefulness combobox
	usefulComboBox = addComboBox(feedbackPanel, "50%", "83%", "33%", "17%", { LANG_VOTE, "1 "..LANG_NOT_USEFUL, "2", "3", "4", "5 "..LANG_USEFUL })
	usefulComboBox.OnSelect = {
		function()
			if logComboEvent and feedbacks[currentFeedback].utility ~= usefulComboBox.selected then
				if Script.LuaUI.TraceAction then
					Script.LuaUI.TraceAction("assess_feedback_utility "..usefulComboBox.caption.." feedback_begin\n"..feedbacks[currentFeedback].feedback.."\nfeedback_end") -- registered by pp_meta_trace_manager.lua
				end
			end
			feedbacks[currentFeedback].utility = usefulComboBox.selected
		end
	}
	
	updateFeedbackFields ()
end

local function closeMainMenu ()
	if mainMenuWindow ~= nil then
		mainMenuWindow:Dispose()
		mainMenuWindow = nil
		saveWindow = nil
		saveNameEditBox = nil
		feedbackPanel = nil
		feedbackCanvas = nil
		nextFeedbackBt = nil
		prevFeedbackBt = nil
		clearComboBox = nil
		usefulComboBox = nil
		scoreLabel = nil
		numAttemptLabel = nil
		assessLabel = nil
		mainMenuCloseButton = nil
		-- reset data
		feedbacks = {}
		currentFeedback = 1
		logComboEvent = true
		if Script.LuaUI.ToggleHelpButton then
			Script.LuaUI.ToggleHelpButton() -- registered by pp_show_feedback.lua
		end		
		-- reopen tuto if required
		if tutoPopup then
			if rooms.TutoView and rooms.TutoView.closed then
				rooms.TutoView:Open()
			end
		end
	end
	if filterBackground ~= nil then
		filterBackground:Dispose()
		filterBackground = nil
	end
end

local function showFeedback ()
	mainMenuWindow = addWindow(WG.Chili.Screen0, "25%", "25%", "50%", "50%")
	
	if Script.LuaUI.ToggleHelpButton then
		Script.LuaUI.ToggleHelpButton() -- registered by pp_show_feedback.lua
	end
	
	-- add feedback panel
	displayFeedbackPanel(mainMenuWindow, "0%", "0%", "100%", "85%")
	
	-- close button
	mainMenuCloseButton = addButton(mainMenuWindow, "40%", "85%", "20%", "15%", LANG_CLOSE_BUTTON)
	mainMenuCloseButton.backgroundColor = { 0, 0.2, 0.6, 1 }
	mainMenuCloseButton.focusColor = { 0, 0.6, 1, 1 }
	mainMenuCloseButton.OnClick = { closeMainMenu } -- close Main menu if the window is visible
end

local function showMainMenu (missionEnd)
	closeMainMenu () -- close Main menu if the window is visible
	
	filterBackground = addImage(WG.Chili.Screen0, "0%", "0%", "100%", "100%", "bitmaps/editor/blank.png", false)
	filterBackground.color = {0, 0, 0, 0.9}
	filterBackground.OnClick = {
		function()
			return true -- Stop Clic event
		end
	}
	
	mainMenuWindow = addWindow(WG.Chili.Screen0, "12%", "12%", "76%", "76%")
	
	if Script.LuaUI.ToggleHelpButton then
		Script.LuaUI.ToggleHelpButton() -- registered by pp_show_feedback.lua
	end
	
	-- The window label
	local title = ""
	if missionEnd.state == "won" then
		title = LANG_VICTORY
	elseif missionEnd.state == "lost" then
		title = LANG_LOSS
	else
		title = "Menu"
	end
	local windowLabel = addLabel(mainMenuWindow, "40%", "0%", "50%", "20%", title, "left", "linecenter")
	windowLabel.fontsize = 40
	windowLabel.font.size = 40
	windowLabel.font.maxSize = 40
	
	if missionEnd.state ~= "menu" then -- means won or lost
		if traceOn then
			-- add score
			scoreLabel = addLabel(mainMenuWindow, "40%", "20%", "60%", "10%", LANG_SCORE..LANG_SCORE_COMPUTING, "left", "linecenter")
			
			-- add number of attemps
			numAttemptLabel = addLabel(mainMenuWindow, "40%", "30%", "60%", "10%", LANG_NUM_ATTEMPTS, "left", "linecenter")
			
			-- add feedbacks panel
			displayFeedbackPanel(mainMenuWindow, "40%", "40%", "60%", "60%")
			if feedbackPanel.visible then
				feedbackPanel:Hide() -- by default, we hide the panel
			end
		end
	else
		-- The close button
		mainMenuCloseButton = addImage(mainMenuWindow, "95%", "0%", "5%", "5%", "bitmaps/editor/close.png", true)
		mainMenuCloseButton.color = { 1, 0, 0, 1 }
		mainMenuCloseButton.OnClick = {
			function ()
				closeMainMenu () -- close Main menu if the window is visible
				-- reopen tuto if required
				if tutoPopup then
					if rooms.TutoView and rooms.TutoView.closed then
						rooms.TutoView:Open()
					end
				end
			end
		}
		mainMenuCloseButton.OnMouseOver = {
			function()
				if mainMenuCloseButton then
					mainMenuCloseButton.color = { 1, 0.5, 0, 1 }
				end
			end
		}
		mainMenuCloseButton.OnMouseOut = {
			function()
				if mainMenuCloseButton then
					mainMenuCloseButton.color = { 1, 0, 0, 1 }
				end
			end
		}
		
		-- add showBriefing button
		local showBriefingBut = addButton(mainMenuWindow, "0%", "0%", "30%", "10%", LANG_SHOW_BRIEFING)
		showBriefingBut.backgroundColor = { 0, 0.2, 0.6, 1 }
		showBriefingBut.focusColor = { 0, 0.6, 1, 1 }
		showBriefingBut.OnClick = {
			function ()
				closeMainMenu () -- close Main menu if the window is visible
				if Script.LuaUI.TraceAction then
					Script.LuaUI.TraceAction("show_briefing") -- registered by pp_meta_trace_manager.lua
				end
				if tutoPopup then
					if rooms.TutoView and rooms.TutoView.closed then
						rooms.TutoView:Open()
					end
				else
					Spring.SendLuaRulesMsg("Show briefing")
				end
			end
		}
	end
	
	-- add replay button
	local replayBut = addButton(mainMenuWindow, "0%", "10%", "30%", "10%", LANG_REPLAY_MISSION)
	replayBut.backgroundColor = { 0, 0.2, 0.6, 1 }
	replayBut.focusColor = { 0, 0.6, 1, 1 }
	replayBut.OnClick = {
		function ()
			closeMainMenu () -- close Main menu if the window is visible
			if Script.LuaUI.TraceAction then
				Script.LuaUI.TraceAction("replay_mission "..missionName) -- registered by pp_meta_trace_manager.lua
			end
			-- in case of appliq we don't use "_script.txt" because it doesn't work in case of multiplayer missions
			if Script.LuaUI.LoadMission then
				Script.LuaUI.LoadMission("Missions/"..missionName..".editor", {["MODOPTIONS"]=Spring.GetModOptions()}) -- registered by pp_restart_manager.lua
			else
				Spring.Echo("WARNING!!! Script.LuaUI.LoadMission == nil, probably a problem with \"PP Restart Manager\" Widget... => loading \"Missions/"..missionName..".editor\" aborted.")
			end
		end
	}
	
	-- check if we have to add the continue button
	-- first it depends if the player has achieved the end of the mission
	-- and if appliq is properly initialized
	if missionEnd.state ~= "menu" and mode=="appliq" and AppliqManager~=nil then
		local currentoptions=Spring.GetModOptions()
		AppliqManager:selectScenario(tonumber(currentoptions["scenario"]))
		AppliqManager:startRoute()
		local progression=unpickleProgression(currentoptions["progression"])
		AppliqManager:setProgression(progression)
		local nextMiss=AppliqManager:next(missionEnd.outputstate)  
		local mission=AppliqManager.currentActivityID
		-- second its depend on next mission available
		if (nextMiss==nil) then   
			Spring.Echo("IMPORTANT WARNING : no (or invalid) output state given while appliq mode is on. Scenario aborted... please fix your mission.")
		else
			-- is the last mission ?
			if(nextMiss=="end") then
				-- change menu label
				windowLabel:SetCaption(LANG_VICTORY_CAMPAIGN)
			else
				-- add continue button
				local currentInput=AppliqManager:getCurrentInputName()          
				currentoptions["currentinput"]=currentInput  
				currentoptions["missionname"]=mission
				currentoptions["currentinput"]=currentInput
				currentoptions["progression"]=pickle(AppliqManager.progressionOutputs)
				-- Reset activetraces property in case it changes between missions
				currentoptions["activetraces"]=nil
				local continueBut = addButton(mainMenuWindow, "0%", "30%", "30%", "10%", LANG_CONTINUE)
				continueBut.backgroundColor = { 0, 0.2, 0.6, 1 }
				continueBut.focusColor = { 0, 0.6, 1, 1 }
				continueBut.OnClick = {
					function ()
						closeMainMenu () -- close Main menu if the window is visible
						if Script.LuaUI.TraceAction then
							Script.LuaUI.TraceAction("continue_scenario "..missionName) -- registered by pp_meta_trace_manager.lua
						end
						if Script.LuaUI.LoadMission then
							Script.LuaUI.LoadMission("Missions/"..mission..".editor", {["MODOPTIONS"]=currentoptions}) -- registered by pp_restart_manager.lua
						else
							Spring.Echo("WARNING!!! Script.LuaUI.LoadMission == nil, probably a problem with \"PP Restart Manager\" Widget... => loading \"Missions/"..mission..".editor\" aborted.")
						end
					end
				}
			end
		end
	end
	
	-- check if we have to add the save button
	-- it depends if appliq is properly initialized
	if mode=="appliq" and AppliqManager~=nil then
		local saveBut = addButton(mainMenuWindow, "0%", "70%", "30%", "10%", LANG_SAVE_PROGRESSION)
		saveBut.backgroundColor = { 0, 0.2, 0.6, 1 }
		saveBut.focusColor = { 0, 0.6, 1, 1 }
		saveBut.OnClick = {
			function ()
				if Script.LuaUI.TraceAction then
					Script.LuaUI.TraceAction("save_progression") -- registered by pp_meta_trace_manager.lua
				end
				if mainMenuWindow.visible then
					mainMenuWindow:Hide()
				end
				displaySaveWindow()
			end
		}
	end
	
	-- quit mission button
	local quitMissionBut = addButton(mainMenuWindow, "0%", "80%", "30%", "10%", LANG_QUIT_MISSION)
	quitMissionBut.backgroundColor = { 0, 0.2, 0.6, 1 }
	quitMissionBut.focusColor = { 0, 0.6, 1, 1 }
	quitMissionBut.OnClick = {
		function ()
			if Script.LuaUI.TraceAction then
				Script.LuaUI.TraceAction("quit_mission "..missionName) -- registered by pp_meta_trace_manager.lua
			end
			WG.switchOnMenu()
		end
	}
	
	-- quit game button
	local quitGameBut = addButton(mainMenuWindow, "0%", "90%", "30%", "10%", LANG_QUIT_GAME)
	quitGameBut.backgroundColor = { 0, 0.2, 0.6, 1 }
	quitGameBut.focusColor = { 0, 0.6, 1, 1 }
	quitGameBut.OnClick = {
		function ()
			if Script.LuaUI.TraceAction then
				Script.LuaUI.TraceAction("quit_game") -- registered by pp_meta_trace_manager.lua
			end
			Spring.SendCommands("quitforce")
		end
	}
end

function MissionEvent(e)
  
  if e.logicType == "ShowMissionMenu" then
	if e.team == nil or e.team == Spring.GetMyTeamID() then
		if e.state and (e.state == "won" or e.state == "lost") then
			if Script.LuaUI.MissionEnded then
				Script.LuaUI.MissionEnded(e.state) -- function defined and registered in Meta Traces Manager widget
			end
			Spring.SetConfigString("victoryState", e.state, 1) -- inform the game engine that the mission is ended
		end
		
		-- close tuto window if it oppened
		if tutoPopup then
		  if rooms.TutoView and not rooms.TutoView.closed then
			rooms.TutoView:Close()
		  end
		end
		-- close briefing window if it oppened
		WG.Message:DeleteAll()
		-- replace Main menu by a single message if we are testing map
		if (Spring.GetModOptions()["testmap"]~=nil) then
			-- if we are in testmap case, the main menu is only simple message
			-- the button "return back to editor" is permanently displayed in UI
			local message = ""
			if e.state == "won" then
				message = LANG_VICTORY
			elseif e.state == "lost" then
				message = LANG_LOSS
			else
				message = LANG_WARNING_STATE
			end
			MissionEvent({logicType = "ShowMessage",message = message, width = 500,pause = false})
		else
			showMainMenu(e)
		end
	end

  elseif e.logicType == "ShowMessage" then
      if e.image then 
        briefingPopup = WG.Message:Show{
          texture = ":n:LuaUI/Images/"..e.image,
          text = e.message,
          width = e.imageWidth,
          height = e.imageHeight,
          pause = e.pause,
        }
      else
        briefingPopup = WG.Message:Show{text = e.message, width = e.width, pause = e.pause}
      end
	  if rooms.Video and not rooms.Video.closed then
		briefingPopup.delayDrawing = true
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
  if rooms.Video and not rooms.Video.closed then
    rooms.Video:Close()
  end
  if not tutoPopup then 
    tutoPopup = true
    rooms.TutoView:Open()
  end
end

function PlayVideo()
  if rooms.Video and rooms.Video.closed then
    rooms.Video:Open()
  end
end

function getFeedbackToString(json_obj, export_score)
	local s = ""
	if json_obj.score ~= nil and export_score then
		s = s..LANG_SCORE..json_obj.score.." / 100\n"
	end
	if json_obj.num_attempts ~= nil and export_score then
		s = s..LANG_NUM_ATTEMPTS..json_obj.num_attempts.."\n"
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
	if json_obj.warnings ~= nil and #json_obj.warnings > 0 then
		for i = 1,#json_obj.warnings do
			s = s..json_obj.warnings[i].."\n"
		end
	end
	if json_obj.feedbacks ~= nil and #json_obj.feedbacks > 0 then
		for i = 1,#json_obj.feedbacks do
			s = s..json_obj.feedbacks[i].."\n"
		end
	end
	return s
end

-- if main menu is openned => update feedback canvas to display feedbacks
-- if main menu is not openned => show feedback in a popup
function handleFeedback(str)
	-- check if the feedback is consistent
	if str == "" or str == "{}" then 
		if scoreLabel and scoreLabel.visible then
			scoreLabel:Hide()
		end
		if numAttemptLabel and numAttemptLabel.visible then
			numAttemptLabel:Hide()
		end
	else
		local json_obj = json.decode(str)
		-- parse all feedbacks and define default clearness and utility
		local newFeedbacks = {}
		if json_obj.warnings then
			for i = 1,#json_obj.warnings do
				table.insert (newFeedbacks,
					{
						feedback="\255\255\0\0"..json_obj.warnings[i].."\255\255\255\255",
						clearness = 1,
						utility = 1
					}
				)
			end
		end
		if json_obj.feedbacks then
			for i = 1,#json_obj.feedbacks do
				table.insert (newFeedbacks,
					{
						feedback=json_obj.feedbacks[i],
						clearness = 1,
						utility = 1
					}
				)
			end
		end
		feedbacks = newFeedbacks
		currentFeedback = 1
		local feedbackToLog
		if json_obj.won ~= nil then -- the mission is over
			feedbackToLog = getFeedbackToString(json_obj, true)
			Spring.SetConfigString("score", json_obj.score, 1) -- save the score for the engine
			-- display score
			if scoreLabel then
				scoreLabel:SetCaption(LANG_SCORE.."\255"..colorTable[101-json_obj.score]..colorTable[json_obj.score+1].."\0"..json_obj.score.." / 100")
			end
			-- display number of attempts
			if numAttemptLabel then
				numAttemptLabel:SetCaption(LANG_NUM_ATTEMPTS..json_obj.num_attempts)
			end
			-- update feedback panel
			if #feedbacks > 0 then
				if feedbackPanel.hidden then
					feedbackPanel:Show()
				end
				updateFeedbackFields ()
			end
		else -- the mission is not over yet
			feedbackToLog = getFeedbackToString(json_obj, false)
			
			-- close Main menu if the window is visible
			if mainMenuWindow then
				closeMainMenu() 
				-- WARNING!!!  closing main menu erase feedbacks so we restore them
				-- before showing them again
				feedbacks = newFeedbacks
			end
			
			-- close tuto if it is openned
			if tutoPopup then
				if rooms.TutoView and not rooms.TutoView.closed then
					rooms.TutoView:Close()
				end
			end
			
			-- show feedbacks popup
			showFeedback ()
		end
		if Script.LuaUI.TraceAction then
			Script.LuaUI.TraceAction("feedbacks_begin\n"..feedbackToLog.."feedbacks_end") -- registered by pp_meta_trace_manager.lua
		end
	end
end

function widget:KeyPress(key, mods, isRepeat, label, unicode)
	-- intercept ESCAPE pressure
	if key == KEYSYMS.ESCAPE then
		if rooms.Video and not rooms.Video.closed then
			rooms.Video:Close()
			if briefingPopup ~= nil then
				briefingPopup.delayDrawing = false
			end
			if Script.LuaUI.ToggleHelpButton then
				Script.LuaUI.ToggleHelpButton() -- registered by pp_show_feedback.lua
			end
		else
			if rooms.TutoView and not rooms.TutoView.closed then
				rooms.TutoView:Close()
			end
			if Spring.GetModOptions()["testmap"]~=nil then
				Spring.SendLuaRulesMsg("Show briefing")
			else
				if mainMenuWindow == nil then
					MissionEvent ({logicType = "ShowMissionMenu",
					state = "menu"})
				else
					-- close Main menu if the close button is Shown
					if mainMenuCloseButton and mainMenuCloseButton.visible then
						closeMainMenu () -- close Main menu if the window is visible
						-- reopen tuto if required
						if tutoPopup then
							if rooms.TutoView.closed then
								rooms.TutoView:Open()
							end
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

function widget:RecvLuaMsg(msg, player)
  if player == Spring.GetMyPlayerID() then
	if((msg~=nil)and(string.len(msg)>8)and(string.sub(msg,1,8)=="Feedback")) then -- received from game engine (ProgAndPlay.cpp)
		local jsonfile=string.sub(msg,10,-1) -- we start at 10 due to an underscore used as a separator
		handleFeedback(jsonfile)
	end
  end
end

function widget:Initialize()
  widgetHandler:RegisterGlobal("EmulateEscapeKey", EmulateEscapeKey)
  widgetHandler:RegisterGlobal("MissionEvent", MissionEvent)
  widgetHandler:RegisterGlobal("TutorialEvent", TutorialEvent)
  widgetHandler:RegisterGlobal("PlayVideo", PlayVideo)
  
  rooms = WG.rooms -- WG is available in all widgets (defined in pp_gui_rooms.lua)
end


function widget:Shutdown()
  widgetHandler:DeregisterGlobal("EmulateEscapeKey")
  widgetHandler:DeregisterGlobal("MissionEvent")
  widgetHandler:DeregisterGlobal("TutorialEvent")
  widgetHandler:DeregisterGlobal("PlayVideo")
end