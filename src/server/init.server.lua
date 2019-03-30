local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Common = ReplicatedStorage.Common
local modelStorage = ReplicatedStorage.Models

local Models = require(Common.Models)
local Map = require(Common.Map)

-- Hack to work around ref serialization not working in Rojo right now
for _, model in ipairs(modelStorage:GetChildren()) do
	model.PrimaryPart = model:FindFirstChild("Floor")
end

Models.createManifest()

local map = Map.newEmpty(32, 32)

for x = 1, 5 do
	for y = 1, 5 do
		map:setTile(x, y, true)
	end
end

for y = 6, 10 do
	map:setTile(3, y, true)
end

local instance = map:construct()
instance.Parent = Workspace