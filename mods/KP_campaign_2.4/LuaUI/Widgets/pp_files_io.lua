

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

--[[local testmode = Spring.GetModOptions()["testmode"] -- if yes => we test a bunch of missions, containing tests or not
local listMissionToTest = unpickle(Spring.GetModOptions()["listmissionstotest"]) --list of missions to test--]]
local testmode="no"
local listMissionToTest = {"mission1","mission2","mission3","mission4","mission5","mission6","mission7","mission8"} --TEMP TO TEST

local currentMissionToTest_index=1 -- starting index
local jsonPath="Missions/jsonFiles/"
local jsonFile


function WriteMessageInFile(e)
  if e.stringToWrite ~= nil and e.fileName ~= nil then
    local f=io.open(e.fileName, e.mode) -- mode such as w, a ...
    io.output(f)
    io.write(e.stringToWrite.."\n")
    io.close(f)
 end
end

function loadJson(e)
  if(e.missionName~=nil)and(Spring.GetModOptions()["hardcoded"]~="yes") then --TODO: Should be placed elsewhere than in pp_mission_gui
    local jsonName=e.missionName..".json"
    local mode=VFS.ZIP_FIRST
    if(Spring.GetModOptions()["jsonlocation"]=="external") then
      mode=VFS.RAW_FIRST
    end
    jsonFile= VFS.LoadFile(jsonPath..jsonName,mode)
    Spring.SendLuaRulesMsg("mission"..jsonFile)
  end
end

-- different behavior if mode test 
function loadProperJson()
  Spring.Echo("try to load 3")
  local  missionToLoad=missionName
  if(testmode=="yes") then
    if(currentMissionToTest_index<=table.getn(listMissionToTest)) then
      missionToLoad=listMissionToTest[currentMissionToTest_index]
      local m={stringToWrite = missionToLoad,fileName = "errors.txt", mode="a"}
      WriteMessageInFile(m)
      currentMissionToTest_index=currentMissionToTest_index+1
    else
      Spring.SendCommands("Pause") 
      return
    end   
  end
  --Sleep(1000)
  Spring.Echo("try to load 4")
  loadJson({missionName=missionToLoad}) -- mission
end
-------------------------------------
-- Initialize the widget
-------------------------------------
function widget:Initialize()
  widgetHandler:RegisterGlobal("WriteMessageInFile", WriteMessageInFile)
  widgetHandler:RegisterGlobal("loadProperJson", loadProperJson)
  local m={stringToWrite = "start_tests",fileName = "errors.txt", mode="w"}
  WriteMessageInFile(m)
  Spring.Echo("try to load 0")
  loadProperJson()
end

function widget:Shutdown()
  widgetHandler:DeregisterGlobal("WriteMessageInFile")
end