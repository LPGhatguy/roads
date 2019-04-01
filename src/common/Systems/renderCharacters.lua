local Workspace = game:GetService("Workspace")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Common = ReplicatedFirst.Common

local World = require(Common.World)
local Models = require(Common.Models)

local function renderCharacters()
	local rootInstance = Instance.new("Model")
	rootInstance.Name = "Characters"
	rootInstance.Parent = Workspace

	local visibleCharacters = {}

	return function(state)
		for characterId, character in ipairs(state.characters) do
			local model = visibleCharacters[characterId]

			if model == nil then
				model = Models.get("Character"):Clone()
				model.Parent = rootInstance
				visibleCharacters[characterId] = model
			end

			local worldPos = World.tileToWorld(Vector2.new(character.position.X, character.position.Y))

			model:SetPrimaryPartCFrame(CFrame.new(Vector3.new(worldPos.X, 0, worldPos.Y)))
		end
	end
end

return renderCharacters