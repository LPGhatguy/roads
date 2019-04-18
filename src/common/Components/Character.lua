local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local Models = require(Common.Models)
local World = require(Common.World)

local Character = Roact.Component:extend("Character")

function Character:init()
	self.ref = Roact.createRef()
end

function Character:render()
	return Roact.createElement("Folder", {
		[Roact.Ref] = self.ref,
	})
end

function Character:positionCharacter()
	local character = self.props.character
	local worldPos = World.tileToWorld(Vector2.new(character.position.X, character.position.Y))

	self.instance:SetPrimaryPartCFrame(CFrame.new(Vector3.new(worldPos.X, 0, worldPos.Y)))
end

function Character:didMount()
	self.instance = Models.get("Character"):Clone()
	self.instance.Parent = self.ref.current

	self:positionCharacter()
end

function Character:didUpdate()
	self:positionCharacter()
end

function Character:willUnmount()
	self.instance:Destroy()
end

return Character