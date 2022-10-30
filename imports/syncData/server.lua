--- syncData.set
---
---@param key string
---@param value any
local function Set(key, value)
    return TriggerEvent('supv_core:server:insert:data', key, value)
end

--- syncData.remove
---
---@param key string
---@param value any
local function Remove(key, value)
    return TriggerEvent('supv_core:server:remove:data', key, value)
end

--- syncData.get
---
---@param key string
---@return any
local function Get(key, value)
    local data = {}
    TriggerEvent('supv_core:client:get:data', function(sdata)
        data = sdata
    end)
    if value and type(data[key]) == 'table' then
        for i,v in ipairs(data[key]) do
            if v == value then
                return data[key][i]
            end
        end
        return false
    elseif not value then
        return data[key]
    else
        return nil
    end
end

return {
    set = Set,
    get = Get,
    remove = Remove
}