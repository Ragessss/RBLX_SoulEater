local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
NetworkService.Init()

local SoundEvent: UnreliableRemoteEvent = NetworkService.GetEvent("SoundEvent")

local AnimationManager = require(ReplicatedStorage.Modules.AnimationManager)
AnimationManager.Init()

local ClientStateMachine = require(ReplicatedStorage.Modules.ClientStateMachine)
ClientStateMachine.Init()

local SoundHandler = require(ReplicatedStorage.Modules.SoundHandler)

SoundEvent.OnClientEvent:Connect(function(sound)
	local soundInstance = SoundHandler.GetSound(sound):Clone()
	soundInstance.Parent = SoundService

	soundInstance:Play()
	soundInstance.Ended:Wait()

	soundInstance:Destroy()
end)
