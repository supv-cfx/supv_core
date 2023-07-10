local ESX <const> = exports["es_extended"]:getSharedObject()
local Player, method = {}, {}

function Player:__index(index)
    local value = method[index]
    
    if value then
        return function(...)
            return value(self, ...)
        end
    end

    return self[index]
end

function method.GetGang(player)
    return player.getFaction()
end

function method.SetGang(player, key, value)
    player.setFaction(key, value)
end

function method.GetJob(player)
    return player.getJob()
end

function method.SetJob(player, key, value)
    player.setJob(key, value)
end

function method.Flush()
    return nil, collectgarbage()
end

local function GetPlayerFromId(source)
    local player = ESX.GetPlayerFromId(source)
    return player and setmetatable(player, Player)
end

return {
    GetPlayerFromId = GetPlayerFromId
}