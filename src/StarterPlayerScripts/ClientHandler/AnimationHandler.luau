local AnimationHandler = {}
AnimationHandler.__index = AnimationHandler

function AnimationHandler.new(char)
	local self = setmetatable({}, AnimationHandler)
	local humanoid = char:WaitForChild("Humanoid")

	self.Animator = humanoid:WaitForChild("Animator")
	self.LoadedTracks = {}

	return self
end

function AnimationHandler:LoadAnimation(animInstance)
	local track = self.Animator:LoadAnimation(animInstance)
	self.LoadedTracks[animInstance.Name] = track
end

function AnimationHandler:Play(animName)
	local track = self.LoadedTracks[animName]

	if track then
		track:Play()
	else
		warn(`{animName}, cannot be found in LoadedTracks.`)
	end
end

function AnimationHandler:Stop(animName)
	local track = self.LoadedTracks[animName]

	if track and track.IsPlaying then
		track:Stop()
	end
end

return AnimationHandler
