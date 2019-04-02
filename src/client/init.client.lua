local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Log = require(script.Log)

Log.info("Client initializing...")

local Common = ReplicatedStorage.Common

local ClientApi = require(script.ClientApi)
local ClientGameSession = require(script.ClientGameSession)

local Models = require(Common.Models)

Models.waitUntilLoaded()

local gameSession

local client
client = ClientApi.connect({
	gameSessionStarted = function(initialGameState)
		gameSession = ClientGameSession.new(initialGameState)
		gameSession:stepSystems()
	end,
	gameActions = function(actions)
		if gameSession == nil then
			Log.warn("No game session active.")
			return
		end

		gameSession:processActions(actions)
		gameSession:stepSystems()
	end,
})

UserInputService.InputBegan:Connect(function(inputObject)
	if gameSession == nil then
		return
	end

	local input

	if inputObject.UserInputType == Enum.UserInputType.Keyboard then
		if inputObject.KeyCode == Enum.KeyCode.Space then
			input = { type = "wait" }
		elseif inputObject.KeyCode == Enum.KeyCode.W then
			input = { type = "move", x = 0, y = 1 }
		elseif inputObject.KeyCode == Enum.KeyCode.S then
			input = { type = "move", x = 0, y = -1 }
		elseif inputObject.KeyCode == Enum.KeyCode.A then
			input = { type = "move", x = 1, y = 0 }
		elseif inputObject.KeyCode == Enum.KeyCode.D then
			input = { type = "move", x = -1, y = 0 }
		end
	end

	if input ~= nil then
		client:gameInput(input)
	end
end)

client:startGameSession()

Log.info("Client initialized.")