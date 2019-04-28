local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local Models = require(Common.Models)
local World = require(Common.World)

local function createTile()
	local model = Models.get("BaseTile"):Clone()
	local floor = model.PrimaryPart

	local box = Instance.new("SelectionBox")
	box.Color3 = Color3.fromRGB(32, 32, 32)
	box.SurfaceColor3 = Color3.fromRGB(255, 255, 255)
	box.Adornee = floor
	box.LineThickness = 0.03
	box.Parent = floor

	return model
end

local MapTile = Roact.Component:extend("MapTile")

function MapTile:init()
	self.ref = Roact.createRef()
end

function MapTile:render()
	return Roact.createElement("Folder", {
		[Roact.Ref] = self.ref,
	})
end

function MapTile:didMount()
	self.tile = createTile()
	self.tile.Parent = self.ref.current

	self:positionMapTile()
end

function MapTile:didUpdate(oldProps)
	self:positionMapTile()
end

function MapTile:willUnmount()
	self.tile:Destroy()
end

function MapTile:positionMapTile()
	local worldPos = World.tileToWorld(self.props.position)
	self.tile:SetPrimaryPartCFrame(CFrame.new(Vector3.new(worldPos.X, 0, worldPos.Y)))
end

return MapTile