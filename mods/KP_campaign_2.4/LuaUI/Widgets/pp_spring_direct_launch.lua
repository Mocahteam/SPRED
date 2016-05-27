function widget:GetInfo()
  return {
    name    = "Chili Hello World",
    desc    = "",
    author  = "",
    date    = "",
    license = "GNU GPL v2",
    layer   = 20,
    enabled = true,
    handler = true
  }
end
local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
VFS.Include("LuaRules/Gadgets/libs/FillModSpecific.lua",nil)
VFS.Include("LuaRules/Gadgets/libs/ColorConversion.lua",nil)
VFS.Include("LuaRules/Gadgets/libs/GenerateGame.lua",nil)
VFS.Include("LuaRules/Gadgets/libs/WriteScript.lua",nil)

VFS.Include("LuaUI/Widgets/libs/RestartScript.lua",nil) -- contain DoTheRestart function
VFS.Include("LuaUI/Widgets/libs/Pickle.lua",nil) 

-- load Appliq XML
VFS.Include("LuaUI/Widgets/libs/context.lua")
contx=context:new("C:/Users/Bruno/Documents/ProgPlayLIP6/spring-0.82.5.1/",rootDirectory,"LuaUI/Widgets/libs/") -- Not sure that spring is working
Spring.Echo(contx.springIsAvailable)
VFS.Include("LuaUI/Widgets/libs/AppliqManager.lua")

local xmlFiles = VFS.DirList("scenario/", "*.xml")

local RemovedWidgetList = {}
local Chili, Screen0
local Chili, Screen0 -- Chili framework, main screen
local helloWorldWindow
local helloWorldLabel
local InitializeTimer = nil
local TextLocale = {
  fr = {back="Retour", continue="Continuer la derni�re partie", SelectScenario="Nouvelle partie", quit="Quitter", specificMission="Jouer une mission pr�cise", whichScenario="Choisissez un scenario", whichMission="Choisissez une mission"},
  en = {back="Back", continue="Continue previous game", SelectScenario="New game", quit="Quit", specificMission="Play a specific mission", whichScenario="Choose a scenario", whichMission="Choose a mission"}
}
local UI = {} -- Contains each UI element

function hideDefaultGUI()
  -- get rid of engine UI
  Spring.SendCommands("resbar 0","fps 1","console 0","info 0", "tooltip 0") -- TODO : change fps 1 to fps 0 in release
  -- leaves rendering duty to widget (we won't)
  gl.SlaveMiniMap(true)
  -- a hitbox remains for the minimap, unless you do this
  gl.ConfigMiniMap(0,0,0,0)
end

function initChili() -- Initialize Chili variables
  if (not WG.Chili) then -- If the chili widget is not found, remove this widget
    widgetHandler:RemoveWidget()
    return
  end

  -- Get ready to use Chili
  Chili = WG.Chili
  Screen0 = Chili.Screen0
end

local function removeWidgets(self)
  -- disable console
  Spring.SendCommands("tooltip 0")
  Spring.SendCommands("minimap min")
  Spring.SendCommands("endgraph 0")
  Spring.SendCommands("hideinterface 0")
  Spring.SendCommands("resbar 0","fps 1","console 0","info 0", "tooltip 0") -- TODO : change fps 1 to fps 0 in release
  -- leaves rendering duty to widget (we won't)
  gl.SlaveMiniMap(true)
  -- a hitbox remains for the minimap, unless you do this
  gl.ConfigMiniMap(0,0,0,0)
  for name, w in pairs(widgetHandler.knownWidgets) do
    if w.active and name ~= "Chili Hello World" and name ~= "Chili Framework" then
      widgetHandler:DisableWidget(name)
    end
  end
end

local function French()
  lang = "fr"
  FunctionsList.NewGameOrContinue()
end

local function English()
  lang = "en"
  FunctionsList.NewGameOrContinue()
end

local function Quit()
  Spring.SendCommands("quit")
  Spring.SendCommands("quitforce")
end

local function RunScenario(i)
  if Spring.Restart then
    --Spring.Echo(json.encode(AppliqManager.treehandler.root.games.game))
    AppliqManager:selectScenario(i)
    AppliqManager:startRoute()
    --AppliqManager:setProgression({"1630","1638"})
    --AppliqManager:next("1630")
    Spring.Echo(json.encode(AppliqManager.treehandler.root.games.game))    
    local mission=AppliqManager:getActivityNameFromId(AppliqManager.currentActivityID)
    local currentInput=AppliqManager:getCurrentInputName()
    Spring.Echo(currentInput)
    local options={
    ["MODOPTIONS"]=
      {
      ["scenariomode"]="appliq",
      ["language"]=lang,
      ["scenario"]=i, --Todo: Should be an id instead
      --["missionname"]=mission,
      ["currentinput"]=currentInput,
      ["progression"]=pickle(AppliqManager.progressionOutputs)
      }
    }
    local contextFile=true
    --Spring.Echo(json.encode(AppliqManager.treehandler.root.games.game))
    --Spring.Echo(mission)
    --Spring.Echo(json.encode(options))
    genericRestart("Missions/"..Game.modShortName.."/"..mission..".editor",options,contextFile)
    --DoTheRestart("Missions/"..Game.modShortName.."/"..mission..".txt", options)
  else
    NoRestart()
  end
end

local function Capitalize(str)
  return string.gsub (str, "(%w)(%w*)", function(a,b) return string.upper(a) .. b end)
end

local function MissionsMenu()
  RemoveAllFrames()
  AddFrame("Prog&Play! "..TextLocale[lang].whichMission,{x=vsx*0.5,y=vsy*0.98},vsy/14,{0,1,1,0.5},"ct","c")
  local MissionsList=VFS.DirList("Missions/"..Game.modShortName)
  local ItemSize=math.min((vsy*(1-1/6))/(2*(#MissionsList+1))-2,vsy/24)
  for MissionIndex,MissionFileName in ipairs(MissionsList) do
    local EndIndex=(string.find(MissionFileName,".",1,true) or 1+string.len(MissionFileName))-1
    -- the fourth argument (true) avoid considering "." as joker and do a plain search instead
    local BeginIndex=1
    repeat
      local NewBeginIndex=string.find(MissionFileName,"/",BeginIndex,true) or string.find(MissionFileName,"\\",BeginIndex,true)
      BeginIndex=NewBeginIndex and NewBeginIndex+1 or BeginIndex
    until not NewBeginIndex
    AddFrame(Capitalize(string.sub(MissionFileName,BeginIndex,EndIndex)),{x=vsx*0.5,y=vsy*(1-1/6)-2*MissionIndex*(2+ItemSize)},ItemSize,{0,1,0,0.5},"cb","c",RunScript,MissionFileName, "noScenario")
  end
  AddFrame(TextLocale[lang].back,{x=vsx*0.5,y=0},ItemSize*0.8,{0,0,1,0.5},"cb","c",FunctionsList.NewGameOrContinue)
end

function EitherDrawScreen(vsx, vsy) -- Shows a black background if required
  
  local bgText = "bitmaps/editor/blank.png"
  gl.Blending(false)
  gl.Color(0, 0, 0, 0)
  gl.Texture(bgText)
  gl.TexRect(vsx, vsy, 0, 0, 0, 0, 1, 1)
  gl.Texture(false)
  gl.Blending(true)
end


function InitializeMainMenu() -- Initialize the main window and buttons of the main menu
  UI.MainWindow = Chili.Window:New{
    parent = Screen0,
    x = "0%",
    y = "0%",
    width  = "100%",
    height = "100%",
    draggable = false,
    resizable = false
  }
  UI.Logo = Chili.Image:New{
    parent = UI.MainWindow,
    x = '0%',
    y = '80%',
    width = '20%',
    height = '20%',
    keepAspect = false,
    file = "bitmaps/launcher/su.png"
  }
  UI.Title = Chili.Label:New{
    parent = UI.MainWindow,
    x = '0%',
    y = '0%',
    width = '100%',
    height = '10%',
    align = "center",
    valign = "center",
    caption = LAUNCHER_TITLE,
    font = {
      font = "LuaUI/Fonts/Asimov.otf",
      size = 60,
      color = { 0.2, 0.6, 0.8, 1 }
    }
  }
  UI.NewMissionButton = Chili.Button:New{
    parent = UI.MainWindow,
    x = "30%",
    y = "30%",
    width = "40%",
    height = "10%",
    caption = "Nouvelle Partie",
    OnClick = { Spring.Echo("Nouvelle Partie") },
    font = {
      font = "LuaUI/Fonts/Asimov.otf",
      size = 40,
      color = { 0.2, 1, 0.8, 1 }
    }
  }
  UI.EditMissionButton = Chili.Button:New{
    parent = UI.MainWindow,
    x = "30%",
    y = "40%",
    width = "40%",
    height = "10%",
    caption = "Liste des missions",
    OnClick = { Spring.Echo("Liste des missions") },
    font = {
      font = "LuaUI/Fonts/Asimov.otf",
      size = 40,
      color = { 0.2, 1, 0.8, 1 }
    }
  }
--  UI.EditScenarioButton = Chili.Button:New{
--    parent = UI.MainWindow,
--    x = "30%",
--    y = "50%",
--    width = "40%",
--    height = "10%",
--    caption = LAUNCHER_SCENARIO,
--    OnClick = { EditScenarioFrame },
--    font = {
--      font = "LuaUI/Fonts/Asimov.otf",
--      size = 40,
--      color = { 0.2, 1, 0.8, 1 }
--    }
--  }
  UI.LanguageComboBox = Chili.ComboBox:New{
    parent = UI.MainWindow,
    x = "85%",
    y = "0%",
    width = "15%",
    height = "7%",
    items = { "English", "French" },
    font = {
      font = "LuaUI/Fonts/Asimov.otf",
      size = 40,
      color = { 0.2, 1, 0.8, 1 }
    }
  }
  UI.LanguageComboBox.OnSelect = { -- Change language to the newly selected language
    function()
      if UI.LanguageComboBox.selected == 1 then
        ChangeLanguage("en")
      elseif UI.LanguageComboBox.selected == 2 then
        ChangeLanguage("fr")
      end
    end
  }
  UI.BackButton = Chili.Button:New{
    parent = UI.MainWindow,
    x = "0%",
    y = "0%",
    width = "10%",
    height = "10%",
    backgroundColor = { 0, 0.2, 0.6, 1 },
    focusColor = { 0, 0.6, 1, 1 },
    OnClick = { MainMenuFrame }
  }
  Chili.Image:New{ -- Image for the back button
    parent = UI.BackButton,
    x = "10%",
    y = "10%",
    width = "80%",
    height = "80%",
    keepAspect = false,
    file = "bitmaps/launcher/arrow.png"
  }
  UI.QuitButton = Chili.Button:New{
    parent = UI.MainWindow,
    x = "90%",
    y = "90%",
    width = "10%",
    height = "10%",
    caption = LAUNCHER_QUIT,
    font = {
      font = "LuaUI/Fonts/Asimov.otf",
      size = 40,
      color = { 0.8, 0.6, 0.2, 1 }
    },
    backgroundColor = { 0.8, 0, 0.2, 1 },
    focusColor= { 0.8, 0.6, 0.2, 1 },
    OnClick = { QuitWarning }
  }
end


function widget:Initialize()  
  if (not WG.Chili) then
    -- don't run if we can't find Chili
    widgetHandler:RemoveWidget()
    return
  end
  hideDefaultGUI()
  initChili()
  InitializeMainMenu()
  --[[
  -- Get ready to use Chili
  Chili = WG.Chili
  Screen0 = Chili.Screen0
  
  UI.MainWindow = Chili.Window:New{
    parent = Screen0,
    x = "0%",
    y = "0%",
    width  = "100%",
    height = "100%",
    draggable = false,
    resizable = false
  }
  -- Create the window
  UI.helloWorldWindow = Chili.Window:New{
    parent = UI.MainWindow,
    x = '40%',
    y = '40%',
    width  = '20%',
    height = '20%', 
  } 

  -- Create some text inside the window
  helloWorldLabel = Chili.Label:New{
    parent = UI.helloWorldWindow,
    width  = '100%',
    height = '100%',
    caption = "Hello world",
  }
  InitializeTimer = Spring.GetTimer()
  --]]
end

function widget:DrawScreenEffects(dse_vsx, dse_vsy)
  --vsx, vsy = dse_vsx, dse_vsy
 --if Spring.IsGUIHidden() then
    EitherDrawScreen(dse_vsx, dse_vsy)
-- end
end

function widget:Update()
  --clean()
  removeWidgets(self)
end