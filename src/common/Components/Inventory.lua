local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = script.Parent.Parent
local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local ItemTypes = require(Common.ItemTypes)

local Inventory = Roact.Component:extend("Inventory")

function Inventory:render()
	local children = {
		["$ListLayout"] = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	}

	local itemList = {}
	for itemId, item in pairs(self.props.items) do
		table.insert(itemList, {itemId, item})
	end

	table.sort(itemList, function(a, b)
		local typeA = ItemTypes[a[2].type]
		local typeB = ItemTypes[b[2].type]

		return typeA.label < typeB.label
	end)

	for index, entry in ipairs(itemList) do
		local itemId = entry[1]
		local item = entry[2]

		local itemType = ItemTypes[item.type]
		local label = itemType.label

		if itemType.fungibleKey ~= nil then
			label = ("%s (x%d)"):format(itemType.label, item.count)
		end

		if item.equipped then
			label = label .. " 🛡️"
		end

		children[tostring(itemId)] = Roact.createElement("TextButton", {
			LayoutOrder = index,
			Size = UDim2.new(1, 0, 0, 30),
			Text = label,
			Font = Enum.Font.Gotham,
			TextSize = 24,
			BackgroundColor3 = Color3.fromRGB(16, 16, 16),
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
		})
	end

	local containerHeight = #itemList * 36

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 300, 1, 0),
		Position = UDim2.new(0, 8, 0, 8),
		BackgroundTransparency = 1,
	}, {
		Header = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 50),
			Text = "Inventory",
			Font = Enum.Font.GothamBold,
			TextSize = 40,
			BackgroundColor3 = Color3.fromRGB(64, 64, 64),
			BorderSizePixel = 0,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextXAlignment = Enum.TextXAlignment.Left,
		}),

		Items = Roact.createElement("ScrollingFrame", {
			Position = UDim2.new(0, 0, 0, 50),
			Size = UDim2.new(1, 0, 1, -50),
			CanvasSize = UDim2.new(1, 0, 0, containerHeight),
			BackgroundTransparency = 1,
		}, children),
	})
end

return Inventory