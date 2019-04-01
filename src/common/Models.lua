--[[
	The goal of this module is to try to centralize requests for models. It uses
	a server-generated "manifest" to try to distinguish between typo'd model
	names and actual replication issues.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Log = require(script.Parent.Log)

local modelStorage
local modelManifest
local modelCache = {}

local Models = {}

function Models.waitUntilLoaded()
	if modelStorage == nil then
		Log.trace("Waiting for model storage...")

		modelStorage = ReplicatedStorage:WaitForChild("Models", 10)

		if modelStorage == nil then
			error("ReplicatedStorage.Models did not exist.", 2)
		end
	end

	if modelManifest == nil then
		Log.trace("Waiting for model manifest...")

		local manifestValue = modelStorage:WaitForChild("Manifest", 10)

		if manifestValue == nil then
			error("ReplicatedStorage.Models.Manifest did not exist.", 2)
		end

		modelManifest = HttpService:JSONDecode(manifestValue.Value)
	end
end

--[[
	Can be called on the client or server to get a reference to a model by name.
]]
function Models.get(name)
	if modelCache[name] ~= nil then
		return modelCache[name]
	end

	Models.waitUntilLoaded()

	if not modelManifest[name] then
		error(("Invalid model name %q"):format(name), 2)
	end

	local instance = modelStorage:WaitForChild(name, 10)

	if instance == nil then
		error(("Model %q did not exist but was listed in the manifest."):format(name), 2)
	end

	modelCache[name] = instance

	return instance
end

function Models.WORKAROUND_fixPrimaryPart()
	if modelStorage == nil then
		modelStorage = ReplicatedStorage.Models
	end

	-- Hack to work around ref serialization not working in Rojo right now
	for _, model in ipairs(modelStorage:GetChildren()) do
		model.PrimaryPart = model:FindFirstChild("Floor")
	end
end

--[[
	Should be invoked on the server to help inform clients what models they
	should expect to be present in ReplicatedStorage.Models.
]]
function Models.createManifest()
	if modelStorage == nil then
		modelStorage = ReplicatedStorage.Models
	end

	local modelNames = {}
	for _, child in ipairs(modelStorage:GetChildren()) do
		modelNames[child.Name] = true
	end

	modelManifest = modelNames

	local manifest = Instance.new("StringValue")
	manifest.Name = "Manifest"
	manifest.Value = HttpService:JSONEncode(modelNames)
	manifest.Parent = modelStorage
end

return Models