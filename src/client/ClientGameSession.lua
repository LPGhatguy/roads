local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local NotReallyComponents = Common.NotReallyComponents
local Components = Common.Components

local Roact = require(ReplicatedStorage.Modules.Roact)
local Rodux = require(ReplicatedStorage.Modules.Rodux)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Reducer = require(Common.Reducer)
local renderGame = require(NotReallyComponents.renderGame)

local Game = require(Components.Game)

local Log = require(script.Parent.Log)

local ClientGameSession = {}
ClientGameSession.__index = ClientGameSession

function ClientGameSession.new(initialGameState)
	Log.info("Client game session starting")

	local store = Rodux.Store.new(Reducer, initialGameState)

	local element = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		Game = Roact.createElement(Game),
	})

	local roactTree = Roact.mount(element, nil, "Game")

	return setmetatable({
		store = store,
		roactTree = roactTree,
		components = {
			renderGame(),
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
	-- TODO: Actually destruct the game session?
	Log.info("Client game session ending...")
end

return ClientGameSession