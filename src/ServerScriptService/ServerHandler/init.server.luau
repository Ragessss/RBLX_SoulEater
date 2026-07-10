local Players = game:GetService("Players")

local PlayerObject = require(script.PlayerObject)
local StateServer = require(script.StateServer)

Players.PlayerAdded:Connect(function(plr: Player)
	local plrObj = PlayerObject.new(plr)
	print(`[SERVER] Created PlayerObject.`, plrObj)

	StateServer(plr)
end)
