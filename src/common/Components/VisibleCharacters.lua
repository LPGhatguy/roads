local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local Character = require(script.Parent.Character)

local VisibleCharacters = Roact.Component:extend("VisibleCharacters")

function VisibleCharacters:render()
	local children = {}

	for characterId, character in ipairs(self.props.characters) do
		children[tostring(characterId)] = Roact.createElement(Character, {
			character = character,
		})
	end

	return Roact.createElement("Folder", nil, children)
end

VisibleCharacters = RoactRodux.connect(
	function(state)
		return {
			characters = state.characters,
		}
	end
)(VisibleCharacters)

return VisibleCharacters