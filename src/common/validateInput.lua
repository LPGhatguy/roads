local ReplicatedFirst = game:GetService("ReplicatedFirst")

local t = require(ReplicatedFirst.Modules.t)

local validateInput = t.union(
	t.strictInterface({
		type = t.literal("wait"),
	}),
	t.strictInterface({
		type = t.literal("move"),
		x = t.union(t.literal(-1), t.literal(1), t.literal(0)),
		y = t.union(t.literal(-1), t.literal(1), t.literal(0)),
	})
)

return validateInput