local QBCore = exports["qb-core"]:GetCoreObject()
local player, method = {}, {}

function method.getGang(obj)
    return obj.PlayerData.gang
end

function method.setGang(obj, key, value)
    obj.Functions.SetGang(key, value)
end

function method.getJob(obj)
    return obj.PlayerData.job
end

function method.setJob(obj, key, value)
    obj.Functions.SetJob(key, value)
end

function method.flush()
    return nil, collectgarbage()
end

function player:__index(index)
    local value = method[index]

    if value then
        return function(...)
            return value(self, ...)
        end
    end

    return self[index]
end

local function GetPlayerFromId(source)
    local p = QBCore.Functions.GetPlayer(source)
    return p and setmetatable(p, player)
end

return {
    GetPlayerFromId = GetPlayerFromId
}