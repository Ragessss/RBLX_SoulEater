local Walk = {}
Walk.__index = Walk

function Walk.new(StateHandler)
	local self = setmetatable({}, Walk)

	self.StateHandler = StateHandler

	return self
end

function Walk:Enter()
	-- self.StateHandler.AnimationHandler:Play("Walk")
end

function Walk:Exit()
	-- self.StateHandler.AnimationHandler:Stop("Walk")
end

return Walk
