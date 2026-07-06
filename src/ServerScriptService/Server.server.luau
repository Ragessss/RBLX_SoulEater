local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
NetworkService.Init()

local PlayerManager = require(ServerScriptService.Modules.PlayerManager)
PlayerManager.Init()

local ServerStateMachine = require(ServerScriptService.Modules.ServerStateMachine)
ServerStateMachine.Init()

local WeaponManager = require(ServerScriptService.Modules.WeaponManager)
WeaponManager.Init()

local GachaManager = require(ServerScriptService.Modules.GachaManager)
GachaManager.Init()
