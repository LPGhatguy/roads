local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Systems = ReplicatedFirst.Common.Systems

local Mutation = require(ReplicatedFirst.Common.Mutation)
local moveCamera = require(Systems.moveCamera)
local renderGame = require(Systems.renderGame)
local renderCharacters = require(Systems.renderCharacters)

local Log = require(script.Parent.Log)

local ClientGameSession = {}
ClientGameSession.__index = ClientGameSession

function ClientGameSession.new(initialGameState)
	Log.info("Client game session starting")

	return setmetatable({
		state = initialGameState,
		systems = {
			moveCamera(),
			renderGame(),
			renderCharacters(),
		},
	}, ClientGameSession)
end

function ClientGameSession:stepSystems()
	for _, system in ipairs(self.systems) do
		system(self.state)
	end
end

function ClientGameSession:processMutations(mutations)
	for _, mutation in ipairs(mutations) do
		Mutation.process(self.state, mutation)
	end
end

function ClientGameSession:stop()
	Log.info("Client game session ending")
end

return ClientGameSession