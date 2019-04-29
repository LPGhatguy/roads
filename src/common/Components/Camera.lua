local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local World = require(Common.World)

local Camera = Roact.Component:extend("Camera")

function Camera:init()
	self.instance = Workspace.CurrentCamera

	assert(self.instance ~= nil, "Camera component had no CurrentCamera to connect to")
end

function Camera:render()
	return nil
end

function Camera:moveCamera()
	self.instance.CFrame = self.props.transform
end

function Camera:didMount()
	self:moveCamera()
end

function Camera:didUpdate()
	self:moveCamera()
end

Camera = RoactRodux.connect(
	function(state)
		local player = state.characters[state.playerCharacterId]
		local tilePosition = Vector2.new(player.position.X, player.position.Y)
		local worldPosition = World.tileToWorld(tilePosition)

		return {
			transform = CFrame.new(
				Vector3.new(worldPosition.X, 45, worldPosition.Y - 10),
				Vector3.new(worldPosition.X, 0, worldPosition.Y)
			)
		}
	end
)(Camera)

return Camera