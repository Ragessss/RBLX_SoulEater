local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
NetworkService.Init()

local ServerStateMachine = require(ServerScriptService.Modules.ServerStateMachine)
ServerStateMachine.Init()
