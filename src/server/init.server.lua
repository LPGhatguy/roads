local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(script.Log)

Log.info("Server initializing...")

local Common = ReplicatedStorage.Common

local ServerGameSession = require(script.ServerGameSession)
local ServerApi = require(script.ServerApi)

local Models = require(Common.Models)

Models.WORKAROUND_fixPrimaryPart()
Models.createManifest()

local gameSessionsByPlayer = {}

local server
server = ServerApi.create({
	startGameSession = function(player)
		if gameSessionsByPlayer[player] ~= nil then
			Log.warn("Player {:?} already had a game session.", player.Name)
			return
		end

		local gameSession = ServerGameSession.new(player)
		gameSessionsByPlayer[player] = gameSession

		server:gameSessionStarted(player, gameSession.store:getState())
	end,
	gameInput = function(player, input)
		local gameSession = gameSessionsByPlayer[player]

		if gameSession == nil then
			Log.warn("Player {:?} does not have an active game session.", player.Name)
			return
		end

		local actions = gameSession:processInput(input)

		Log.trace("Sending {} actions to client", #actions)
		server:gameActions(player, actions)
	end,
})

Players.PlayerAdded:Connect(function(player)
	Log.info("Player added: {}", player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
	Log.info("Player removing: {}", player.Name)

	gameSessionsByPlayer[player] = nil
end)

Log.info("Server initialized.")