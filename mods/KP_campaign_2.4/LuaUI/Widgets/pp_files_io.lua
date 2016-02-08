

function widget:GetInfo()
  return {
    name      = "Files IO",
    desc      = "Read and write external files, authorized only in widget",
    author    = "martin",
    date      = "Feb 08 2016",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true, --  loaded by default?
  }
end

VFS.Include("LuaUI/Widgets/libs/Pickle.lua",nil) 

local campaign = VFS.Include ("campaign.lua") -- the default campaign of Prog&Play
local lang = Spring.GetModOptions()["language"] -- get the language
local scenarioType = Spring.GetModOptions()["scenario"] -- get the type of scenario default or index of scenario in appliq file
local missionName = Spring.GetModOptions()["missionname"] -- get the name of the current mission
local jsonPath="Missions/jsonFiles/"
local jsonFile


function WriteMessageInFile(e)
  if e.stringToWrite ~= nil and e.fileName ~= nil then
    local f=io.open(e.fileName, e.mode) -- mode such as w, a ...
    io.output(f)
    io.write(e.stringToWrite)
    io.close(f)
 end
end
-------------------------------------
-- Initialize the widget
-------------------------------------
function widget:Initialize()
  widgetHandler:RegisterGlobal("WriteMessageInFile", WriteMessageInFile)
  if(missionName~=nil)and(Spring.GetModOptions()["hardcoded"]~="yes") then --TODO: Should be placed elsewhere than in pp_mission_gui
    local jsonName=missionName..".json"
    if(missionName~=nil)and(Spring.GetModOptions()["jsonlocation"]~="internal") then
      local file = assert(io.open(jsonPath..jsonName))
      local jsonFile = file:read'*a'
      Spring.SendLuaRulesMsg("mission"..jsonFile)
      file:close()
    else 
      jsonFile=VFS.LoadFile(jsonPath..jsonName)
      Spring.SendLuaRulesMsg("mission"..jsonFile)
    end
  end
end

function widget:Shutdown()
  widgetHandler:DeregisterGlobal("WriteMessageInFile")
end