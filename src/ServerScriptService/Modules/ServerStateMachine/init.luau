local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
local ActionState: RemoteEvent = NetworkService.GetEvent("ActionState")

local ServerStateMachine = {}
ServerStateMachine.PlayerStates = {}

local char

local States = {
	["Idle"] = function()
		ServerStateMachine.ChangeState("Idle")
		print(ServerStateMachine.PlayerStates[char])
	end,

	["Walk"] = function()
		ServerStateMachine.ChangeState("Walk")
		print(ServerStateMachine.PlayerStates[char])
	end,
}

function ServerStateMachine.Init()
	Players.PlayerAdded:Connect(function(plr: Player)
		plr.CharacterAdded:Connect(function(c)
			char = c

			ServerStateMachine.PlayerStates[char] = "Idle"
		end)
	end)
end

function ServerStateMachine.ChangeState(currentState: string)
	-- assert if currentState does not exist. (StateInfo)

	ServerStateMachine.PlayerStates[char] = currentState
end

function ServerStateMachine.GetStates()
	assert(ServerStateMachine.PlayerStates[char], `{char}, does not exist.`)

	return ServerStateMachine.PlayerStates[char]
end

ActionState.OnServerEvent:Connect(function(plr: Player, currentState)
	-- ensure they can be transitioned.

	local func = States[currentState]
	func()
end)

return ServerStateMachine
