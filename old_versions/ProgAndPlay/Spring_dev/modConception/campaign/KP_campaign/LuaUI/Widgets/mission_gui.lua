-- $Id: mission_gui.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Mission GUI",
    desc      = "Turning this off might disrupt the mission.",
    author    = "quantum, muratet",
    date      = "Jan 15, 2009",
    license   = "GPL v2 or later",
    layer     = 91,
    enabled   = true --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- You must import the KEYSYM table if you want to access keys by name
include('keysym.h.lua')

local function PlaySound(fileName, ...)
  local path = "LuaUI/Sounds/"..fileName
  if VFS.FileExists(path) then
    Spring.PlaySoundFile(path, ...)
  else
    print("Error: file "..path.." doest not exist.")
  end
end

-- create our delete this file to inform game engine that a mission is ended or not
local tmpFileName = "mission_ended.conf"
-- create the file => mission is ended
local function createTmpFile()
	if not VFS.FileExists(tmpFileName) then
		local f = io.open(tmpFileName, "w")
		if f ~= nil then
			f:flush()
			f:close()
		end
	end
end
-- delete the file => mission is not ended
local function deleteTmpFile()
	if VFS.FileExists(tmpFileName) then
		os.remove(tmpFileName)
	end
end

local rooms = WG.rooms -- availabe in all widgets
local Window = rooms.Window
local Tab = rooms.Tab

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
				tabs = {
					{preset = function(tab)
							tab.title = "Previous mission"
							tab.position = "bottom"
							tab.OnClick = function()
								deleteTmpFile()
								Spring.SendLuaRulesMsg("Previous mission")
								tab.parent:Close()
							end
						end
					},
					{preset = function(tab)
							tab.title = "Replay mission"
							tab.position = "bottom"
							tab.OnClick = function()
								deleteTmpFile()
								Spring.SendLuaRulesMsg("Replay mission")
								tab.parent:Close()
							end
						end
					},
					{preset = function(tab)
							tab.title = "Next mission"
							tab.position = "bottom"
							tab.OnClick = function()
								deleteTmpFile()
								Spring.SendLuaRulesMsg("Next mission")
								tab.parent:Close()
							end
						end
					},
					{preset = function(tab)
							tab.title = "Quit the game"
							tab.position = "right"
							tab.OnClick = function()
								createTmpFile()
								Spring.SendCommands("quitforce")
								tab.parent:Close()
							end
						end
					},
					{preset = function(tab)
							tab.title = "Close menu"
							tab.position = "right"
							tab.OnClick = function()
								tab.parent:Close()
							end
						end
					},
					{preset = function(tab)
							tab.title = "Show briefing"
							tab.position = "top"
							tab.OnClick = function()
								Spring.SendLuaRulesMsg("Show briefing")
								tab.parent:Close()
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

function MissionEvent(e)
  if e.logicType == "GuiEndMissionAction" then
	  -- load templated mission
		local popup = deepcopy(template_endMission)
		-- update window
		if e.gameOver ~= "menu" then
			popup.lineArray = {"You "..e.gameOver.." the mission"}
			-- disable Close tab and Show briefing
			popup.tabs[5] = nil
			-- inform the game that mission is over with a temporary file
			createTmpFile()
		else
			popup.lineArray = {"Menu"}
		end
		if e.posMission == "first" or e.posMission == "replay" then
			popup.tabs[1] = deepcopy(emptyTab)
			popup.tabs[1].title = "\255\50\50\50Previous mission\255\255\255\255"
		end
		if e.posMission == "last" or e.gameOver == "lost" or e.posMission == "replay" then
			popup.tabs[3] = deepcopy(emptyTab)
			popup.tabs[3].title = "\255\50\50\50Next Mission\255\255\255\255"
		end
		-- create window
		if winPopup ~= nil then
			winPopup:Close()
			winPopup = nil
		end
		winPopup = Window:Create(popup)
		-- window centering
		-- compute window centering
		local winSizeX, winSizeY = Spring.GetWindowGeometry()
		local winCenterX = winSizeX/2
		local winCenterY = winSizeY/2
		-- compute popup target position (bottom left corner)
		local targetPopupX = winCenterX - (winPopup.x2 - winPopup.x1)/2
		local targetPopupY = winCenterY - (winPopup.y2 - winPopup.y1)/2
		-- compute delta between current position and target position
		local dX = winPopup.x1 - targetPopupX
		local dY = winPopup.y1 - targetPopupY
		-- update all positions
		winPopup.x = winPopup.x - dX
		winPopup.y = winPopup.y - dY
		winPopup.x1 = winPopup.x1 - dX
		winPopup.y1 = winPopup.y1 - dY
		winPopup.x2 = winPopup.x2 - dX
		winPopup.y2 = winPopup.y2 - dY
		-- recreate it centered
		winPopup:Create()
		-- and open it
		winPopup:Open()
	elseif e.logicType == "GuiMessageAction" then
    if e.image then 
      WG.Message:Show{
        texture = ":n:LuaUI/Images/"..e.image,
        text = e.message,
        width = e.imageWidth,
        height = e.imageHeight,
        pause = e.pause,
      }
    else
      WG.Message:Show{text = e.message, width = e.width, pause = e.pause}
    end
  elseif e.logicType == "PauseAction" then
    Spring.SendCommands"pause"
  elseif e.logicType == "MarkerPointAction" then
    local height = Spring.GetGroundHeight(e.x, e.y)
    Spring.MarkerAddPoint(e.x, height, e.y, e.text)
    if e.centerCamera then
      Spring.SetCameraTarget(e.x, height, e.y, 1)
    end
  elseif e.logicType == "SoundAction" then
    PlaySound(e.sound)
  end
end

function widget:KeyPress(key, mods, isRepeat, label, unicode)
	-- intercept ESCAPE pressure
	if key == KEYSYMS.ESCAPE then
		MissionEvent{logicType = "GuiEndMissionAction",
				gameOver = "menu",
				posMission = "replay"}
		return true
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
	deleteTmpFile()
  widgetHandler:RegisterGlobal("MissionEvent", MissionEvent)
end


function widget:Shutdown()
	createTmpFile()
  widgetHandler:DeregisterGlobal("MissionEvent")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------