local None = setmetatable({}, {
	__tostring = function()
		return "None"
	end,
})

local function assign(target, ...)
	for i = 1, select("#", ...) do
		local source = select(i, ...)

		for key, value in pairs(source) do
			if value ~= None then
				target[key] = value
			end
		end
	end

	return target
end

local function join(...)
	return assign({}, ...)
end

return {
	None = None,
	assign = assign,
	join = join,
}