-- $Id: room_FPSManager.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info: FPS Manager
--
--
-- Tries to keep the framerate around 35 by adjusting the detail level.
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Speed-ups
--


local Window        = Window
local Tab           = Tab
local SendCommands  = Spring.SendCommands
local GetFPS        = Spring.GetFPS


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Constants
--


local tolerance  = 30


local defaultLevelTable = { 
  {"advshading 1",                  "advshading 0"}, -- 1
  {"luaui disablewidget BlobShadow", "luaui enablewidget BlobShadow"}, -- 2
  {"shadows 1 1024",                "shadows 0"}, -- 3
  {"maxparticles 10000",            "maxparticles 5000"}, -- 4
  {"water 1",                       "water 0"}, -- 5
  {"shadows 1 2048",                "shadows 1 1024"}, -- 6
  {"water 3",                       "water 1"}, -- 7
  {"shadows 4096",                  "shadows 1 2048"}, -- 8
  {"maxparticles 15000",            "maxparticles 10000"}, -- 9
  {"maxparticles 20000",            "maxparticles 15000"}, -- 10
  {"dynamicsky 1",                  "dynamicsky 0"}, -- 11
  {"water 2",                       "water 3"}, -- 12
} 


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Locals
--


local counter       = 0
local detailLevel   = 1
local fpsTable      = {}
local raisePoints   = 0
local lowerPoints   = 0
minFps = 30
maxFps = 40
      
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- FPS Management
--


function MakeManagerText()
  local s
  if (enabled) then
    s = "enabled."
  else
    s = "disabled."
  end
  local lines = {
    "The Frame Rate Manager tries to keep the framerate ",
    string.format("around %d by adjusting the detail level. ", (minFps+maxFps)/2),
    " ",
    "It is "..s,
  }
  return lines
end


local function Remove(n)
  table.remove(levelTable, n)
end


local function MakeLevelTable()
  levelTable = Copy(defaultLevelTable)
  local st = settingsTable
  if (st.noWater3 or st.noWater) then
    Remove(12)
  end
  if (st.noDynSky) then
    Remove(11)
  end
  if (st.noMaxParticles) then
    Remove(10)
    Remove(9)
  end
  if (st.noShadows) then
    Remove(8)
  end
  if (st.noWater) then
    Remove(7)
  end
  if (st.noShadows) then
    Remove(6)
  end
  if (st.noWater) then
    Remove(5)
  end
  if (st.noMaxParticles) then
    Remove(4)
  end
  if (st.noShadows) then
    Remove(3)
  end
  if (st.noBlobs) then
    Remove(2)
  end
  if (st.noAdvShad) then
    Remove(1)
  end
end


local function RaiseDetail()
  raisePoints = raisePoints + 1
  if ((detailLevel <= #levelTable) and
      (raisePoints > tolerance)) then
    SendCommands({levelTable[detailLevel][1]})
    detailLevel = detailLevel + 1
	raisePoints = 0
  end
end


local function LowerDetail()
  lowerPoints = lowerPoints + 1
  if ((detailLevel > 1) and
      (lowerPoints > tolerance)) then
    SendCommands({levelTable[detailLevel - 1][2]})
    detailLevel = detailLevel - 1
    lowerPoints = 0
  end
end


local function OnUpdate(t)
  if (enabled) then
    counter  = counter + 1
    table.insert(fpsTable, GetFPS())
    if (#fpsTable > 30) then
      table.remove(fpsTable, 1)
    end
    if ((counter+23) % 30 < 0.1) then
      counter = 0
      sum = 0
      for _, v in ipairs(fpsTable) do
        sum = sum + v
      end
      average = (sum / #fpsTable)
      if (average > maxFps) then
        RaiseDetail()
      else
        raisePoints = 0
      end
      if (average < minFps) then
        LowerDetail()
      else
        lowerPoints = 0
      end
    end
  end
end


local function GetConfigData() -- Save
  room_FPSManager = { 
    enabled = enabled,
    settingsTable = settingsTable,
    minFps = minFps,
    maxFps = maxFps,
  }
  return "room_FPSManager", room_FPSManager
end


local function SetConfigData(data) -- Load  
  if data.room_FPSManager then
    enabled = data.room_FPSManager.enabled
    settingsTable = data.room_FPSManager.settingsTable or {}
    maxFps = data.room_FPSManager.maxFps or 40
    minFps = data.room_FPSManager.minFps or 30
  else
    data.room_FPSManager = {}
    enabled = false
    settingsTable = {}
    maxFps = 40
    minFps = 30
  end 
  if (enabled) then
    levelTable = Copy(defaultLevelTable)
    detailLevel = #levelTable
    for i=1, tolerance*15 do
      LowerDetail()
    end
  end
  detailLevel = 1
  MakeLevelTable()
  managerOptions.lineArray =  MakeManagerText()
  moreOptions.lineArray = MakeOptionsText()
end


local function MakeOptionsButton(label, setting)
  local tab = {
    title = label,
    position = "left",
    OnMouseReleaseAction = function()
      if (settingsTable[setting]) then
        settingsTable[setting] = nil
      else
        settingsTable[setting] = true
      end
      MakeLevelTable()
      moreOptions.lineArray = MakeOptionsText()
    end,
  }
  return tab
end


managerOptions = Window:Create{
  lineArray = MakeManagerText(),
  group = "FPSManager",
  closed = true,
  OnUpdate = OnUpdate,
  GetConfigData = GetConfigData,
  SetConfigData = SetConfigData,
  tabs = {
    {title = "Frame Rate Manager"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {title = "Enable",
      position = "left",
      OnMouseReleaseAction = function()
        enabled = true
        managerOptions.lineArray =  MakeManagerText()
      end,
    },
    {title = "Disable",
      position = "left",
      OnMouseReleaseAction = function()
        enabled = nil
        managerOptions.lineArray =  MakeManagerText()
      end
    },
    {title = "Options",
      position = "left",
      OnMouseReleaseAction = function()
        managerOptions:Close()
        moreOptions:Open()
      end
    },
  }, 
}


local function Check(setting, o)
  if (settingsTable[setting] and not o) then
    return "disabled."
  elseif (not o) then
    return "enabled."
  elseif (settingsTable[setting] and o) then
    return "disallowed."
  else
    return "allowed."
  end
end


function MakeOptionsText()
  local st = settingsTable
  local lines = {
  string.format("The target frame rate is %d (%d - %d)", 
                (minFps+maxFps)/2, minFps, maxFps),
  "Sky management is "..Check("noDynSky"),
  "Dynamic water is "..Check("noWater3", true),
  "Shadow management is "..Check("noShadows"),
  "Water management is "..Check("noWater"),
  "Particle management is "..Check("noMaxParticles"),
  "Blob aircraft shadows are "..Check("noBlobs", true),
  "Unit shading management is "..Check("noAdvShad"),
  " ",
  "Blob shadows require the BlobShadows widget.",
  }
  return lines
end


moreOptions = Window:Create{
  lineArray = {"Blob shadows require the BlobShadows widget."},
  group = "FPSManager",
  closed = true,
  tabs = {
    {title = "Frame Rate Manager: Options"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "managerOptions"}},
    MakeOptionsButton("Toggle Sky Management", "noDynSky"),
    MakeOptionsButton("Allow Dynamic Water", "noWater3"),
    MakeOptionsButton("Toggle Shadow management", "noShadows"),
    MakeOptionsButton("Toggle Water Management", "noWater"),
    MakeOptionsButton("Toggle Particle Management", "noMaxParticles"),
    MakeOptionsButton("Allow Blob Shadows", "noBlobs"),
    MakeOptionsButton("Toggle Unit Shading Management", "noAdvShad"),
    {title = "Decrease Target FPS",
      position = "bottom",
      OnMouseReleaseAction = function()
        maxFps = maxFps * .8
        minFps = minFps * .8
         moreOptions.lineArray = MakeOptionsText()
         managerOptions.lineArray =  MakeManagerText()
      end,
    },
    {title = "Increase Target FPS",
      position = "bottom",
      OnMouseReleaseAction = function()
        maxFps = maxFps * 1.2
        minFps = minFps * 1.2
         moreOptions.lineArray = MakeOptionsText()
         managerOptions.lineArray =  MakeManagerText()
      end,
    },
  }
}

