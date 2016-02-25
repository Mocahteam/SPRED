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
local globalStates = { FILE = "file", UNIT = "unit", SELECTION = "selection", EVENT = "event", ACTION = "action", LINK = "link", ZONE = "zone" }
globalStateMachine = StateMachine.new(globalStates, globalStates.FILE)

------------------------------
-- Initialize unit state machine
------------------------------
local unitStates = {}
for id,unitDef in pairs(UnitDefs) do
	for name,param in unitDef:pairs() do
		if name == "name" then
			unitStates[param] = param
			if i == 1 then
				unitStates.DEFAULT = param
			end
		end
	end
end
unitStateMachine = StateMachine.new(unitStates, unitStates.DEFAULT)

------------------------------
-- Initialize team state machine
------------------------------
local teamStates = { PLAYER = "0", ALLY = "1", ENEMY = "2" }
teamStateMachine = StateMachine.new(teamStates, teamStates.PLAYER)

------------------------------
-- Initialize zone state machine
------------------------------
local zoneStates = { DRAW = "draw", SELECTION = "selection" }
zoneStateMachine = StateMachine.new(zoneStates, zoneStates.DRAW)