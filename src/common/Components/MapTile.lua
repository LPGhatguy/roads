local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local Models = require(Common.Models)
local World = require(Common.World)

local function createTile(tileName)
	local model = Models.get(tileName):Clone()
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
	self.instances = {}

	local occupancy = self.props.occupancy
	local position = self.props.position

	local worldPos = World.tileToWorld(position)
	local baseTransform = CFrame.new(Vector3.new(worldPos.X, 0, worldPos.Y))

	if occupancy.self then
		local tile = createTile("BaseTile")
		tile:SetPrimaryPartCFrame(baseTransform)
		tile.Parent = self.ref.current
	else
		if occupancy.east then
			local wall = createTile("ExteriorWall")
			wall:SetPrimaryPartCFrame(baseTransform)
			wall.Parent = self.ref.current
		end

		if occupancy.west then
			local wall = createTile("ExteriorWall")
			wall:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, math.pi, 0))
			wall.Parent = self.ref.current
		end

		if occupancy.north then
			local wall = createTile("ExteriorWall")
			wall:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, -math.pi / 2, 0))
			wall.Parent = self.ref.current
		end

		if occupancy.south then
			local wall = createTile("ExteriorWall")
			wall:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, math.pi / 2, 0))
			wall.Parent = self.ref.current
		end

		if occupancy.northEast then
			local post = createTile("ExteriorPost")
			post:SetPrimaryPartCFrame(baseTransform)
			post.Parent = self.ref.current
		end

		if occupancy.southEast then
			local post = createTile("ExteriorPost")
			post:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, math.pi / 2, 0))
			post.Parent = self.ref.current
		end

		if occupancy.southWest then
			local post = createTile("ExteriorPost")
			post:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, math.pi, 0))
			post.Parent = self.ref.current
		end

		if occupancy.northWest then
			local post = createTile("ExteriorPost")
			post:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, -math.pi / 2, 0))
			post.Parent = self.ref.current
		end
	end

	self:calculateInitialColors()
	self:updateLighting()
end

function MapTile:calculateInitialColors()
	self.initialPartColors = {}
	for _, instance in ipairs(self.ref.current:GetDescendants()) do
		if instance:IsA("BasePart") then
			self.initialPartColors[instance] = instance.Color
		end
	end
end

function MapTile:updateLighting()
	for _, instance in ipairs(self.ref.current:GetDescendants()) do
		if instance:IsA("BasePart") then
			local baseColor = self.initialPartColors[instance]
			local h, s, v = Color3.toHSV(baseColor)
			v = v * self.props.lighting
			instance.Color = Color3.fromHSV(h, s, v)
		end
	end
end

function MapTile:didUpdate(oldProps)
	if self.props.lighting ~= oldProps.lighting then
		self:updateLighting()
	end
end

return MapTile