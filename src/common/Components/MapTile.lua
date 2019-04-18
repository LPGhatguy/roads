local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

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

local MapTile = Roact.Component:extend("MapTile")

function MapTile:init()
	self.ref = Roact.createRef()
end

function MapTile:render()
	return Roact.createElement("Folder", {
		[Roact.Ref] = self.ref,
	})
end

function MapTile:positionMapTile()
	self.instance:SetPrimaryPartCFrame(self.props.transform)
end

function MapTile:didMount()
	self.instance = createTile(self.props.tileName)
	self.instance.Parent = self.ref.current

	self:positionMapTile()
end

function MapTile:didUpdate()
	-- TODO: Update instance if tileName changed
	self:positionMapTile()
end

function MapTile:willUnmount()
	self.instance:Destroy()
end

return MapTile