local Models = require(script.Parent.Models)

local World = {}

function World.getTileSize()
	local empty = Models.get("BaseTile")
	local primaryPart = empty.PrimaryPart

	assert(primaryPart ~= nil, "Model 'BaseTile' did not have PrimaryPart")
	assert(primaryPart.Size.X == primaryPart.Size.Z, "Model 'BaseTile' did not have square floor")

	return primaryPart.Size.X
end

function World.tileToWorld(tilePosition)
	local tileSize = World.getTileSize()

	return Vector2.new((tilePosition.X - 1) * tileSize, (tilePosition.Y - 1) * tileSize)
end

function World.worldToTile(worldPosition)
	error("unimplemented")
end

return World