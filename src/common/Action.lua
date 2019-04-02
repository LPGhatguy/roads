local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.Modules.t)

local Action = {}

Action.validate = t.union(
	t.strictInterface({
		type = t.literal("moveCharacter"),
		characterId = t.integer,
		newPosition = t.Vector3,
	})
)

return Action