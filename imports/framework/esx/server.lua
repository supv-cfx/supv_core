local ESX = exports['es_extended']:getSharedObject()
local player, method = {}, {}

function method.getGang(obj)
    if not obj.faction then return end
    return obj.getFaction()
end

function method.setGang(obj, key, value)
    if not obj.faction then return end
    obj.setFaction(key, value)
end

function player:__index(index)
    local value = method[index]
    
    if index == 'gang' then
        return self?.faction
    end

    if value then
        return function(...)
            return value(self, ...)
        end
    end

    return self[index]
end

local function GetPlayerFromId(source)
    local p = ESX.GetPlayerFromId(source)
    return p and setmetatable(p, player)
end

return {
    GetPlayerFromId = GetPlayerFromId
}