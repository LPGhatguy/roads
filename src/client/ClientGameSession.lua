local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules
local Common = ReplicatedStorage.Common
local Components = Common.Components

local Roact = require(Modules.Roact)
local Rodux = require(Modules.Rodux)
local RoactRodux = require(Modules.RoactRodux)

local Action = require(Common.Action)
local Reducer = require(Common.Reducer)

local Game = require(Components.Game)
local NetworkClient = require(Components.NetworkClient)

local Log = require(script.Parent.Log)

local ClientGameSession = {}
ClientGameSession.__index = ClientGameSession

function ClientGameSession.new(networkClient, initialGameState)
	Log.info("Client game session starting")

	local store = Rodux.Store.new(Reducer, initialGameState)

	local element = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		NetworkClient = Roact.createElement(NetworkClient.Provider, {
			networkClient = networkClient,
		}, {
			Game = Roact.createElement(Game),
		}),
	})

	local roactTree = Roact.mount(element, nil, "Game")

	return setmetatable({
		store = store,
		roactTree = roactTree,
	}, ClientGameSession)
end

function ClientGameSession:processActions(actions)
	for _, action in ipairs(actions) do
		local ok, message = Action.validate(action)

		if ok then
			self.store:dispatch(action)
		else
			Log.warn("Invalid action:\n{:?}\n{}", action, message)
		end
	end
end

function ClientGameSession:stop()
	if self.stopped then
		return
	end

	self.stopped = true

	Log.info("Client game session ending...")

	Roact.unmount(self.roactTree)
end

return ClientGameSession