local QBCore <const> = exports["qb-core"]:GetCoreObject()
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
    return player.PlayerData.gang
end

function method.SetGang(player, key, value)
    player.Functions.SetGang(key, value)
end

function method.GetJob(player)
    return player.PlayerData.job
end

function method.SetJob(player, key, value)
    player.Functions.SetJob(key, value)
end

function method.Flush()
    return nil, collectgarbage()
end

local function GetPlayerFromId(source)
    local player = QBCore.Functions.GetPlayer(source)
    return player and setmetatable(player, Player)
end

return {
    GetPlayerFromId = GetPlayerFromId
}

--[[
local Framework = {}

function Framework.GetPlayerFromdId(source)
    local player <const> = QBCore.Functions.GetPlayer(source)
    return player
end

function Framework.GetPlayers(key, value)
    local players <const> = QBCore.Functions.GetQBPlayers()
    if key and value then
        local filter = {}
        for _, v in pairs(players)
            if v.PlayerData[key] == value then
                filter[#filter + 1] = v
            end
        end
        return filter
    end
    return players
end

function Framework.GetPlayerData(player)
    return player.PlayerData
end

function Framework.GetJob(player)
    return player.PlayerData.job
end

function Framework.GetGang(player)
    return player.PlayerData.gang
end

function Framework.SetJob(player, job, grade)
    player.Functions.SetJob(job, grade)
end

function Framework.SetGang(player, gang, grade)
    player.Functions.SetGang(gang, grade)
end

return Framework
--]]
--[[
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

]]