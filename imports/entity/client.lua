local GetGamePool <const> = GetGamePool
local GetEntityCoords <const> = GetEntityCoords
local GetEntityModel <const> = GetEntityModel
local GetPedType <const> = GetPedType
local GetActivePlayers <const> = GetActivePlayers
local GetPlayerPed <const> = GetPlayerPed 
local DoesEntityExist <const> = DoesEntityExist
--- entity.getVehicles
---
---@return array
local function GetVehicles()
    return GetGamePool('CVehicle')
end
--- entity.getObjects
---
---@return array
local function GetObjects()
    return GetGamePool('CObject')
end
--- entity.getAllPedsAndPlayers
---
---@return array
local function GetAllPedsAndPlayers()
    return GetGamePool('CPed')
end
--- entity.getPickups
---
---@return array
local function GetPickups()
    return GetGamePool('CPickup')
end
--- entity.getClosestEntity
---
---@param entities table
---@param playerEntities boolean
---@param coords vec3|table|nil
---@param filter table
---@return number,integer
local function GetClosestEntity(entities, playerEntities, coords, filter)
    local closestEntity, closestEntityDistance, filtered, distance = -1, -1, nil

    if coords then
        coords = vec3(coords.x, coords.y, coords.z)
    else
        coords = supv.oncache.coords or GetEntityCoords(PlayerPedId())
    end

    if filter then
        filtered = {}

        for _,v in pairs(entities)do
            if filter[GetEntityModel(v)] then
                filtered[#filtered+1] = v
            end
        end
    end

    for k,v in pairs(filtered or entities) do
        distance = #(coords - GetEntityCoords(v))
        if (closestEntityDistance == -1) or distance < closestEntityDistance then
            closestEntity, closestEntityDistance = playerEntities and k or v, distance
        end
    end

    return closestEntity, closestEntityDistance
end
--- entity.getPeds
---
---@param filter table
---@return table
local function GetPeds(filter)
    local peds, player, pool, filtered = {}, supv.oncache.pedid or PlayerPedId(), GetAllPedsAndPlayers(), nil
    if filter then
        filtered = {}
        for i = 1, #pool do
            if filter[GetPedType(pool[i])] then
                peds[#peds+1] = pool[i]
            end
        end
        return peds
    end

    for i = 1, #pool do
        if pool[i] ~= player then
            peds[#peds+1] = pool[i]
        end
    end
    return peds
end
--- entity.getPlayers
---
---@return table
local function GetPlayers()
    local players, player = {}, supv.oncache.playerid or PlayerId()

    for k,v in pairs(GetActivePlayers()) do
        local playersPed = GetPlayerPed(v)

        if DoesEntityExist(playersPed) and player ~= v then
            players[v] = playersPed
        end
    end
    return players
end
--- entity.getClosestPed
---
---@param coords vec3|table|nil
---@param filter1 table|nil
---@param filter2 table|nil
---@return number,integer
local function GetClosestPed(coords, filter1, filter2)
    return GetClosestEntity(GetPeds(filter1 or nil), false, coords, filter2)
end
--- entity.getClosestVehicle
---
---@param coords vec3|table|nil
---@param filter table|nil
---@return number,integer
local function GetClosestVehicle(coords, filter)
    return GetClosestEntity(GetVehicles(), false, coords, filter)
end
--- entity.getClosestPlayer
---
---@param coords vec3|table|nil
---@return number, integer
local function GetClosestPlayer(coords)
    return GetClosestEntity(GetPlayers(), true, coords)
end
--- entity.getClosestObject
---
---@param coords vec3|table|nil
---@param filter table|nil
---@return number
local function GetClosestObject(coords, filter)
    return GetClosestEntity(GetVehicles(), false, coords, filter)
end

local function EnumEntitiesInDistance(entities, playerEntities, coords, maxDistance)
    local nearby, distance = {}

    if coords then
        coords = vec3(coords.x, coords.y, coords.z)
    else
        coords = supv.oncache.coords or GetEntityCoords(PlayerPedId())
    end

    for k,v in pairs(entities) do
        distance = #(coords - GetEntityCoords(v))
        if distance <= maxDistance then
            nearby[#nearby+1] = playerEntities and k or v
        end
    end
    return nearby
end

--- entity.getVehiclesInArena
---
---@param coords vec3|table|nil
---@param maxDistance integer|number
---@return table
local function GetVehiclesInArena(coords, maxDistance)
    return EnumEntitiesInDistance(GetVehicles(), false, coords, maxDistance)
end
--- entity.getPlayersInArena
---
---@param coords vec3|table|nil
---@param maxDistance integer|number
---@return table
local function GetPlayersInArena(coords, maxDistance)
    return EnumEntitiesInDistance(GetPlayers(), true, coords, maxDistance)
end
--- entity.getPedsInArena
---
---@param coords vec3|table|nil
---@param maxDistance integer|number
---@param filter table|nil
---@return table
local function GetPedsInArena(coords, maxDistance, filter)
    return EnumEntitiesInDistance(GetPeds(filter or nil), false, coords, maxDistance)
end
--- entity.isZoneClear
---
---@param coords vec3|table|nil
---@param maxDistance integer|number
---@param filter table|nil
---@param filterPeds table|nil
---@return length
local function IsZoneClear(coords, maxDistance, filter, filterPeds)
    if filter == 'vehicles' or not filter then
        return #GetVehiclesInArena(coords, maxDistance)
    elseif filter == 'peds' then
        return #GetPedsInArena(coords, maxDistance, filterPeds)
    elseif filter == 'players' then
        return #GetPlayersInArena(coords, maxDistance)
    end
end

return {
    getAllPedsAndPlayers = GetAllPedsAndPlayers,
    getVehiclesInArena = GetVehiclesInArena,
    getPlayersInArena = GetPlayersInArena,
    getPedsInArena = GetPedsInArena,
    getClosestVehicle = GetClosestVehicle,
    getClosestEntity = GetClosestEntity,
    getClosestObject = GetClosestObject,
    getClosestPlayer = GetClosestPlayer,
    getClosestPed = GetClosestPed,
    getVehicles = GetVehicles,
    getPickups = GetPickups,
    getObjects = GetObjects,
    getPeds = GetPeds,
    isZoneClear = IsZoneClear,
}