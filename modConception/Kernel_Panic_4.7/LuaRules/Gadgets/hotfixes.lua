
function gadget:GetInfo()
	return {
		name = "Lua hotfixes",
		desc = "Patch up bugs in Spring's Lua and the Gadget Handler",
		author = "zwzsg & lurker",
		date = "23rd of January 2010",
		license = "Public Domain",
		layer = 2000,
		enabled = true
	}
end



-- Restore 0.81.2.1 behavior of GetAIInfo
Spring.GetOldAIInfo = function(team)
		local AIInfo={Spring.GetAIInfo(team)}
		if #AIInfo==6 then
			table.insert(AIInfo,1,team)
		end
		return unpack(AIInfo)
	end


-- Patching the Gadget Handler,
-- Making calling RemoveGadget in GameFrame or Update safe
-- Previously, that could make other gadget skip that frame

do
  local gadgetHandler = getfenv(0).gadgetHandler
  
  if not gadgetHandler.gracefulRemove then
  
    gadgetHandler.gracefulRemove = true
    
    local RemoveGadget = gadgetHandler.RemoveGadget
    local Update = gadgetHandler.Update
    
    function gadgetHandler:GameFrame(frameNum)
      self.catchRemove = true
      for _,g in ipairs(self.GameFrameList) do
        g:GameFrame(frameNum)
      end
      self.catchRemove = false
      if self.removeList then
        for _,g in ipairs(self.removeList) do
          self:RemoveGadget(g)
        end
      end
    end
    
    function gadgetHandler:Update()
      self.catchRemove = true
      for _,g in ipairs(self.UpdateList) do
        g:Update()
      end
      self.catchRemove = false
      if self.removeList then
        for _,g in ipairs(self.removeList) do
          self:RemoveGadget(g)
        end
      end
    end

    function gadgetHandler:RemoveGadget(gadget)
      if self.catchRemove then
        self.removeList = self.removeList or {}
        self.removeList[#self.removeList + 1] = gadget
      else
        RemoveGadget(self, gadget)
      end
    end

  end

end




if (gadgetHandler:IsSyncedCode()) then
	--SYNCED

	if not getfenv(0).AllowUnsafeChanges then
		getfenv(0).AllowUnsafeChanges = function(...) end
	end

	if not Spring.CreateUnitRulesParam then
		Spring.CreateUnitRulesParams = function(u,t)
			if type(u)=="number" and type(t)=="table" and type(t[1])=="table" then
				for k,v in pairs(t[1]) do
					Spring.SetUnitRulesParam(u,k,v)
				end
			end
		end
	end

	if not Spring.SetUnitLineage then
		Spring.SetUnitLineage=function() end
	end

	function gadget:Initialize()
		-- Call UnitCreated and UnitFinished of every gadget after a /luarules reload
		if (Spring.GetGameFrame() or 0)>0 then
			local gadgetHandler = getfenv(0).gadgetHandler
			Spring.Echo("gadgetHandler:GameStart()")
			gadgetHandler:GameStart()
			for _,unitID in ipairs(Spring.GetAllUnits()) do
				local unitDefID, unitTeam, builderID = Spring.GetUnitDefID(unitID), Spring.GetUnitTeam(unitID), nil
				gadgetHandler:UnitCreated(unitID, unitDefID, unitTeam, builderID)
				Spring.Echo("gadgetHandler:UnitCreated(",unitID, unitDefID, unitTeam, builderID, ")")
				if (select(5,Spring.GetUnitHealth(unitID)) or 0)>=1 then
					Spring.Echo("gadgetHandler:UnitFinished(",unitID, unitDefID, unitTeam, ")")
					gadgetHandler:UnitFinished(unitID, unitDefID, unitTeam)
				end
			end
		end
	end

	-- We cannot count on math.random to be properly initialised
	-- So add to it some entropy from startscript
	if not pcall(
		function()
			-- Initialize a number
			local n=0
			-- Function to add the bytes value of a string (and make argument a string if it is not)
			local function AddBytes(something)
				local str=tostring(something)
				if type(something)=="table" then
					str={}
					for _,subvalue in pairs(something) do
						table.insert(str,tostring(subvalue))
					end
					str=table.concat(str)
				end
				for k=1,str:len() do
					n=(n+str:byte(k,k))%271
				end
				for k=1,n%7 do
					math.random()
				end
			end
			-- Gather bytes from ModOptions
			for key,value in pairs(Spring.GetModOptions()) do
				AddBytes(value)
			end
			-- Gather bytes from TeamInfo
			for _,team in ipairs(Spring.GetTeamList()) do
				for _,field in pairs({Spring.GetTeamInfo(team)}) do
					AddBytes(field)
				end
			end
			-- Gather bytes from PlayerInfo
			for _,player in ipairs(Spring.GetPlayerList()) do
				for _,field in pairs({Spring.GetPlayerInfo(player)}) do
					AddBytes(field)
				end
			end
			-- Throw some more dices
			for k=1,n do
				math.random()
			end
		end
	) then
		Spring.Echo("Warm-up of rand failed!")
	end

else
	--UNSYNCED

	-- Fix gl.Text y offset that changed between 0.80.0 and 0.80.1
	--if (tonumber(string.sub(Game.version,1,3) or 0) or 0)>=0.80 and (tonumber(string.sub(Game.version,6,6) or 0) or 0)>=1 then
		local glText = gl.Text
		gl.Text = function(text,x,y,size,options)
			if (not size) or string.match(options or "","[atvdb]") then
				glText(text,x,y,size,options)
			else
				glText(text,x,y,size,"d"..(options or ""))
			end
		end
	--end

end



