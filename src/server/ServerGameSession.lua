local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Systems = Common.Systems

local playerMovement = require(Systems.playerMovement)
local Mutation = require(Common.Mutation)

local Log = require(script.Parent.Log)
local ServerGameState = require(script.Parent.ServerGameState)

local ServerGameSession = {}
ServerGameSession.__index = ServerGameSession

function ServerGameSession.new(player)
	assert(typeof(player) == "Instance")
	assert(player:IsA("Player"))

	Log.info(("Server game session for player %s starting"):format(player.Name))

	return setmetatable({
		player = player,
		state = ServerGameState.new(),
		systems = {
			playerMovement(),
		},
	}, ServerGameSession)
end

function ServerGameSession:processInput(input)
	local mutations = {}

	for _, system in ipairs(self.systems) do
		local mutation = system(self.state, input)

		if mutation ~= nil then
			table.insert(mutations, mutation)
			Mutation.process(self.state, mutation)
		end
	end

	return mutations
end

function ServerGameSession:stop()
	Log.info(("Server game session for player %s ending"):format(self.player.Name))
end

return ServerGameSession