local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local keysDown = {}

UserInputService.InputBegan:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.Keyboard then
		keysDown[inputObject.KeyCode] = true
	end
end)

UserInputService.InputEnded:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.Keyboard then
		keysDown[inputObject.KeyCode] = false
	end
end)

RunService.Stepped:Connect(function()
	local camera = Workspace.CurrentCamera

	if camera == nil then
		warn("Skipping frame, camera is nil")
		return
	end

	local character = localPlayer.Character

	if character == nil then
		warn("Skipping update, character is nil")
		return
	end

	local humanoid = character.Humanoid
	local rootPart = humanoid.RootPart

	camera.CFrame = CFrame.new(
		Vector3.new(rootPart.Position.X, 30, rootPart.Position.Z - 15),
		Vector3.new(rootPart.Position.X, 2, rootPart.Position.Z)
	)

	local moveDirection = Vector3.new()

	if keysDown[Enum.KeyCode.W] then
		moveDirection = moveDirection + Vector3.new(0, 0, 1)
	end

	if keysDown[Enum.KeyCode.S] then
		moveDirection = moveDirection - Vector3.new(0, 0, 1)
	end

	if keysDown[Enum.KeyCode.A] then
		moveDirection = moveDirection + Vector3.new(1, 0, 0)
	end

	if keysDown[Enum.KeyCode.D] then
		moveDirection = moveDirection - Vector3.new(1, 0, 0)
	end

	humanoid:Move(moveDirection, false)
end)