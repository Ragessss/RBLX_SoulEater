local StateInfo = {}

StateInfo.States = {
	["Idle"] = { "Walk" },
	["Walk"] = { "Idle" },
}

function StateInfo.canTransition(currentState: string, newState: string)
	assert(
		StateInfo.States[currentState] and table.find(StateInfo.States[currentState], newState),
		`Invalid transition from {currentState} to {newState}`
	)

	if table.find(StateInfo.States[currentState], newState) then
		return true
	else
		return false
	end
end

return StateInfo
