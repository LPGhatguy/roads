local function indent(str)
	return str:gsub("\n", "\n" .. "    ")
end

local display

local function displayDefaultTable(dictionary)
	local buffer = {"{"}

	for key, value in pairs(dictionary) do
		local displayKey = display(key)
		local displayValue = indent(display(value))
		local pair = ("    [%s] = %s,"):format(displayKey, displayValue)
		table.insert(buffer, pair)
	end

	table.insert(buffer, "}")

	return table.concat(buffer, "\n")
end

function display(value, indentLevel)
	local valueType = type(value)

	if valueType == "string" then
		return string.format("%q", value)
	elseif valueType == "table" then
		local meta = getmetatable(value)

		if meta ~= nil and meta.__tostring ~= nil then
			return tostring(value)
		end

		return displayDefaultTable(value, 0)
	else
		return tostring(value)
	end
end

return display