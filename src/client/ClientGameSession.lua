local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Systems = Common.Systems

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local Reducer = require(Common.Reducer)
local moveCamera = require(Systems.moveCamera)
local renderGame = require(Systems.renderGame)
local renderCharacters = require(Systems.renderCharacters)

local Log = require(script.Parent.Log)

local ClientGameSession = {}
ClientGameSession.__index = ClientGameSession

function ClientGameSession.new(initialGameState)
	Log.info("Client game session starting")

	return setmetatable({
		store = Rodux.Store.new(Reducer, initialGameState),
		systems = {
			moveCamera(),
			renderGame(),
			renderCharacters(),
		},
	}, ClientGameSession)
end

function ClientGameSession:stepSystems()
	for _, system in ipairs(self.systems) do
		system(self.store:getState())
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