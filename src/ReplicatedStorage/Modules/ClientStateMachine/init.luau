local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local AnimationManager = require(script.Parent.AnimationManager)

local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
local ActionState: RemoteEvent = NetworkService.GetEvent("ActionState")
local DataFetch: RemoteFunction = NetworkService.GetEvent("DataFetch")
local ActionEvent: RemoteEvent = NetworkService.GetEvent("ActionEvent")

local plr: Player = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum: Humanoid = char:FindFirstChildOfClass("Humanoid")

local currentState, plrData, isEquipped

local ClientStateMachine = {}
local animCache = AnimationManager.Animations

local States = {
	["Idle"] = function()
		-- can transition?
		if currentState then
			AnimationManager.Stop(currentState)
		end

		currentState = "Idle"

		ActionState:FireServer(currentState)
		AnimationManager.Play(animCache["Idle"], true)
	end,

	["Walk"] = function()
		-- can transition?
		if currentState then
			AnimationManager.Stop(currentState)
		end

		currentState = "Walk"

		ActionState:FireServer(currentState)
		AnimationManager.Play(animCache["Walk"], true)
	end,
}

local function Equip()
	AnimationManager.Play(animCache["S_Equip"])
	ActionEvent:FireServer(isEquipped)
	isEquipped = true
end

local function UnEquip()
	AnimationManager.Play(animCache["S_UnEquip"])
	ActionEvent:FireServer(isEquipped)
	isEquipped = false
end

function ClientStateMachine.Init()
	task.spawn(function()
		States.Idle()

		plrData = DataFetch:InvokeServer()
		assert(plrData, `DataFetch recieved, {plrData}.`)
	end)

	isEquipped = false

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

	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then
			return
		end

		if input.KeyCode == Enum.KeyCode.E then
			if isEquipped then
				UnEquip()
			else
				Equip()
			end
		end
	end)
end

return ClientStateMachine
