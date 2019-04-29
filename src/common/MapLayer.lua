local MapLayer = {}

function MapLayer.newEmpty(width, height)
	local tiles = {}

	for i = 1, width * height do
		tiles[i] = false
	end

	return {
		width = width,
		height = height,
		tiles = tiles,
	}
end

function MapLayer.TEMP_generate()
	local layer = MapLayer.newEmpty(64, 64)

	for x = 1, 8 do
		for y = 1, 8 do
			MapLayer.setTile(layer, x, y, true)
		end
	end

	MapLayer.setTile(layer, 9, 5, true)

	for x = 10, 14 do
		for y = 1, 10 do
			MapLayer.setTile(layer, x, y, true)
		end
	end

	return layer
end

function MapLayer:setTile(x, y, value)
	if x < 1 or x > self.width or y < 1 or y > self.height then
		error(("Position (%d, %d) out of map bounds"):format(x, y), 2)
	end

	self.tiles[x + self.height * (y - 1)] = true
end

function MapLayer:getTile(x, y)
	if x < 1 or x > self.width or y < 1 or y > self.height then
		return nil
	end

	return self.tiles[x + self.height * (y - 1)]
end

return MapLayer