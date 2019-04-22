local RunService = game:GetService("RunService")

local display = require(script.Parent.display)

local LogLevel = {
	Trace = 3,
	Info = 2,
	Warn = 1,
}

local CURRENT_LOG_LEVEL = LogLevel.Warn

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

local function betterFormat(template, ...)
	local values = {...}
	local matchCount = 0

	local result = template:gsub("{([^}]*)}", function(args)
		matchCount = matchCount + 1
		local value = values[matchCount]

		if args == ":?" then
			return display(value)
		elseif args == "" then
			return tostring(value)
		else
			error(("Invalid format string %q"):format(args))
		end
	end)

	return result
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
			if CURRENT_LOG_LEVEL < LogLevel.Trace then
				return
			end

			local message = betterFormat(template, ...)
			print(tracePrefix .. indentNonWarning(message))
		end,
		info = function(template, ...)
			if CURRENT_LOG_LEVEL < LogLevel.Info then
				return
			end

			local message = betterFormat(template, ...)
			print(infoPrefix .. indentNonWarning(message))
		end,
		warn = function(template, ...)
			if CURRENT_LOG_LEVEL < LogLevel.Warn then
				return
			end

			local message = betterFormat(template, ...)
			warn(warnPrefix .. indentWarning(message))
		end,
	}
end

return createLogger