VFS.Include("LuaUI/Widgets/editor/Misc.lua") -- Miscellaneous useful functions

------------------------
-- Class StateMachine --
------------------------
StateMachine = {}
StateMachine.__index = StateMachine

-- Constructor
function StateMachine.new(_states, _currentState)
	local self = setmetatable({}, StateMachine)
	self.states = _states
	self.currentState = _currentState
	return self
end

-- Setter
function StateMachine.setCurrentState(self, _currentState) self.currentState = _currentState end

-- Getter
function StateMachine.getCurrentState(self) return self.currentState end

------------------------------
-- Initialize global state machine
------------------------------
local globalStates = { NONE = "none", FILE = "file", UNIT = "unit", ZONE = "zone", FORCES = "forces", TRIGGER = "trigger" }
globalStateMachine = StateMachine.new(globalStates, globalStates.FILE)

------------------------------
-- Initialize unit state machine
------------------------------
local unitStates = {}
for id,unitDef in pairs(UnitDefs) do
	for name,param in unitDef:pairs() do
		if name == "name" then
			unitStates[param] = param
		end
	end
end
unitStates.SELECTION = "selection"
unitStates.UNITGROUPS = "unitGroups"
unitStateMachine = StateMachine.new(unitStates, unitStates.SELECTION)

------------------------------
-- Initialize team state machine
------------------------------
local teamStates = {}
local teams = getTeamsInformation()
for i = 0, #teams, 1 do
	table.insert(teamStates, teams[i].id)
end
teamStateMachine = StateMachine.new(teamStates, teamStates[1])

------------------------------
-- Initialize zone state machine
------------------------------
local zoneStates = { DRAWRECT = "drawrect", DRAWDISK = "drawdisk", SELECTION = "selection" }
zoneStateMachine = StateMachine.new(zoneStates, zoneStates.DRAWRECT)

------------------------------
-- Initialize forces state machine
------------------------------
local forcesStates = { TEAMCONFIG = "teamConfig", ALLYTEAMS = "allyTeams" }
forcesStateMachine = StateMachine.new(forcesStates, forcesStates.TEAMCONFIG)

------------------------------
-- Initialize triggers state machine
------------------------------
local triggerStates = { DEFAULT = "default", PICKPOSITION = "pickPosition", PICKUNIT = "pickUnit" }
triggerStateMachine = StateMachine.new(triggerStates, triggerStates.DEFAULT)