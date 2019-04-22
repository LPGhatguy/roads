local RunService = game:GetService("RunService")

local isServer = RunService:IsServer()
local isClient = RunService:IsClient()

local NON_WARN_INDENT = "               " -- Width of warning timestamp
local EXTRA_LINE_INDENT = "                 " -- Width of line prefix

local function indentNonWarning(message)
	return message:gsub("\n", "\n" .. NON_WARN_INDENT .. EXTRA_LINE_INDENT)
end

local function indentWarning(message)
	return message:gsub("\n", "\n" .. EXTRA_LINE_INDENT)
end

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

	local tracePrefix = ("%s[%s] [trace] "):format(NON_WARN_INDENT, label)
	local infoPrefix =  ("%s[%s] [info ] "):format(NON_WARN_INDENT, label)
	local warnPrefix =    ("[%s] [warn ] "):format(label)

	return {
		trace = function(template, ...)
			local message = string.format(template, ...)
			print(tracePrefix .. indentNonWarning(message))
		end,
		info = function(template, ...)
			local message = string.format(template, ...)
			print(infoPrefix .. indentNonWarning(message))
		end,
		warn = function(template, ...)
			local message = string.format(template, ...)
			warn(warnPrefix .. indentWarning(message))
		end,
	}
end

return createLogger