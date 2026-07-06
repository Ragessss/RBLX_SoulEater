local TweenService = game:GetService("TweenService")
local PlayerManager = require(script.Parent.PlayerManager)
local WeaponManager = require(script.Parent.WeaponManager)
local GachaManager = {}

local plr
local gachaNPC
local debounce = false

local function Roll()
	local plrGui = plr:WaitForChild("PlayerGui")
	local gachaGui = plrGui:WaitForChild("GachaGui")
	local frame = gachaGui:WaitForChild("Main")

	local RollFrame = frame:WaitForChild("RollFrame")
	local rollingFrame = RollFrame:WaitForChild("Rolling")
	local stroke = rollingFrame:WaitForChild("UIStroke")
	local weaponLabel = rollingFrame:WaitForChild("WeaponLabel")
	local rollsLabel = rollingFrame:WaitForChild("RollsLabel")

	if PlayerManager.Data[plr.UserId].GachaRolls <= 0 then
		return
	end

	local rolling = false

	local totalWeight = 0
	local weaponCache = {}

	for _, weapon in WeaponManager.Data do
		totalWeight += weapon.Weight

		table.insert(weaponCache, weapon)
	end

	local pickedNum = math.random(0, totalWeight)
	local total = 0

	weaponLabel.TextColor3 = Color3.new(1, 1, 1)
	stroke.Color = Color3.new(1, 1, 1)

	PlayerManager.Data[plr.UserId].GachaRolls -= 1

	rollsLabel.Text = `{PlayerManager.Data[plr.UserId].GachaRolls} ROLL/S LEFT`

	print("Rolling")
	rolling = true

	task.spawn(function()
		repeat
			for _, weapon in WeaponManager.Data do
				print(weapon.Name)
				task.wait(0.05)
				if not rolling then
					return
				end
				weaponLabel.Text = weapon.Name
			end
		until not rolling
	end)

	task.wait(3)
	rolling = false

	for _, weapon in WeaponManager.Data do
		total += weapon.Weight

		if pickedNum <= total then
			weaponLabel.Text = weapon.Name

			weaponLabel.TextColor3 = weapon.Color
			stroke.Color = weapon.Color

			print(`{weapon.Name}, won!`)
			return weapon
		end
	end

	return nil
end

function GachaManager.Init()
	gachaNPC = workspace:WaitForChild("GachaNPC")

	local hrp = gachaNPC:WaitForChild("HumanoidRootPart")
	local prompt = hrp:WaitForChild("ProximityPrompt")

	prompt.Triggered:Connect(function(p)
		plr = p

		local plrGui = p:WaitForChild("PlayerGui")
		local gachaGui = plrGui:WaitForChild("GachaGui")

		local frame = gachaGui:WaitForChild("Main")
		local plrFrame = frame:WaitForChild("PlayerFrame")
		local worldModel = plrFrame:WaitForChild("WorldModel")
		local CloseBtn = frame:WaitForChild("CloseBtn")

		local RollFrame = frame:WaitForChild("RollFrame")
		local RollBtn = RollFrame:WaitForChild("Roll")

		local rollingFrame = RollFrame:WaitForChild("Rolling")
		local weaponLabel = rollingFrame:WaitForChild("WeaponLabel")
		weaponLabel.Text = WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Name
		weaponLabel.TextColor3 = WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Color

		local stroke = rollingFrame:WaitForChild("UIStroke")
		stroke.Color = WeaponManager.Data[PlayerManager.Data[plr.UserId].Weapon].Color

		local rollsLabel = rollingFrame:WaitForChild("RollsLabel")
		rollsLabel.Text = `{PlayerManager.Data[plr.UserId].GachaRolls} ROLL/S LEFT`

		local character = p.Character

		character.Archivable = true
		local charModel = character:Clone()
		character.Archivable = false

		charModel.Parent = worldModel
		charModel:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))

		frame.Visible = true

		task.spawn(function()
			local charHRP = charModel:FindFirstChild("HumanoidRootPart")
			local info = TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false)
			local goals = { Orientation = Vector3.new(0, 360, 0) }
			local tween = TweenService:Create(charHRP, info, goals)
			tween:Play()
		end)

		CloseBtn.MouseButton1Click:Connect(function()
			charModel:Destroy()
			frame.Visible = false
		end)

		RollBtn.MouseButton1Click:Connect(function()
			if not debounce then
				debounce = true
				local weapon = Roll()
				debounce = false
				print(weapon)

				if weapon then
					PlayerManager.Data[plr.UserId].Weapon = weapon.ID
				end
			end
		end)
	end)
end

return GachaManager

-- it currently adds the weapon table, not the id fix ts.
