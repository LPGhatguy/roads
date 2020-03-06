local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules
local Common = ReplicatedStorage.Common

local Rodux = require(Modules.Rodux)

local Reducer = require(Common.Reducer)
local Action = require(Common.Action)
local Systems = require(Common.Systems)

local Log = require(script.Parent.Log)

local ServerGameSession = {}
ServerGameSession.__index = ServerGameSession

function ServerGameSession.new(player)
	assert(typeof(player) == "Instance")
	assert(player:IsA("Player"))

	Log.info("Server game session for player {} starting", player.Name)

	return setmetatable({
		store = Rodux.Store.new(Reducer),
		player = player,
		systems = Systems,
	}, ServerGameSession)
end

function ServerGameSession:processInput(input)
	local actions = {}

	for _, system in ipairs(self.systems) do
		local action = system(self.store:getState(), input)

		if action ~= nil then
			local ok, message = Action.validate(action)

			if ok then
				self.store:dispatch(action)
				table.insert(actions, action)
			else
				Log.warn("Invalid action:\n{:?}\n{}", action, message)
			end
		end
	end

	return actions
end

function ServerGameSession:stop()
	Log.info("Server game session for player {} ending", self.player.Name)
end

return ServerGameSession