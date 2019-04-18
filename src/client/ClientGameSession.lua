local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local NotReallyComponents = Common.NotReallyComponents

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local Reducer = require(Common.Reducer)
local moveCamera = require(NotReallyComponents.moveCamera)
local renderGame = require(NotReallyComponents.renderGame)
local renderCharacters = require(NotReallyComponents.renderCharacters)

local Log = require(script.Parent.Log)

local ClientGameSession = {}
ClientGameSession.__index = ClientGameSession

function ClientGameSession.new(initialGameState)
	Log.info("Client game session starting")

	return setmetatable({
		store = Rodux.Store.new(Reducer, initialGameState),
		components = {
			moveCamera(),
			renderGame(),
			renderCharacters(),
		},
	}, ClientGameSession)
end

function ClientGameSession:stepComponents()
	for _, component in ipairs(self.components) do
		component(self.store:getState())
	end
end

function ClientGameSession:processActions(actions)
	for _, action in ipairs(actions) do
		self.store:dispatch(action)
	end
end

function ClientGameSession:stop()
	Log.info("Client game session ending")
end

return ClientGameSession