function widget:GetInfo()
	return {
		name = "Editor State Machine",
		desc = "State machine of the level editor",
		author = "zigaroula",
		date = "02/05/2016",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true
	}
end

---------------------------------------------------------------------------------------------------------------

------------------------------
-- Class StateMachine --
------------------------------
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
--   Widget functions   --
------------------------------
local states = {	-- Global
						FILE = "file", UNITS = "units", SELECTION = "selection",
						-- Units
						BIT = "bit", BYTE = "byte",
						-- Teams
						PLAYER = "0", ALLY = "1", ENEMY = "2"
					}
local stateMachine

-------------------------------------
-- Changing state functions
-------------------------------------
function stateIdle() 		stateMachine:setCurrentUnitState(stateMachine.states.IDLE)			Spring.Echo(stateMachine.currentUnitState) 	end
function stateBit() 			stateMachine:setCurrentUnitState(stateMachine.states.BIT) 			Spring.Echo(stateMachine.currentUnitState) 	end
function stateByte() 		stateMachine:setCurrentUnitState(stateMachine.states.BYTE) 		Spring.Echo(stateMachine.currentUnitState) 	end
function statePlayer()		stateMachine:setCurrentTeamState(stateMachine.states.PLAYER)	Spring.Echo(stateMachine.currentTeamState) 	end
function stateAlly() 		stateMachine:setCurrentTeamState(stateMachine.states.ALLY) 		Spring.Echo(stateMachine.currentTeamState) 	end
function stateEnemy()		stateMachine:setCurrentTeamState(stateMachine.states.ENEMY)		Spring.Echo(stateMachine.currentTeamState) 	end

-------------------------------------
-- Current State getter
-------------------------------------
function getCurrentUnitState() 		return stateMachine:getCurrentUnitState() 		end
function getCurrentTeamState() 	return stateMachine:getCurrentTeamState() 		end

-------------------------------------
-- Initialize the widget
-------------------------------------
function widget:Initialize()
	
	stateMachine = StateMachine.new(states, states.BIT, states.PLAYER)
	
	-- Register changing state functions
	widgetHandler:RegisterGlobal("stateIdle", stateIdle)
	widgetHandler:RegisterGlobal("stateBit", stateBit)
	widgetHandler:RegisterGlobal("stateByte", stateByte)
	widgetHandler:RegisterGlobal("statePlayer", statePlayer)
	widgetHandler:RegisterGlobal("stateAlly",stateAlly)
	widgetHandler:RegisterGlobal("stateEnemy", stateEnemy)
	
	-- Register state getters
	widgetHandler:RegisterGlobal("getCurrentUnitState", getCurrentUnitState)
	widgetHandler:RegisterGlobal("getCurrentTeamState", getCurrentTeamState)
end
