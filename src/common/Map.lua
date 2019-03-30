local Models = require(script.Parent.Models)

local Map = {}
Map.__index = Map

function Map.newEmpty(width, height)
	local tiles = {}

	for i = 1, width * height do
		tiles[i] = false
	end

	return setmetatable({
		width = width,
		height = height,
		tiles = tiles,
	}, Map)
end

function Map:getTileSize()
	local empty = Models.get("Empty")
	local primaryPart = empty.PrimaryPart

	assert(primaryPart ~= nil, "Model 'Empty' did not have PrimaryPart")
	assert(primaryPart.Size.X == primaryPart.Size.Z, "Model 'Empty' did not have square floor")

	return primaryPart.Size.X
end

function Map:setTile(x, y, value)
	if x < 1 or x > self.width or y < 1 or y > self.height then
		error(("Position (%d, %d) out of map bounds"):format(x, y), 2)
	end

	self.tiles[x + self.height * (y - 1)] = true
end

function Map:getTile(x, y)
	if x < 1 or x > self.width or y < 1 or y > self.height then
		return nil
	end

	return self.tiles[x + self.height * (y - 1)]
end

function Map:construct()
	local rootInstance = Instance.new("Folder")
	rootInstance.Name = "Constructed Map"

	local tileSize = self:getTileSize()

	local empty = Models.get("Empty")
	local corner = Models.get("Corner")
	local hall = Models.get("Hall")
	local wall = Models.get("Wall")

	for x = 1, self.width do
		for y = 1, self.height do
			local tile = self:getTile(x, y)

			if tile then
				local position = Vector3.new((x - 1) * tileSize, 0, (y - 1) * tileSize)

				local north = self:getTile(x, y + 1)
				local south = self:getTile(x, y - 1)
				local west = self:getTile(x - 1, y)
				local east = self:getTile(x + 1, y)

				local instance
				local transform = CFrame.new(position)

				-- I wish I had ML-style pattern matching here

				local numberAdjacent = 0
					+ (north and 1 or 0)
					+ (south and 1 or 0)
					+ (west and 1 or 0)
					+ (east and 1 or 0)

				if numberAdjacent == 0 then
					instance = empty:Clone()
				elseif numberAdjacent == 1 then
					instance = empty:Clone()
				elseif numberAdjacent == 2 then
					if (north and south) or (west and east) then
						instance = hall:Clone()

						if west then
							transform = transform * CFrame.Angles(0, math.pi / 2, 0)
						end
					else
						instance = corner:Clone()

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
					instance = wall:clone()

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
					instance = empty:Clone()
				else
					error("unreachable")
				end

				assert(instance ~= nil)
				assert(transform ~= nil)

				instance.Name = ("(%d, %d)"):format(x, y)
				instance:SetPrimaryPartCFrame(transform)
				instance.Parent = rootInstance
			end
		end
	end

	return rootInstance
end

return Map