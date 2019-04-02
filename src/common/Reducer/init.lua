local Log = require(script.Parent.Log)
local MapLayer = require(script.Parent.MapLayer)

local function join(...)
	local output = {}

	for i = 1, select("#", ...) do
		local source = select(i, ...)

		for key, value in pairs(source) do
			output[key] = value
		end
	end

	return output
end

local function mapLayers(state, action)
	if state == nil then
		state = {
			MapLayer.TEMP_generate(),
		}
	end

	return state
end

local function playerCharacterId(state, action)
	return 1
end

local function characters(state, action)
	if state == nil then
		state = {
			{
				position = Vector3.new(1, 1, 1),
			},
		}
	end

	if action.type == "moveCharacter" then
		local character = state[action.characterId]

		if character == nil then
			Log.warn("Couldn't move character ID %d: it did not exist", action.characterId)
			return state
		end

		return join(state, {
			[action.characterId] = join(character, {
				position = action.newPosition,
			}),
		})
	end

	return state
end

local function reducer(state, action)
	if state == nil then
		state = {}
	end

	return {
		mapLayers = mapLayers(state.mapLayers, action),
		playerCharacterId = playerCharacterId(state.playerCharacterId, action),
		characters = characters(state.characters, action),
	}
end

return reducer