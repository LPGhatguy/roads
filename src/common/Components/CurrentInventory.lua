local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local Inventory = require(script.Parent.Inventory)

local CurrentInventory = Roact.Component:extend("CurrentInventory")

function CurrentInventory:render()
	return Roact.createElement(Inventory, {
		items = self.props.items
	})
end

CurrentInventory = RoactRodux.connect(
	function(state)
		return {
			items = state.characterInventories[1],
		}
	end
)(CurrentInventory)

return CurrentInventory