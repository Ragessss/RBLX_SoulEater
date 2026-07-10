local PlayerObject = {}
PlayerObject.__index = PlayerObject

PlayerObject.ActivePlayers = {}

function PlayerObject.new(plr: Player, weapon: string?)
	local self = setmetatable({}, PlayerObject)

	self.Name = plr.Name
	self.Id = plr.UserId

	self.Weapon = weapon or "Dagger"

	PlayerObject.ActivePlayers[plr.UserId] = self

	return self
end

function PlayerObject:ChangeWeapon(weapon: string)
	self.Weapon = weapon
end

-- || Functions

function PlayerObject.GetPlayer(plr: Player)
	return PlayerObject.ActivePlayers[plr.UserId]
end

function PlayerObject.GetActivePlayers()
	return PlayerObject.ActivePlayers
end

return PlayerObject
