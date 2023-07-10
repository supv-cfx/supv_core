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

local function toVec3(coords)
    local _type <const> = type(coords)

    if _type ~= 'vector3' then
        if _type == 'table' or _type == 'vector4' then
            return vec3(coords[1] or coords.x, coords[2] or coords.y, coords[3] or coords.z)
        end

        error(("expected type 'vector3' or 'table' (received %s)"):format(_type))
    end

    return coords
end

---@param coords vector3|table
---@param heading? number
---@return vector4
local function toVec4(coords, heading)
	local _type <const> = type(coords)

	if _type ~= 'vector4' then
		if _type == 'table' or _type == 'vector3' then
			return vec4(coords[1] or coords.x, coords[2] or coords.y, coords[3] or coords.z, coords[4] or coords.w or coords.h or heading)
		end

		error(("expected type 'vector4' or 'table' (received %s)"):format(_type))
	end

	return coords
end

return {
    clone = Clone,
	contains = Contains
	toVec3 = toVec3,
	toVec4 = toVec4
}