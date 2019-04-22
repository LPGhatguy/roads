local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(script.Parent.Log)

local ApiSpec = require(ReplicatedStorage.Common.ApiSpec)

local ServerApi = {}

ServerApi.AllPlayers = newproxy(true)

getmetatable(ServerApi.AllPlayers).__tostring = function()
	return "Symbol(AllPlayers)"
end

function ServerApi:__index(key)
	error(("%q is not a valid member of ServerApi"):format(tostring(key)), 2)
end

function ServerApi.create(handlers)
	assert(typeof(handlers) == "table")

	local self = {}

	setmetatable(self, ServerApi)

	local remotes = Instance.new("Folder")
	remotes.Name = "Events"

	for name, endpoint in pairs(ApiSpec.fromClient) do
		local remote = Instance.new("RemoteEvent")
		remote.Name = "fromClient-" .. name
		remote.Parent = remotes

		local handler = handlers[name]

		if handler == nil then
			error(("Need to implement server handler for %q"):format(name), 2)
		end

		remote.OnServerEvent:Connect(function(player, ...)
			assert(typeof(player) == "Instance" and player:IsA("Player"))
			assert(endpoint.arguments(...))

			Log.trace("Receiving event {:?} from player {}", name, player.Name)

			handler(player, ...)
		end)
	end

	for name, endpoint in pairs(ApiSpec.fromServer) do
		local remote = Instance.new("RemoteEvent")
		remote.Name = "fromServer-" .. name
		remote.Parent = remotes

		self[name] = function(_, player, ...)
			if player == ServerApi.AllPlayers then
				assert(endpoint.arguments(...))

				Log.trace("Firing event {:?} for all players", name)

				remote:FireAllClients(...)
			else
				assert(typeof(player) == "Instance" and player:IsA("Player"), "Missing player argument")
				assert(endpoint.arguments(...))

				Log.trace("Firing event {:?} for player {}", name, player.Name)

				remote:FireClient(player, ...)
			end
		end
	end

	remotes.Parent = ReplicatedStorage

	Log.info("ServerApi connected")

	return self
end

return ServerApi