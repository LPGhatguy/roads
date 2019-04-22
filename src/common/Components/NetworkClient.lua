local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)

local contextSymbol = setmetatable({}, {
	__tostring = function()
		return "Symbol(NetworkClient)"
	end,
})

local Provider = Roact.Component:extend("NetworkClientProvider")

function Provider:init()
	assert(self.props.networkClient ~= nil, "Please pass a networkClient prop to NetworkClientProvider")

	self._context[contextSymbol] = self.props.networkClient
end

function Provider:render()
	return Roact.createFragment(self.props[Roact.Children])
end

local Consumer = Roact.Component:extend("NetworkClientConsumer")

function Consumer:init()
	self.networkClient = self._context[contextSymbol]

	if self.networkClient == nil then
		error("NetworkClientConsumer needs a NetworkClientProvider above it in the tree")
	end
end

function Consumer:render()
	return self.props.render(self.networkClient)
end

local function with(render)
	return Roact.createElement(Consumer, {
		render = render,
	})
end

return {
	Provider = Provider,
	Consumer = Consumer,
	with = with,
}