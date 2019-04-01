--[[
	This object's job is to read the common ApiSpec, which defines the protocol
	for communicating with the server and the types that each method accepts.

	On connecting to the server via `connect`, we generate an object that has
	a method for each RemoteEvent that attached validation on both ends.

	I've found that this is a super nice way to think about network
	communication in Roblox, since it lines up with other strongly-typed RPC
	systems.
]]

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(script.Parent.Log)

local ApiSpec = require(ReplicatedFirst.Common.ApiSpec)

local ClientApi = {}

function ClientApi:__index(key)
	error(("%q is not a valid member of ClientApi"):format(tostring(key)), 2)
end

function ClientApi.connect(handlers)
	assert(typeof(handlers) == "table")

	local self = {}

	setmetatable(self, ClientApi)

	local remotes = ReplicatedStorage:WaitForChild("Events")

	for name, endpoint in pairs(ApiSpec.fromClient) do
		local remote = remotes:WaitForChild("fromClient-" .. name)

		self[name] = function(_, ...)
			Log.trace(("Firing event %q"):format(name))

			assert(endpoint.arguments(...))

			remote:FireServer(...)
		end
	end

	for name, endpoint in pairs(ApiSpec.fromServer) do
		local remote = remotes:WaitForChild("fromServer-" .. name)

		local handler = handlers[name]

		if handler == nil then
			error(("Need to implement client handler for %q"):format(name), 2)
		end

		remote.OnClientEvent:Connect(function(...)
			Log.trace(("Received event %q"):format(name))

			assert(endpoint.arguments(...))

			handler(...)
		end)
	end

	Log.info("ClientApi connected")

	return self
end

return ClientApi