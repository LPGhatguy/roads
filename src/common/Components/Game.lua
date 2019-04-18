local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local Camera = require(script.Parent.Camera)
local VisibleCharacters = require(script.Parent.VisibleCharacters)

local Game = Roact.Component:extend("Game")

function Game:render()
	return Roact.createFragment({
		Camera = Roact.createElement(Camera),

		Workspace = Roact.createElement(Roact.Portal, {
			target = Workspace,
		}, {
			Characters = Roact.createElement(VisibleCharacters),
		})
	})
end

return Game