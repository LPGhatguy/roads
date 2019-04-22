local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local Camera = require(script.Parent.Camera)
local Input = require(script.Parent.Input)
local VisibleCharacters = require(script.Parent.VisibleCharacters)
local CurrentMapLayer = require(script.Parent.CurrentMapLayer)

local Game = Roact.Component:extend("Game")

function Game:render()
	return Roact.createFragment({
		Input = Roact.createElement(Input),
		Camera = Roact.createElement(Camera),

		Workspace = Roact.createElement(Roact.Portal, {
			target = Workspace,
		}, {
			Characters = Roact.createElement(VisibleCharacters),
			Map = Roact.createElement(CurrentMapLayer),
		})
	})
end

return Game