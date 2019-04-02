local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.Modules.t)

local Action = require(script.Parent.Action)
local validateInput = require(script.Parent.validateInput)

local function args(...)
	local numArguments = select("#", ...)
	local arguments = {...}

	return function(...)
		if select("#", ...) ~= numArguments then
			local message = ("Wrong number of arguments. Expected %d arguments, got %d.")
				:format(numArguments, select("#", ...))

			return false, message
		end

		for i = 1, numArguments do
			local value = select(i, ...)
			local argument = arguments[i]
			local success, message = argument[2](value)

			if not success then
				return false, ("Invalid argument %s (#%d): %s"):format(argument[1], i, message)
			end
		end

		return true
	end
end

return {
	fromClient = {
		startGameSession = {
			arguments = args(),
		},
		gameInput = {
			arguments = args(
				{"input", validateInput}
			),
		},
	},
	fromServer = {
		gameSessionStarted = {
			arguments = args(
				{"initialGameState", t.table}
			),
		},
		gameActions = {
			arguments = args(
				{"actions", t.array(Action.validate)}
			),
		},
	},
}