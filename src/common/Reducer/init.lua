local mapLayers = require(script.mapLayers)
local characters = require(script.characters)
local characterInventories = require(script.characterInventories)

local function reducer(state, action)
	if state == nil then
		state = {}
	end

	return {
		playerCharacterId = 1,
		mapLayers = mapLayers(state.mapLayers, action),
		characters = characters(state.characters, action),
		characterInventories = characterInventories(state.characterInventories, action),
	}
end

return reducer