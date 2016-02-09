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

-------------------------------------
-- Useful function to split messages into tokens
-------------------------------------
function splitString(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	local i = 1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

------------------------------
-- Initialize global state machine
------------------------------
local globalStates = { FILE = "file", UNIT = "unit", SELECTION = "selection", EVENT = "event", ACTION = "action", LINK = "link" }
globalStateMachine = StateMachine.new(globalStates, globalStates.FILE)

------------------------------
-- Initialize unit state machine
------------------------------
local unitList = splitString(VFS.LoadFile("LuaUI/Widgets/editor/UnitList.txt"), "\r\n") -- List of all the units of the game
-- states to select the unit to place on the field
local unitStates = {}
for i, u in ipairs(unitList) do
	unitStates[u] = u
	if i == 1 then
		unitStates.DEFAULT = u
	end
end
unitStateMachine = StateMachine.new(unitStates, unitStates.DEFAULT)

------------------------------
-- Initialize team state machine
------------------------------
local teamStates = { PLAYER = "0", ALLY = "1", ENEMY = "2" }
teamStateMachine = StateMachine.new(teamStates, teamStates.PLAYER)
