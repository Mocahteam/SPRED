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
 
local helloWorldWindow
local helloWorldLabel
local InitializeTimer = nil
local TextLocale = {
  fr = {back="Retour", continue="Continuer la dernière partie", SelectScenario="Nouvelle partie", quit="Quitter", specificMission="Jouer une mission précise", whichScenario="Choisissez un scenario", whichMission="Choisissez une mission"},
  en = {back="Back", continue="Continue previous game", SelectScenario="New game", quit="Quit", specificMission="Play a specific mission", whichScenario="Choose a scenario", whichMission="Choose a mission"}
}


local function removeWidgets(self)
  for name, w in pairs(widgetHandler.knownWidgets) do
    if w.active and name ~= "Chili Hello World" and name ~= "Chili Framework" then
      widgetHandler:DisableWidget(name)
    end
  end
end

 
function widget:Initialize()  
  if (not WG.Chili) then
    -- don't run if we can't find Chili
    widgetHandler:RemoveWidget()
    return
  end

  -- Get ready to use Chili
  Chili = WG.Chili
  Screen0 = Chili.Screen0

  -- Create the window
  helloWorldWindow = Chili.Window:New{
    parent = Screen0,
    x = '40%',
    y = '40%',
    width  = '20%',
    height = '20%', 
  } 

  -- Create some text inside the window
  helloWorldLabel = Chili.Label:New{
    parent = helloWorldWindow,
    width  = '100%',
    height = '100%',
    caption = "Hello world",
  }
  InitializeTimer = Spring.GetTimer()
end

function widget:Update()
  removeWidgets(self)
end