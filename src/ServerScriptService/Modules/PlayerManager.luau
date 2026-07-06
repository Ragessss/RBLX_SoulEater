local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
local DataFetch: RemoteFunction = NetworkService.GetEvent("DataFetch")

local PlayerManager = {}
PlayerManager.Data = {}

local plr

function PlayerManager.Init()
	Players.PlayerAdded:Connect(function(p: Player)
		plr = p

		PlayerManager.Data[p.UserId] = {
			Weapon = "wpn_mle_scythe",
			GachaRolls = 5,
		}

		p.CharacterAdded:Connect(function(c)
			for _, part in c:GetDescendants() do
				if part:IsA("BasePart") then
					part.CollisionGroup = "Player"
				end
			end

			-- c.DescendantAdded:Connect(function(part)
			-- 	if part:IsA("BasePart") then
			-- 		part.CollisionGroup = "Player"
			-- 	end
			-- end)
		end)
	end)
end

function PlayerManager.GetData()
	if not PlayerManager.Data[plr.UserId] then
		warn(`{plr.UserId}, does not have any data.`)
	end

	return PlayerManager.Data[plr.UserId]
end

DataFetch.OnServerInvoke = function()
	return PlayerManager.GetData()
end

return PlayerManager
