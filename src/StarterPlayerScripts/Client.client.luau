local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
NetworkService.Init()

local AnimationManager = require(ReplicatedStorage.Modules.AnimationManager)
AnimationManager.Init()

local ClientStateMachine = require(ReplicatedStorage.Modules.ClientStateMachine)
ClientStateMachine.Init()
