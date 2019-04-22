local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(script.Log)

Log.info("Client initializing...")

local Common = ReplicatedStorage.Common

local ClientApi = require(script.ClientApi)
local ClientGameSession = require(script.ClientGameSession)
local startInput = require(script.startInput)

local Models = require(Common.Models)

Models.waitUntilLoaded()

local gameSession

local networkClient
networkClient = ClientApi.connect({
	gameSessionStarted = function(initialGameState)
		gameSession = ClientGameSession.new(networkClient, initialGameState)
	end,
	gameActions = function(actions)
		if gameSession == nil then
			Log.warn("No game session active.")
			return
		end

		gameSession:processActions(actions)
	end,
})

local _ = startInput(networkClient)

networkClient:startGameSession()

Log.info("Client initialized.")