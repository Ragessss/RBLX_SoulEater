local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StateHandler = require(ReplicatedStorage.Modules.Shared.StateHandler)
local States = script:GetChildren()

return function(plr)
	local char = plr.Character or plr.CharacterAdded:Wait()

	local serverStateHander = StateHandler.new(char)

	for _, module in States do
		local stateClass = require(module)
		local stateNew = stateClass.new(serverStateHander)

		serverStateHander:AddState(module.Name, stateNew)
	end

	print(`[SERVER] Created ServerStateHandler`)
	print(`[SERVER]`, StateHandler.GetAllPlayers())
end
