local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local MapLayer = require(Common.MapLayer)

local MapTile = require(script.Parent.MapTile)

local MapLayerComponent = Roact.Component:extend("MapLayerComponent")

function MapLayerComponent:render()
	local mapLayer = self.props.mapLayer
	local playerPosition = self.props.playerPosition

	local heroPosXY = Vector2.new(playerPosition.X, playerPosition.Y)

	-- TODO: Accept lights as props

	local children = {}

	for x = -1, mapLayer.width + 1 do
		for y = -1, mapLayer.height + 1 do
			local tile = MapLayer.getTile(mapLayer, x, y)

			local occupancy = {
				self = tile,
			}

			occupancy.north = MapLayer.getTile(mapLayer, x, y + 1)
			occupancy.south = MapLayer.getTile(mapLayer, x, y - 1)
			occupancy.west = MapLayer.getTile(mapLayer, x - 1, y)
			occupancy.east = MapLayer.getTile(mapLayer, x + 1, y)

			occupancy.northEast = not occupancy.north and not occupancy.east and MapLayer.getTile(mapLayer, x + 1, y + 1)
			occupancy.southEast = not occupancy.south and not occupancy.east and MapLayer.getTile(mapLayer, x + 1, y - 1)
			occupancy.southWest = not occupancy.south and not occupancy.west and MapLayer.getTile(mapLayer, x - 1, y - 1)
			occupancy.northWest = not occupancy.north and not occupancy.west and MapLayer.getTile(mapLayer, x - 1, y + 1)

			if occupancy.north or occupancy.south or occupancy.west or occupancy.east
				or occupancy.northEast or occupancy.southEast or occupancy.southWest or occupancy.northWest
			then
				local tilePos = Vector2.new(x, y)
				local distance = (heroPosXY - tilePos).magnitude

				local lighting = 1 - math.clamp(distance, 0, 8) / 8

				children[("(%d, %d)"):format(x, y)] = Roact.createElement(MapTile, {
					position = Vector2.new(x, y),
					occupancy = occupancy,
					lighting = lighting,
				})
			end
		end
	end

	return Roact.createElement("Folder", nil, children)
end

return MapLayerComponent