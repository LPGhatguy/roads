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
				Log.warn("Couldn't move to tile {}, {}: it's a wall", newX, newY)
				return nil
			end

			local newPosition = Vector3.new(newX, newY, layerIndex)

			-- Check for collisions with other characters
			for _, character in pairs(state.characters) do
				if character.position == newPosition then
					Log.warn("Couldn't move to tile {}, {}: someone is already there!", newX, newY)
					return nil
				end

				-- TODO: If character is friendly towards player, swap positions?
			end

			-- TODO: check for other characters here, attack instead?

			return {
				type = "moveCharacter",
				characterId = state.playerCharacterId,
				newPosition = newPosition,
			}
		end
	end
end

return playerMovement