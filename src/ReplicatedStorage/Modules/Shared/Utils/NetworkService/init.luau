local NetworkService = {}
NetworkService.Cache = {}

function NetworkService.Init()
	local Events = script:GetChildren()

	for _, event in Events do
		NetworkService.Cache[event.Name] = event
	end
end

function NetworkService.GetEvent(eventName: string)
	assert(NetworkService.Cache[eventName], `{eventName}, does not exist.`)

	return NetworkService.Cache[eventName]
end

return NetworkService
