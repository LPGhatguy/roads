local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local MapLayer = require(script.Parent.MapLayer)

local CurrentMapLayer = Roact.Component:extend("CurrentMapLayer")

function CurrentMapLayer:render()
	return Roact.createElement("Folder", nil, {
		[tostring(self.props.currentLayerIndex)] = Roact.createElement(MapLayer, {
			mapLayer = self.props.mapLayer,
			playerPosition = self.props.playerPosition,
		}),
	})
end

CurrentMapLayer = RoactRodux.connect(
	function(state)
		local player = state.characters[state.playerCharacterId]
		local currentLayerIndex = player.position.Z

		return {
			mapLayer = state.mapLayers[currentLayerIndex],
			currentLayerIndex = currentLayerIndex,
			playerPosition = player.position,
		}
	end
)(CurrentMapLayer)

return CurrentMapLayer