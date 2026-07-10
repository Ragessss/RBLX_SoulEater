local Idle = {}
Idle.__index = Idle

function Idle.new(StateHandler)
	local self = setmetatable({}, Idle)

	self.StateHandler = StateHandler

	return self
end

function Idle:Enter()
	-- self.StateHandler.AnimationHandler:Play("Idle")
end

function Idle:Exit()
	-- self.StateHandler.AnimationHandler:Stop("Idle")
end

return Idle
