local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Log = require(script.Parent.Log)

local t = require(ReplicatedFirst.Modules.t)

local Mutation = {}

Mutation.validate = t.union(
	t.strictInterface({
		type = t.literal("moveCharacter"),
		characterId = t.integer,
		newPosition = t.Vector3,
	})
)

function Mutation.process(state, mutation)
	assert(Mutation.validate(mutation))

	Log.trace("Mutation %s", mutation.type)

	if mutation.type == "moveCharacter" then
		local character = state.characters[mutation.characterId]

		if character == nil then
			Log.warn(("Couldn't move character ID %d: it did not exist."):format(mutation.characterId))
			return
		end

		character.position = mutation.newPosition
	end
end

return Mutation