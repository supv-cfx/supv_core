local kvp = {}

---@param key string
---@param value any
function kvp.set(key, value)
    if type(key) ~= 'string' then return end
    if type(value) ~= 'string' then 
        value = type(value) == 'table' and json.encode(value) or tostring(value)
    end

    SetResourceKvp(key, value)
end

---@param key any
---@return string?
function kvp.get(key)
    if type(key) ~= 'string' then return end

    local str <const> = GetResourceKvpString(key)
    if str:find('^%s*%{.*%}%s*$') then
        return json.decode(str)
    end

    return str
end

return kvp