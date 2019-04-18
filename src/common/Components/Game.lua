local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local Camera = require(script.Parent.Camera)

local Game = Roact.Component:extend("Game")

function Game:render()
	return Roact.createElement(Camera)
end

return Game