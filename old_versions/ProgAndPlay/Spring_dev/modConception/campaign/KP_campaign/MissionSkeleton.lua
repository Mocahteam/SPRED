-- Defines the MissionSkeleton

local lang = Spring.GetModOptions()["language"] -- get the language

-- This function is automatically called at the begining of the mission.
local function Start ()

end

-- This function is automatically called when the breifing must be displayed.
local function ShowBriefing ()
	local msg
	if lang == "fr" then
		msg = "Mon briefing"
	else
		msg = "My briefing"
	end
	-- display my briefing
	Script.LuaRules.showMessage(msg, true, 500)
end

-- This function is automatically called for each frame. You must define defeat
-- and victory conditions in this function.
-- It returns 0 if mission is not ended
--            1 if mission is ended (victory)
--            -1 if mission is ended (defeat)
local function Update (frameNumber)
	-- if defeat => return -1
	
	-- if victory => retrun 1
	
	-- if not ended => return 0
end

-- This function is automatically called at the end of the mission.
local function Stop ()

end

-- You do not modify following code
local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
