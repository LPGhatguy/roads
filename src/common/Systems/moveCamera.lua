local Workspace = game:GetService("Workspace")

local World = require(script.Parent.Parent.World)

local function moveCamera()
	local camera = Workspace.CurrentCamera

	return function(state)
		local player = state.characters[state.playerCharacterId]
		local tilePosition = Vector2.new(player.position.X, player.position.Y)
		local worldPosition = World.tileToWorld(tilePosition)

		camera.CFrame = CFrame.new(
			Vector3.new(worldPosition.X, 40, worldPosition.Y - 10),
			Vector3.new(worldPosition.X, 0, worldPosition.Y)
		)
	end
end

return moveCamera