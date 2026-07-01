local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AnimationManager = {}
local cache = {}

AnimationManager.Animations = {}
AnimationManager.PlayerCache = {}

local anims = ReplicatedStorage.Assets:GetDescendants()

local plr: Player = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum: Humanoid = char:FindFirstChildOfClass("Humanoid")
local animator = hum:FindFirstChild("Animator")

function AnimationManager.Init()
	for _, animation in anims do
		if animation:IsA("Animation") then
			table.insert(cache, animation)
		end
	end

	for _, animation in anims do
		if animation:IsA("Animation") then
			AnimationManager.Animations[animation.Name] = animation
		end
	end

	ContentProvider:PreloadAsync(cache)
	print(`{#cache} Animations have been loaded.`)

	AnimationManager.PlayerCache[char] = {}

	task.spawn(function()
		while true do
			task.wait(0.5)
			print(AnimationManager.PlayerCache[char])
		end
	end)
end

function AnimationManager.Play(animInstance: Animation, looped: boolean?)
	assert(char or animInstance, `Invalid parameters, cannot play Animation.`)

	if AnimationManager.PlayerCache[char][animInstance.Name] then
		warn(`{char.Name}, already has {animInstance.AnimationId}, playing.`)
	end

	local track = animator:LoadAnimation(animInstance)
	if looped then
		track.Looped = true
	else
		track.Looped = false
	end

	AnimationManager.PlayerCache[char][animInstance.Name] = track

	track:Play()
	track.Stopped:Wait()

	AnimationManager.PlayerCache[char][animInstance.Name] = nil
end

function AnimationManager.Stop(animName: string)
	if not AnimationManager.PlayerCache[char][animName] then
		warn(`{char.Name}, has no animation playing by the name, {animName}.`)
		return
	end

	local track = AnimationManager.PlayerCache[char][animName]
	track:Stop()

	AnimationManager.PlayerCache[char][animName] = nil
end

function AnimationManager.StopAll()
	if not AnimationManager.PlayerCache[char] then
		warn(`{char.Name}, has no animations playing.`)
		return
	end

	for _, track in AnimationManager.PlayerCache[char] do
		track:Stop()
	end
end

return AnimationManager
