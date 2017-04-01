function widget:GetInfo()
  return {
    name      = "PP Mission Tester",
    desc      = "Display a special button to return back into editor module.",
    author    = "muratet, mocahteam",
    date      = "Jan 24, 2017",
    license   = "GPL v2 or later",
    layer     = 210,
    enabled   = true, --  loaded by default?
  }
end

local editorRef = Spring.GetModOptions()["testmap"] -- get editor mod name for which we test a level
local BackButton = nil -- the button to get back to the editor
local ReplayButton = nil -- the button to replay the mission

local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
VFS.Include("LuaUI/Widgets/libs/RestartScript.lua")

function returnToEditor()
	local levelPath = "SPRED/missions/"..Spring.GetModOptions().missionname..".editor"
	local levelFile = VFS.LoadFile(levelPath,  VFS.RAW)
	levelFile = json.decode(levelFile)
	local operations = {
		["MODOPTIONS"] = {
			["language"] = Spring.GetModOptions()["language"],
			["scenario"] = "noScenario",
			["maingame"] = levelFile.mainGame,
			["toBeLoaded"] = levelFile.description.saveName
		},
		["GAME"] = {
			["Mapname"] = levelFile.description.map,
			["Gametype"] = editorRef
		}
	}
	genericRestart(levelPath, operations, true, "Editor")
end

function replayMission()
	DoTheRestart("_script.txt", {}) -- _script.txt is the launcher file used by the previous start, so we can reuse it for replay the game
end

function widget:Initialize()
	if editorRef then -- An editor reference is defined => we display the button
		if (not WG.Chili) then -- If the chili widget is not found, remove this widget
			Spring.Echo("PP Mission Tester: Chili is not defined, remove himself")
			return
		end

		local back, replay
		if Spring.GetModOptions()["language"] == "en" then
			back = "Return to editor"
			replay = "Replay mission"
		else
			back = "Retourner à l'éditeur"
			replay = "Relancer la mission"
		end
		
		BackButton = WG.Chili.Button:New{
			parent = WG.Chili.Screen0,
			x = "85%",
			y = "0%",
			width = "15%",
			height = "7%",
			caption = back,
			OnClick = { returnToEditor },
			font = {
				font = "LuaUI/Fonts/Asimov.otf",
				size = 30,
				autoAdjust = true,
				maxSize = 30,
				color = { 0.2, 1, 0.8, 1 }
			}
		}
		
		ReplayButton = WG.Chili.Button:New{
			parent = WG.Chili.Screen0,
			x = "85%",
			y = "8%",
			width = "15%",
			height = "7%",
			caption = replay,
			OnClick = { replayMission },
			font = {
				font = "LuaUI/Fonts/Asimov.otf",
				size = 30,
				autoAdjust = true,
				maxSize = 30,
				color = { 0.2, 1, 0.8, 1 }
			}
		}
	end
end


function widget:Shutdown()
	if BackButton then
		BackButton:Dispose()
	end
	if ReplayButton then
		ReplayButton:Dispose()
	end
end