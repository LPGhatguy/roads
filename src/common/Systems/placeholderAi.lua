local MapLayer = require(script.Parent.Parent.MapLayer)
local Log = require(script.Parent.Parent.Log)

-- FIXME: Need to persist system-specific state on characters?
local dir = 1

local function canMoveHere(state, newPosition)
	local mapLayer = state.mapLayers[newPosition.Z]
	local targetTile = MapLayer.getTile(mapLayer, newPosition.X, newPosition.Y)

	if not targetTile then
		return false
	end

	-- Check for collisions with other characters
	for _, character in pairs(state.characters) do
		if character.position == newPosition then
			return false
		end
	end

	return true
end

local function placeholderAi()
	return function(state, input)
		for characterId, character in pairs(state.characters) do
			if character.tags["placeholder-ai"] then
				local newY = character.position.Y + dir
				local newPosition = Vector3.new(character.position.X, newY, character.position.Z)

				if canMoveHere(state, newPosition) then
					Log.warn("Moving to {}, {}, {}", newPosition.X, newPosition.Y, newPosition.Z)

					-- FIXME: Need to have multiple actions as part of one system?
					return {
						type = "moveCharacter",
						characterId = characterId,
						newPosition = newPosition,
					}
				else
					Log.warn("Can't move there, reversing...")

					dir = -dir
					return nil
				end
			end
		end

		return nil
	end
end

return placeholderAi