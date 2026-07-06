local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerManager = require(script.Parent.PlayerManager)
local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
local ActionEvent: RemoteEvent = NetworkService.GetEvent("ActionEvent")

local WeaponManager = {}
WeaponManager.Data = {
	["wpn_mle_scythe"] = {
		Name = "Scythe",
		Weight = 40,

		Color = Color3.fromHSV(0, 0.854902, 1),
		Path = ReplicatedStorage.Assets.Weapons.Scythe,
	},

	["wpn_mle_sword"] = {
		Name = "Sword",
		Weight = 50,
		Color = Color3.fromHSV(0.360731, 0.858824, 1),

		-- Path = ReplicatedStorage.Assets.Weapons.Sword,
	},
}

local char, npc, plr

function WeaponManager.Init()
	Players.PlayerAdded:Connect(function(p: Player)
		plr = p

		p.CharacterAdded:Connect(function(c)
			char = c

			-- get plr weapon
			local n = WeaponManager.Data[PlayerManager.Data[p.UserId].Weapon].Path.NPC:Clone()
			npc = n

			local humanoid = n:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.PlatformStand = true
				humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			end

			for _, part in n:GetDescendants() do
				if part:IsA("BasePart") then
					part.Anchored = false
					part.CanCollide = false
					part.Massless = true
					part.CollisionGroup = "WeaponNPC"
				end
			end

			n.Parent = c

			local npcWeld = WeaponManager.Data[PlayerManager.Data[p.UserId].Weapon].Path.Welds.NPCWeld:Clone()
			npcWeld.Part0 = c.Head
			npcWeld.Part1 = n.HumanoidRootPart
			npcWeld.Parent = c.HumanoidRootPart
		end)
	end)
end

local function npcVisible(visible: boolean)
	for _, part in npc:GetDescendants() do
		if part:IsA("BasePart") or part:IsA("Decal") then
			if part.Name == "HumanoidRootPart" then
				continue
			end

			part.Transparency = visible and 0 or 1
		end
	end
end

function WeaponManager.Equip()
	npcVisible(false)

	local wpnWeld = WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Path.Welds.Equip:Clone()
	wpnWeld.Parent = char["Right Arm"]

	local wpn = WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Path.Scythe:Clone()
	wpnWeld.Part0 = char["Right Arm"]
	wpnWeld.Part1 = wpn

	wpn.Parent = char
end

function WeaponManager.UnEquip()
	npcVisible(true)

	local wpnWeld = char["Right Arm"].Equip
	wpnWeld:Destroy()

	local wpn = char.Scythe
	wpn:Destroy()
end

ActionEvent.OnServerEvent:Connect(function(p: Player, equipped: boolean?)
	if equipped then
		WeaponManager.UnEquip()
	else
		WeaponManager.Equip()
	end
end)

return WeaponManager
