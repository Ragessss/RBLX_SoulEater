local NetworkService = {}
local cache = {}

function NetworkService.Init()
	local Events = script:GetChildren()

	for _, event in Events do
		cache[event.Name] = event
	end
end

function NetworkService.GetEvent(eventName: string)
	assert(cache[eventName], `{eventName}, does not exist.`)

	return cache[eventName]
end

return NetworkService
