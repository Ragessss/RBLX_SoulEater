local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimationManager = require(script.Parent.AnimationManager)

local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
local ActionState: RemoteEvent = NetworkService.GetEvent("ActionState")

local plr: Player = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum: Humanoid = char:FindFirstChildOfClass("Humanoid")

local currentState

local ClientStateMachine = {}
local animCache = {}

local States = {
	["Idle"] = function()
		-- can transition?

		if currentState == "Walk" then
			AnimationManager.Stop("Walk")
		end

		currentState = "Idle"

		ActionState:FireServer(currentState)
		AnimationManager.Play(animCache["Idle"], true)
	end,

	["Walk"] = function()
		-- can transition?
		if currentState == "Idle" then
			AnimationManager.Stop("Idle")
		end

		currentState = "Walk"

		ActionState:FireServer(currentState)
		AnimationManager.Play(animCache["Walk"], true)
	end,
}

function ClientStateMachine.Init()
	for _, anim in ReplicatedStorage.Assets.Animations:GetChildren() do
		animCache[anim.Name] = anim
	end

	task.spawn(function()
		States.Idle()
	end)

	hum:GetPropertyChangedSignal("MoveDirection"):Connect(function()
		if hum.MoveDirection.Magnitude > 0 then
			if currentState ~= "Walk" then
				States.Walk()
			end
		elseif hum.MoveDirection.Magnitude == 0 then
			if currentState ~= "Idle" then
				States.Idle()
			end
		end
	end)
end

return ClientStateMachine
