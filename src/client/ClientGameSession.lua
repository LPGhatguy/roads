local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Components = Common.Components

local Roact = require(ReplicatedStorage.Modules.Roact)
local Rodux = require(ReplicatedStorage.Modules.Rodux)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Reducer = require(Common.Reducer)

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
	}, ClientGameSession)
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