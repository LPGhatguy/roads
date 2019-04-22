local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.Modules.t)

local makeStrict = require(script.Parent.makeStrict)

local Action = {}

local function addAction(name, fields)
	fields.type = t.literal(name)

	Action[name] = makeStrict(name, {
		validate = t.strictInterface(fields),
		name = name,
	})
end

addAction("moveCharacter", {
	characterId = t.integer,
	newPosition = t.Vector3,
})

local validators = {}
for _, action in pairs(Action) do
	table.insert(validators, action.validate)
end

Action.validate = t.union(unpack(validators))

makeStrict("Action", Action)

return Action