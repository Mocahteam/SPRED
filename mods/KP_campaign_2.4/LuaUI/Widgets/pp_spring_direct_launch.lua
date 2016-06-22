function widget:GetInfo()
  return {
    name    = "campaign launcher",
    desc    = "",
    author  = "zigaroula,bruno",
    date    = "",
    license = "GNU GPL v2",
    layer   = 20,
    enabled = true,
    handler = true
  }
end
local reloadAvailable=(tonumber(Game.version)~=nil and tonumber(Game.version)>=99)
local hideView=true
local lang="fr"
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
local gameName=Game.gameShortName or Game.modShortName


if(xmlFiles[1]~=nil)then
  AppliqManager=appliqManager:new(xmlFiles[1])
  AppliqManager:parse()
end
local RemovedWidgetList = {}
local Chili, Screen0 -- Chili framework, main screen
local tableCaptions={
  {el="NewPartyButton",fr="Nouvelle Partie",en="New Game"},
  {el="ListMissionButtons",fr="Missions",en="Missions"},
  {el="Title",fr="campagne",en="campaign"},
  {el="NewPartyButton",fr="Nouvelle Partie",en="Start Campaign"},
  {el="ListMissionButtons",fr="Liste Des Missions",en="Missions List"},
  {el="QuitButton",fr="Quitter",en="Quit"},
  {el="continueGameButton",fr="Continuer",en="Continue"}
}
local UI = {} -- Contains each UI element

function hideDefaultGUI()
  -- get rid of engine UI
    -- disable console
  Spring.SendCommands("tooltip 0")
  Spring.SendCommands("minimap min")
  Spring.SendCommands("endgraph 0")
  Spring.SendCommands("hideinterface 0")
  Spring.SendCommands("resbar 0","fps 0","console 0","info 0", "tooltip 0") -- TODO : change fps 1 to fps 0 in release
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

local function removeWidgets()
  for name, w in pairs(widgetHandler.knownWidgets) do
    if w.active and name ~= "campaign launcher" and name ~= "Chili Framework" then
      widgetHandler:DisableWidget(name)
    end
  end
end

function clearUI() -- Remove UI elements from the screen
  for name,el in pairs(UI) do
    if(name~="MainWindow") then 
      UI.MainWindow:RemoveChild(el)
    end
  end
end

local function Quit()
  Spring.SendCommands("quit")
  Spring.SendCommands("quitforce")
end

function UpdateCaption(element, text) -- Update the caption of an UI element
  if element then
    element:SetCaption(text)
  end
end

function UpdateText(element, text) -- Update the text of an UI element
  if element then
    element:SetText(text)
  end
end

local function ChangeLanguage(lg)
  lang = lg
  for _,bloc in pairs(tableCaptions) do
    local newCaption=bloc[lg]
    local elToChange=bloc["el"]
    UpdateCaption(UI[elToChange], newCaption)
  end
end

local function RunScenario(i)
  if Spring.Restart then
    AppliqManager:selectScenario(i)
    AppliqManager:startRoute()
    Spring.Echo(json.encode(AppliqManager.treehandler.root.games.game))    
    local mission=AppliqManager.currentActivityID
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
      ["hidemenu"]="true",
      ["progression"]=pickle(AppliqManager.progressionOutputs)
      }
    }
    local contextFile=true
    genericRestart("Missions/"..mission..".editor",options,contextFile)
  else
    NoRestart()
  end
end

local function Capitalize(str)
  return string.gsub (str, "(%w)(%w*)", function(a,b) return string.upper(a) .. b end)
end

local function RunScript(ScriptFileName, scenario)
  if Spring.Restart then
     local contextFile=true
    --if (string.sub(ScriptFileName, -3, -1)=="txt")then
      local operations={
      ["MODOPTIONS"]=
        {
        ["language"]=lang,
        ["scenario"]=scenario,
        ["hidemenu"]="true"
        }
      }    
      genericRestart(ScriptFileName,operations,contextFile)
  else
    NoRestart()
  end
end

function EitherDrawScreen(vsx, vsy) -- Shows a black background if required
  if (not vsx or not vsy or not hideView) then return end
  local bgText = "bitmaps/editor/blank.png"
  gl.Blending(false)
  gl.Color(0, 0, 0, 0)
  gl.Texture(bgText)
  gl.TexRect(vsx, vsy, 0, 0, 0, 0, 1, 1)
  gl.Texture(false)
  gl.Blending(true)
end

local function commonElements()
  if UI.MainWindow ==nil then 
    UI.MainWindow = Chili.Window:New{
    parent = Screen0,
    x = "0%",
    y = "0%",
    width  = "100%",
    height = "100%",
    draggable = false,
    resizable = false
  }
  end
  UI.Title = Chili.Label:New{
    parent = UI.MainWindow,
    x = '0%',
    y = '0%',
    width = '100%',
    height = '10%',
    align = "center",
    valign = "center",
    caption = "campagne",
    font = {
      font = "LuaUI/Fonts/Asimov.otf",
      size = 60,
      color = { 0.2, 0.6, 0.8, 1 }
    }
  }
  -- scrollPanel
  UI.LanguageComboBox = Chili.ComboBox:New{
    parent = UI.MainWindow,
    x = "85%",
    y = "0%",
    width = "15%",
    height = "7%",
    items = { "French","English" },
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

  UI.QuitButton = Chili.Button:New{
      parent = UI.MainWindow,
      x = "90%",
      y = "90%",
      width = "10%",
      height = "10%",
      caption = "quitter",
      font = {
        font = "LuaUI/Fonts/Asimov.otf",
        size = 40,
        color = { 0.8, 0.6, 0.2, 1 }
      },
      backgroundColor = { 0.8, 0, 0.2, 1 },
      focusColor= { 0.8, 0.6, 0.2, 1 },
      OnClick = {Quit}
    }
end

local function InitializeMainMenu() -- Initialize the main window and buttons of the main menu
  clearUI()
  commonElements()
  UI.NewPartyButton = Chili.Button:New{
    parent = UI.MainWindow,
    x = "30%",
    y = "30%",
    width = "40%",
    height = "10%",
    caption = "Nouvelle Partie",
    OnClick = { function() RunScenario(1) end },
    font = {
      font = "LuaUI/Fonts/Asimov.otf",
      size = 40,
      color = { 0.2, 1, 0.8, 1 }
    }
  }
  UI.ListMissionButtons = Chili.Button:New{
    parent = UI.MainWindow,
    x = "30%",
    y = "40%",
    width = "40%",
    height = "10%",
    caption = "Liste des missions",
    OnClick = { missionMenu },
    font = {
      font = "LuaUI/Fonts/Asimov.otf",
      size = 40,
      color = { 0.2, 1, 0.8, 1 }
    }
  }
  UI.continueGameButton = Chili.Button:New{
    parent = UI.MainWindow,
    x = "30%",
    y = "50%",
    width = "40%",
    height = "10%",
    caption = "Continuer",
    OnClick = { continue },
    font = {
      font = "LuaUI/Fonts/Asimov.otf",
      size = 40,
      color = { 0.2, 1, 0.8, 1 }
    }
  }
end

function continue()
  local saveFiles = VFS.DirList("Savegames/"..gameName.."/" ,"*.sav")
  -- it's better to look for save files at this precise moment in order to include recent saved files.
 clearUI()
 commonElements()
  UI.MapScrollPanel2 = Chili.ScrollPanel:New{
    parent = UI.MainWindow,
    x = "20%",
    y = "20%",
    width = "60%",
    height = "60%"
  }
  
  UI.BackButton = Chili.Button:New{
    parent = UI.MainWindow,
    x = "0%",
    y = "0%",
    width = "10%",
    height = "10%",
    backgroundColor = { 0, 0.2, 0.6, 1 },
    focusColor = { 0, 0.6, 1, 1 },
    OnClick = { InitializeMainMenu }
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
  UI.ContButtons = {}
  for i,MissionFileName in ipairs(saveFiles) do 
    local userMissionName=string.match(MissionFileName, '\\([^\\]*)%.')--match string between the last "\" and the "." of .editor 
    Spring.Echo(userMissionName)
    local contButton = Chili.Button:New{
      parent = UI.MapScrollPanel2,
      x = "0%",
      y = 80 * ( i - 1 ),
      width = "100%",
      height = 80,
      caption = userMissionName,
      OnClick = { function() 
                local txt=VFS.LoadFile(MissionFileName) 
                if(reloadAvailable)then Spring.Reload("-s",txt) else  Spring.Restart("-s",txt) end
                end },
      font = {
        font = "LuaUI/Fonts/Asimov.otf",
        size = 40,
        color = { 0.2, 0.4, 0.8, 1 }
      }
    }
    table.insert(UI.ContButtons, contButton)
  end
end
function missionMenu()
 clearUI()
 commonElements()
  UI.MapScrollPanel = Chili.ScrollPanel:New{
    parent = UI.MainWindow,
    x = "20%",
    y = "20%",
    width = "60%",
    height = "60%"
  }
  
  UI.BackButton = Chili.Button:New{
    parent = UI.MainWindow,
    x = "0%",
    y = "0%",
    width = "10%",
    height = "10%",
    backgroundColor = { 0, 0.2, 0.6, 1 },
    focusColor = { 0, 0.6, 1, 1 },
    OnClick = { InitializeMainMenu }
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
  UI.MapButtons = {}
  local MissionsList=VFS.DirList("Missions")
  for i,MissionFileName in ipairs(MissionsList) do 
    Spring.Echo(MissionFileName)
    local userMissionName=string.match(MissionFileName, '/([^/]*)%.')--match string between the last "/" and the "." of .editor 
    local mapButton = Chili.Button:New{
      parent = UI.MapScrollPanel,
      x = "0%",
      y = 80 * ( i - 1 ),
      width = "100%",
      height = 80,
      caption = userMissionName,
      OnClick = { function() RunScript(MissionFileName,"noScenario") end },
      font = {
        font = "LuaUI/Fonts/Asimov.otf",
        size = 40,
        color = { 0.2, 0.4, 0.8, 1 }
      }
    }
    table.insert(UI.MapButtons, mapButton)
  end
end

function initGui()
  hideView=true
  hideDefaultGUI()
  removeWidgets()
  initChili()
  InitializeMainMenu()
  --EitherDrawScreen(1536,803)
end

WG.switchOnMenu = initGui

function widget:Initialize()
  if not Spring.GetModOptions().hidemenu then
    if (not WG.Chili) then
      -- don't run if we can't find Chili
      widgetHandler:RemoveWidget()
      return
    end
  initGui()
  else
    hideView=false
  end
end

function widget:DrawScreen()
  --vsx, vsy = dse_vsx, dse_vsy
 --if Spring.IsGUIHidden() then
    EitherDrawScreen(vsx, vsy )
-- end
end

function widget:DrawScreenEffects(dse_vsx, dse_vsy)
  vsx, vsy = dse_vsx, dse_vsy
 --if Spring.IsGUIHidden() then
    EitherDrawScreen(dse_vsx, dse_vsy)
-- end
end

function widget:Update()
  --clean()
end