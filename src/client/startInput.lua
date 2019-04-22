local UserInputService = game:GetService("UserInputService")

local function startInput(client)
	local connection = UserInputService.InputBegan:Connect(function(inputObject)
		local input

		if inputObject.UserInputType == Enum.UserInputType.Keyboard then
			if inputObject.KeyCode == Enum.KeyCode.Space then
				input = { type = "wait" }
			elseif inputObject.KeyCode == Enum.KeyCode.W then
				input = { type = "move", x = 0, y = 1 }
			elseif inputObject.KeyCode == Enum.KeyCode.S then
				input = { type = "move", x = 0, y = -1 }
			elseif inputObject.KeyCode == Enum.KeyCode.A then
				input = { type = "move", x = 1, y = 0 }
			elseif inputObject.KeyCode == Enum.KeyCode.D then
				input = { type = "move", x = -1, y = 0 }
			end
		end

		if input ~= nil then
			client:gameInput(input)
		end
	end)

	return function()
		connection:Disconnect()
	end
end

return startInput