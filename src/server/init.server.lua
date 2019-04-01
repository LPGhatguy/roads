local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Log = require(script.Log)

Log.info("Server initializing...")

local Common = ReplicatedFirst.Common

local ServerGameSession = require(script.ServerGameSession)
local ServerGameState = require(script.ServerGameState)
local ServerApi = require(script.ServerApi)

local Models = require(Common.Models)

Models.WORKAROUND_fixPrimaryPart()
Models.createManifest()

local gameSessionsByPlayer = {}

local server
server = ServerApi.create({
	startGameSession = function(player)
		if gameSessionsByPlayer[player] ~= nil then
			Log.warn("Player %s already had a game session.", player.Name)
			return
		end

		local gameSession = ServerGameSession.new(player)
		gameSessionsByPlayer[player] = gameSession

		server:gameSessionStarted(player, ServerGameState.viewAsClient(gameSession.state))
	end,
	gameInput = function(player, input)
		local gameSession = gameSessionsByPlayer[player]

		if gameSession == nil then
			Log.warn("Player %s does not have an active game session.", player.Name)
			return
		end

		local mutations = gameSession:processInput(input)

		Log.trace("Sending %d mutations to client", #mutations)
		server:gameMutations(player, mutations)
	end,
})

Players.PlayerAdded:Connect(function(player)
	Log.info("Player added: %s", player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
	Log.info("Player removing: %s", player.Name)

	gameSessionsByPlayer[player] = nil
end)

Log.info("Server initialized.")