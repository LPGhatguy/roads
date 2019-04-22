local function makeStrict(inputName, input)
	return setmetatable(input, {
		__index = function(_, key)
			error(("%q is not a valid member of strict table %s"):format(tostring(key), inputName), 2)
		end,
		__newindex = function()
			error(("Cannot add new values to strict table %s"):format(inputName), 2)
		end,
	})
end

return makeStrict