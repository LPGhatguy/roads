local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local MapLayer = require(Common.MapLayer)
local World = require(Common.World)

local MapTile = require(script.Parent.MapTile)
local MapTileWall = require(script.Parent.MapTileWall)

local MapLayerComponent = Roact.Component:extend("MapLayerComponent")

function MapLayerComponent:render()
	local mapLayer = self.props.mapLayer

	local children = {}

	for x = -1, mapLayer.width + 1 do
		for y = -1, mapLayer.height + 1 do
			local tile = MapLayer.getTile(mapLayer, x, y)

			if tile then
				children[("(%d, %d)"):format(x, y)] = Roact.createElement(MapTile, {
					position = Vector2.new(x, y),
				})
			else
				local north = MapLayer.getTile(mapLayer, x, y + 1)
				local south = MapLayer.getTile(mapLayer, x, y - 1)
				local west = MapLayer.getTile(mapLayer, x - 1, y)
				local east = MapLayer.getTile(mapLayer, x + 1, y)

				local northEast = not north and not east and MapLayer.getTile(mapLayer, x + 1, y + 1)
				local southEast = not south and not east and MapLayer.getTile(mapLayer, x + 1, y - 1)
				local southWest = not south and not west and MapLayer.getTile(mapLayer, x - 1, y - 1)
				local northWest = not north and not west and MapLayer.getTile(mapLayer, x - 1, y + 1)

				if north or south or west or east or northEast or southEast or southWest or northWest then
					children[("(%d, %d)"):format(x, y)] = Roact.createElement(MapTileWall, {
						position = Vector2.new(x, y),
						walls = {
							north = north,
							south = south,
							west = west,
							east = east,
						},
						posts = {
							northEast = northEast,
							southEast = southEast,
							southWest = southWest,
							northWest = northWest,
						},
					})
				end
			end
		end
	end

	return Roact.createElement("Folder", nil, children)
end

return MapLayerComponent