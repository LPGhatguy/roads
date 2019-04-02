local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MapLayer = require(ReplicatedStorage.Common.MapLayer)

local ServerGameState = {}

function ServerGameState.new()
	return {
		mapLayers = {
			MapLayer.TEMP_generate(),
		},
		playerCharacterId = 1,
		characters = {
			{
				position = Vector3.new(1, 1, 1),
			},
		},
	}
end

function ServerGameState:viewAsClient()
	return self
end

return ServerGameState