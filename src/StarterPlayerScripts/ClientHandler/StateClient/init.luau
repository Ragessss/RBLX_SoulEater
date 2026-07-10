local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AnimationHandler = require(script.Parent.AnimationHandler)
local StateHandler = require(ReplicatedStorage.Modules.Shared.StateHandler)

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local _ = plr.CharacterAppearanceLoaded:Wait() -- Yields for the Character.
local hum: Humanoid = char:WaitForChild("Humanoid")

local States = script:GetChildren()

local plrAnimationHandler = AnimationHandler.new(char)
local clientStateHandler = StateHandler.new(char, plrAnimationHandler)

return function()
	for _, module in States do
		local stateClass = require(module)
		local stateNew = stateClass.new(clientStateHandler)

		clientStateHandler:AddState(module.Name, stateNew)
	end

	print(`[CLIENT] Created ClientStateHandler`)

	for _, animation in ReplicatedStorage.Assets:GetDescendants() do
		if animation:IsA("Animation") then
			plrAnimationHandler:LoadAnimation(animation)
		end
	end

	print(`[CLIENT] Created AnimationHandler`)
	print(`[CLIENT]`, StateHandler.GetAllPlayers())

	clientStateHandler:OverrideState("Idle")

	hum:GetPropertyChangedSignal("MoveDirection"):Connect(function()
		if hum.MoveDirection.Magnitude > 0 then
			clientStateHandler:ChangeState("Walk")
		else
			clientStateHandler:ChangeState("Idle")
		end
	end)
end
