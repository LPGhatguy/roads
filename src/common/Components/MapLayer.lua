local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local MapLayer = require(Common.MapLayer)
local World = require(Common.World)

local MapTile = require(script.Parent.MapTile)

local MapLayerComponent = Roact.Component:extend("MapLayerComponent")

function MapLayerComponent:render()
	local mapLayer = self.props.mapLayer

	local children = {}

	for x = 1, mapLayer.width do
		for y = 1, mapLayer.height do
			local tile = MapLayer.getTile(mapLayer, x, y)

			if tile then
				local worldPos = World.tileToWorld(Vector2.new(x, y))

				local north = MapLayer.getTile(mapLayer, x, y + 1)
				local south = MapLayer.getTile(mapLayer, x, y - 1)
				local west = MapLayer.getTile(mapLayer, x - 1, y)
				local east = MapLayer.getTile(mapLayer, x + 1, y)

				local tileName
				local transform = CFrame.new(Vector3.new(worldPos.X, 0, worldPos.Y))

				-- I wish I had ML-style pattern matching here

				local numberAdjacent = 0
					+ (north and 1 or 0)
					+ (south and 1 or 0)
					+ (west and 1 or 0)
					+ (east and 1 or 0)

				if numberAdjacent == 0 then
					tileName = "Empty"
				elseif numberAdjacent == 1 then
					tileName = "Empty"
				elseif numberAdjacent == 2 then
					if (north and south) or (west and east) then
						tileName = "Hall"

						if west then
							transform = transform * CFrame.Angles(0, math.pi / 2, 0)
						end
					else
						tileName = "Corner"

						if north and west then
							-- we're done
						elseif north and east then
							transform = transform * CFrame.Angles(0, math.pi / 2, 0)
						elseif south and east then
							transform = transform * CFrame.Angles(0, math.pi, 0)
						elseif south and west then
							transform = transform * CFrame.Angles(0, -math.pi / 2, 0)
						else
							error("unreachable")
						end
					end
				elseif numberAdjacent == 3 then
					tileName = "Wall"

					if not south then
						transform = transform * CFrame.Angles(0, math.pi / 2, 0)
					elseif not north then
						transform = transform * CFrame.Angles(0, -math.pi / 2, 0)
					elseif not west then
						transform = transform * CFrame.Angles(0, math.pi, 0)
					elseif not east then
						-- we're done!
					else
						error("unreachable")
					end
				elseif numberAdjacent == 4 then
					tileName = "Empty"
				else
					error("unreachable")
				end

				assert(tileName ~= nil)
				assert(transform ~= nil)

				children[("(%d, %d)"):format(x, y)] = Roact.createElement(MapTile, {
					tileName = tileName,
					transform = transform,
				})
			end
		end
	end

	return Roact.createElement("Folder", nil, children)
end

return MapLayerComponent