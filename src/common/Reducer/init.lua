local mapLayers = require(script.mapLayers)
local characters = require(script.characters)

local function reducer(state, action)
	if state == nil then
		state = {}
	end

	return {
		playerCharacterId = 1,
		mapLayers = mapLayers(state.mapLayers, action),
		characters = characters(state.characters, action),
	}
end

return reducer