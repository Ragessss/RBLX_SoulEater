local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateInfo = require(ReplicatedStorage.Modules.Data.StateInfo)

local StateHandler = {}
StateHandler.__index = StateHandler

StateHandler.ActivePlayers = {}

local function CanTransition(currentState, newState)
	if not currentState then
		currentState = "Idle"
	end

	if table.find(StateInfo[currentState], newState) then
		return true
	else
		return false
	end
end

function StateHandler.new(char, AnimationHandler)
	local self = setmetatable({}, StateHandler)

	self.Owner = char
	self.AnimationHandler = AnimationHandler or nil
	self.CurrentState = nil
	self.States = {} -- Stores all `States` in the game.

	StateHandler.ActivePlayers[char] = self

	return self
end

function StateHandler:ChangeState(newState)
	local currentState = self.CurrentState

	if CanTransition(currentState, newState) then
		self.States[currentState]:Exit()
		self.States[newState]:Enter()

		self.CurrentState = newState
	else
		warn(self.Owner, `cannot transition between {currentState} and {newState}.`)
	end
end

function StateHandler:OverrideState(newState)
	if self.States[newState] then
		self.CurrentState = newState
		self.States[newState]:Enter()
	end
end

function StateHandler:AddState(stateName, stateTable)
	self.States[stateName] = stateTable
end

function StateHandler:GetStates()
	return self.States
end

function StateHandler.GetAllPlayers()
	return StateHandler.ActivePlayers
end

return StateHandler
