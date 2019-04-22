local ItemTypes = require(script.Parent.Parent.ItemTypes)

local function characterInventories(state, action)
	if state == nil then
		state = {
			[1] = {
				Currency = {
					type = "Currency",
					count = 50,
				},
				["f7b53d01-0449-40d5-82be-fca77e1ec9d4"] = {
					type = "Longsword",
					status = "Cursed",
					equipped = true,
				},
				["2a6d3fc7-ec10-4935-b798-ec1da52b524f"] = {
					type = "WoodenRoundShield",
					status = "Blessed",
				}
			},
		}
	end

	return state
end

return characterInventories