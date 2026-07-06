local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerManager = require(script.Parent.PlayerManager)
local NetworkService = require(ReplicatedStorage.Modules.Shared.Utils.NetworkService)
local ActionEvent: RemoteEvent = NetworkService.GetEvent("ActionEvent")
local WeaponChange: BindableFunction = NetworkService.GetEvent("WeaponChange")

local WeaponManager = {}
WeaponManager.Data = {
	["wpn_mle_scythe"] = {
		Name = "Scythe",
		Weight = 40,

		Color = Color3.fromHSV(0, 0.854902, 1),
		Path = ReplicatedStorage.Assets.Weapons.Scythe,
		ID = "wpn_mle_scythe",
	},

	["wpn_mle_sword"] = {
		Name = "Sword",
		Weight = 50,
		Color = Color3.fromHSV(0.360731, 0.858824, 1),

		Path = ReplicatedStorage.Assets.Weapons.Sword,
		ID = "wpn_mle_sword",
	},
}

local char, plr
local npcWeld, npc

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

			local nWeld = WeaponManager.Data[PlayerManager.Data[p.UserId].Weapon].Path.Welds.NPCWeld:Clone()
			nWeld.Part0 = c.Head
			nWeld.Part1 = n.HumanoidRootPart
			nWeld.Parent = c.Head

			npcWeld = nWeld
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

function WeaponManager.EquipState(isEquipped)
	if isEquipped then
		if not char["Right Arm"]:FindFirstChild("Equip") then
			return
		end

		npcVisible(true)

		local wpnWeld = char["Right Arm"].Equip
		wpnWeld:Destroy()

		local wpn = char[WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Name]
		wpn:Destroy()
	else
		npcVisible(false)

		local wpnWeld = WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Path.Welds.Equip:Clone()
		wpnWeld.Parent = char["Right Arm"]

		local wpn =
			WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Path[WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Name]:Clone()
		wpnWeld.Part0 = char["Right Arm"]
		wpnWeld.Part1 = wpn

		wpn.Parent = char
	end
end

ActionEvent.OnServerEvent:Connect(function(p: Player, equipped: boolean?)
	WeaponManager.EquipState(equipped)
end)

WeaponChange.OnInvoke = function()
	npc:Destroy()
	npcWeld:Destroy()

	local n = WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Path.NPC:Clone()
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

	n.Parent = char

	if WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Name == "Sword" then
		npcWeld = WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Path.Welds.NPCWeld:Clone()
		npcWeld.Part0 = char["Left Arm"]
		npcWeld.Part1 = n.HumanoidRootPart
		npcWeld.Parent = char["Left Arm"]
	else
		npcWeld = WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Path.Welds.NPCWeld:Clone()
		npcWeld.Part0 = char.Head
		npcWeld.Part1 = n.HumanoidRootPart
		npcWeld.Parent = char.Head
	end

	return
end

return WeaponManager
