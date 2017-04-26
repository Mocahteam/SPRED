
function gadget:GetInfo()
  return {
    name      = "Constants list",
    desc      = "Gives constants list of a specific mod",
    author    = "muratet",
    date      = "Jul 12, 2010",
    license   = "GPL v2 or later",
    layer     = 0,
    enabled   = true --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- SYNCED
--
if (gadgetHandler:IsSyncedCode()) then 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:RecvLuaMsg(msg, playerID)
	-- Message could be anything, we need to see if it's the right one
	if string.find(msg,"CstList_Gadget") then
		-- yep, this is our message
		computeCstList = true
	end
end

function gadget:GameFrame( frameNumber )
	if computeCstList then
		local x = 200
		local y = 200
		local list = ""
		for id,unitDef in pairs(UnitDefs) do
			if (x > (Game.mapSizeX-200)) then
				x = 200
				y = y + 200
			end
			if (y > (Game.mapSizeZ-200)) then
				x = 200
				y = 200
			end
			local u = Spring.CreateUnit(UnitDefs[id]["name"], x, Spring.GetGroundHeight(x, y), y, "s", 0)
			list = list..UnitDefs[id]["id"].." "..UnitDefs[id]["name"].."\n"
			local cmd = Spring.GetUnitCmdDescs(u)
			if cmd ~= nil then
				for i = 1,table.getn(cmd) do
					list = list.."   "..cmd[i]["id"].." "..cmd[i]["name"].." "..cmd[i]["action"].."\n"
				end
			end
			x = x + 200
		end
		SendToUnsynced("CstList_Widget", list)
		computeCstList = false
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 
-- UNSYNCED
--
else
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function gadget:RecvFromSynced(msg, list)
	if msg == "CstList_Widget" then
		Script.LuaUI.WriteToFile(list)
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
