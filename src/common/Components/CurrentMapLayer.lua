local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local MapLayer = require(script.Parent.MapLayer)

local CurrentMapLayer = Roact.Component:extend("CurrentMapLayer")

function CurrentMapLayer:render()
	return Roact.createElement("Folder", nil, {
		["1"] = Roact.createElement(MapLayer, {
			mapLayer = self.props.mapLayer
		}),
	})
end

CurrentMapLayer = RoactRodux.connect(
	function(state)
		return {
			mapLayer = state.mapLayers[1],
		}
	end
)(CurrentMapLayer)

return CurrentMapLayer