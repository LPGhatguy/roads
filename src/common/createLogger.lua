local RunService = game:GetService("RunService")

local isServer = RunService:IsServer()
local isClient = RunService:IsClient()

local function createLogger(scope)
	local label

	if scope == "client" then
		label = "CLIENT"
	elseif scope == "server" then
		label = "SERVER"
	elseif scope == "common" then
		if not isServer then
			label = "CLIENT"
		elseif not isClient then
			label = "SERVER"
		else
			label = "PLYSOL"
		end
	else
		error("Invalid createLogger scope")
	end

	local tracePrefix = ("               [%s] [trace] "):format(label)
	local infoPrefix =  ("               [%s] [info ] "):format(label)
	local warnPrefix =  ("[%s] [warn ] "):format(label)

	return {
		trace = function(template, ...)
			local message = string.format(template, ...)
			print(tracePrefix .. message)
		end,
		info = function(template, ...)
			local message = string.format(template, ...)
			print(infoPrefix .. message)
		end,
		warn = function(template, ...)
			local message = string.format(template, ...)
			warn(warnPrefix .. message)
		end,
	}
end

return createLogger