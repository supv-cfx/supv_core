local type <const>, pairs <const>, getmetatable <const>, setmetatable <const> = type, pairs, getmetatable, setmetatable

--- supv.table.clone - Clone a table
---@param t table
---@return table
local function Clone(t)
	if type(t) ~= 'table' then return end
	local metatable, target = getmetatable(t), {}

	for k,v in pairs(metatable) do
		if type(v) == 'table' then
			target[k] = Clone(v)
		else
			target[k] = v
		end
	end

	setmetatable(target, metatable)

	return target
end

--- supv.table.contains - Check if a table contains a value
---@param t table
---@param value any
---@return boolean
local function Contains(t, value)
	for _, v in pairs(t)do
		if v == value then return true end
	end
	return false
end

return {
    clone = Clone,
	contains = Contains
}