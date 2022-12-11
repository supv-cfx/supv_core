local type <const>, pairs <const>, getmetatable <const>, setmetatable <const> = type, pairs, getmetatable, setmetatable
local function Clone(table)
	if type(table) ~= 'table' then return end
	local metatable, target = getmetatable(table), {}

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

return {
    clone = Clone
}