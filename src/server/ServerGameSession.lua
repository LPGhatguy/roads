local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Systems = Common.Systems

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local Reducer = require(Common.Reducer)
local playerMovement = require(Systems.playerMovement)

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
		systems = {
			playerMovement(),
		},
	}, ServerGameSession)
end

function ServerGameSession:processInput(input)
	local actions = {}

	for _, system in ipairs(self.systems) do
		local action = system(self.store:getState(), input)

		if action ~= nil then
			self.store:dispatch(action)
			table.insert(actions, action)
		end
	end

	return actions
end

function ServerGameSession:stop()
	Log.info("Server game session for player {} ending", self.player.Name)
end

return ServerGameSession