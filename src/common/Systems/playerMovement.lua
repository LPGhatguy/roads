local MapLayer = require(script.Parent.Parent.MapLayer)
local Log = require(script.Parent.Parent.Log)

local function playerMovement()
	return function(state, input)
		if input.type == "move" then
			local player = state.characters[state.playerCharacterId]

			local newX = player.position.X + input.x
			local newY = player.position.Y + input.y

			local layerIndex = player.position.Z
			local currentLayer = state.mapLayers[layerIndex]

			local targetTile = MapLayer.getTile(currentLayer, newX, newY)

			if not targetTile then
				Log.warn("Couldn't move to tile {}, {}", newX, newY)
				return
			end

			-- TODO: check for other characters here, attack instead?

			return {
				type = "moveCharacter",
				characterId = state.playerCharacterId,
				newPosition = Vector3.new(newX, newY, layerIndex),
			}
		end
	end
end

return playerMovement