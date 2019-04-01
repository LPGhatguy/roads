local Workspace = game:GetService("Workspace")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Common = ReplicatedFirst.Common

local MapLayer = require(Common.MapLayer)
local World = require(Common.World)
local Models = require(Common.Models)

local function createTile(name)
	local model = Models.get(name):Clone()
	local floor = model.PrimaryPart

	local box = Instance.new("SelectionBox")
	box.Color3 = Color3.fromRGB(32, 32, 32)
	box.SurfaceColor3 = Color3.fromRGB(255, 255, 255)
	box.Adornee = floor
	box.LineThickness = 0.03
	box.Parent = floor

	return model
end

local function renderMapLayer(mapLayer)
	local rootInstance = Instance.new("Folder")
	rootInstance.Name = "Map Layer"

	for x = 1, mapLayer.width do
		for y = 1, mapLayer.height do
			local tile = MapLayer.getTile(mapLayer, x, y)

			if tile then
				local worldPos = World.tileToWorld(Vector2.new(x, y))

				local north = MapLayer.getTile(mapLayer, x, y + 1)
				local south = MapLayer.getTile(mapLayer, x, y - 1)
				local west = MapLayer.getTile(mapLayer, x - 1, y)
				local east = MapLayer.getTile(mapLayer, x + 1, y)

				local instance
				local transform = CFrame.new(Vector3.new(worldPos.X, 0, worldPos.Y))

				-- I wish I had ML-style pattern matching here

				local numberAdjacent = 0
					+ (north and 1 or 0)
					+ (south and 1 or 0)
					+ (west and 1 or 0)
					+ (east and 1 or 0)

				if numberAdjacent == 0 then
					instance = createTile("Empty")
				elseif numberAdjacent == 1 then
					instance = createTile("Empty")
				elseif numberAdjacent == 2 then
					if (north and south) or (west and east) then
						instance = createTile("Hall")

						if west then
							transform = transform * CFrame.Angles(0, math.pi / 2, 0)
						end
					else
						instance = createTile("Corner")

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
					instance = createTile("Wall")

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
					instance = createTile("Empty")
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

local function renderGame()
	local rootInstance = Instance.new("Model")
	rootInstance.Name = "Map"
	rootInstance.Parent = Workspace

	local currentMapLayer

	return function(state)
		if currentMapLayer == nil then
			currentMapLayer = renderMapLayer(state.mapLayers[1])
			currentMapLayer.Parent = rootInstance
		end
	end
end

return renderGame