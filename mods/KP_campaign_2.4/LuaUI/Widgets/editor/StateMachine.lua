------------------------
-- Class StateMachine --
------------------------
StateMachine = {}
StateMachine.__index = StateMachine

-- Constructor
function StateMachine.new(_states, _currentGlobalState, _currentUnitState, _currentTeamState)
	local self = setmetatable({}, StateMachine)
	self.states = _states
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
-- Initialisation of the state machine
-- TODO : generation of the table using constant list
------------------------------
local states = {	-- Global
						FILE = "file", UNIT = "unit", SELECTION = "selection",
						-- Units
						BIT = "bit", BYTE = "byte",
						-- Teams
						PLAYER = "0", ALLY = "1", ENEMY = "2"
					}
stateMachine = StateMachine.new(states, states.FILE, states.BIT, states.PLAYER)
