------------------------
-- Class StateMachine --
------------------------
StateMachine = {}
StateMachine.__index = StateMachine

-- Constructor
function StateMachine.new(_states, _unitStates, _currentGlobalState, _currentUnitState, _currentTeamState)
	local self = setmetatable({}, StateMachine)
	self.states = _states
	self.unitStates = _unitStates
	self.currentGlobalState = _currentGlobalState
	self.currentUnitState = _currentUnitState
	self.currentTeamState = _currentTeamState
	return self
end

-- Setter
function StateMachine.setCurrentUnitState(self, _currentUnitState) self.currentUnitState = _currentUnitState end
function StateMachine.setCurrentTeamState(self, _currentTeamState) self.currentTeamState = _currentTeamState end
function StateMachine.setCurrentGlobalState(self, _currentGlobalState) self.currentGlobalState = _currentGlobalState end

-- Getter
function StateMachine.getCurrentUnitState(self) return self.currentUnitState end
function StateMachine.getCurrentTeamState(self) return self.currentTeamState end
function StateMachine.getCurrentGlobalState(self) return self.currentGlobalState end

------------------------------
-- List of all the units of the game
-- TODO : generation of the table using constant list
------------------------------
unitList = {"bit", "byte", "assembler", "alice"}

------------------------------
-- Initialisation of the state machine
------------------------------

-- states to select the unit to place on the field
local unitStates = {}
for i, u in ipairs(unitList) do
	unitStates[u] = u
	if i == 1 then
		unitStates.DEFAULT = u
	end
end

-- other states
local states = {	-- Global
						FILE = "file", UNIT = "unit", SELECTION = "selection", EVENT = "event", ACTION = "action", LINK = "link",
						-- Teams
						PLAYER = "0", ALLY = "1", ENEMY = "2"
					}

-- init
stateMachine = StateMachine.new(states, unitStates, states.FILE, unitStates.DEFAULT, states.PLAYER)
