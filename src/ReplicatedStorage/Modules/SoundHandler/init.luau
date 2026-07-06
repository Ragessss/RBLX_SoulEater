local SoundHandler = {}

function SoundHandler.Play(sound)
	sound:Play()
end

function SoundHandler.GetSound(soundName)
	for _, sound in script:GetChildren() do
		if sound.Name == soundName then
			return sound
		end
	end

	return
end

return SoundHandler
