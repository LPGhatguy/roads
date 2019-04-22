local Common = script.Parent.Parent

local MapLayer = require(Common.MapLayer)

local function mapLayers(state, action)
	if state == nil then
		state = {
			MapLayer.TEMP_generate(),
		}
	end

	return state
end

return mapLayers