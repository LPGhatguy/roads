local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local Models = require(Common.Models)
local World = require(Common.World)

local function createTile(name)
	return Models.get(name):Clone()
end

local MapTileWall = Roact.Component:extend("MapTileWall")

function MapTileWall:init()
	self.ref = Roact.createRef()
end

function MapTileWall:render()
	return Roact.createElement("Folder", {
		[Roact.Ref] = self.ref,
	})
end

function MapTileWall:didMount()
	local walls = self.props.walls
	local posts = self.props.posts
	local position = self.props.position

	local worldPos = World.tileToWorld(position)
	local baseTransform = CFrame.new(Vector3.new(worldPos.X, 0, worldPos.Y))

	if walls.east then
		local wall = createTile("ExteriorWall")
		wall:SetPrimaryPartCFrame(baseTransform)
		wall.Parent = self.ref.current
	end

	if walls.west then
		local wall = createTile("ExteriorWall")
		wall:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, math.pi, 0))
		wall.Parent = self.ref.current
	end

	if walls.north then
		local wall = createTile("ExteriorWall")
		wall:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, -math.pi / 2, 0))
		wall.Parent = self.ref.current
	end

	if walls.south then
		local wall = createTile("ExteriorWall")
		wall:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, math.pi / 2, 0))
		wall.Parent = self.ref.current
	end

	if posts.northEast then
		local post = createTile("ExteriorPost")
		post:SetPrimaryPartCFrame(baseTransform)
		post.Parent = self.ref.current
	end

	if posts.southEast then
		local post = createTile("ExteriorPost")
		post:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, math.pi / 2, 0))
		post.Parent = self.ref.current
	end

	if posts.southWest then
		local post = createTile("ExteriorPost")
		post:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, math.pi, 0))
		post.Parent = self.ref.current
	end

	if posts.northWest then
		local post = createTile("ExteriorPost")
		post:SetPrimaryPartCFrame(baseTransform * CFrame.Angles(0, -math.pi / 2, 0))
		post.Parent = self.ref.current
	end
end

return MapTileWall