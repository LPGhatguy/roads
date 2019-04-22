local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local NetworkClient = require(script.Parent.NetworkClient)

local InputInner = Roact.Component:extend("InputInner")

function InputInner:render()
	return nil
end

function InputInner:didMount()
	self.connection = UserInputService.InputBegan:Connect(function(inputObject)
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
			self.props.networkClient:gameInput(input)
		end
	end)
end

function InputInner:willUnmount()
	self.self.connection:Disconnect()
end

local function Input()
	return NetworkClient.with(function(networkClient)
		return Roact.createElement(InputInner, {
			networkClient = networkClient,
		})
	end)
end

return Input