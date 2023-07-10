local ESX <const> = exports["es_extended"]:getSharedObject()
local Framework = {}

function Framework.GetPlayerFromId(source)
    local player <const> = ESX.GetPlayerFromId(source)
    return player
end

function Framework.GetPlayerFromIdentifier(identifier)
    local player <const> = ESX.GetPlayerFromIdentifier(identifier)
    return player
end

function Framework.GetPlayers(key, value)
    local players <const> = ESX.GetExtendedPlayers(key, value)
    return players
end

function Framework.SetJob(player, job, grade)
    player.setJob(job, grade)
end

function Framework.SetGang(player, gang, grade)
    player.setFaction(gang, grade) -- or player.setJob2(gang, grade)
end

function Framework.GetJob(player)
    return player.getJob()
end

function Framework.GetGang(player)
    return player.getFaction() -- or player.getJob2()
end

function Framework.GetPlayerData(player) -- maybe useless
    return player
end

return Framework

--[[
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

function method.flush()
    return nil, collectgarbage()
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
]]