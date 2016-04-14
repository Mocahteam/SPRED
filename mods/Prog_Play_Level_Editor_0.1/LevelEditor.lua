-- Defines the Mission 3

local myUnit
local allyUnit
local enemyUnitsId

local lang = Spring.GetModOptions()["language"] -- get the language
local gray = "\255\100\100\100"

local function Start ()

end

local function ShowBriefing ()

end

local function Update (frameNumber)
	return 0
end

local function Stop ()

end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
