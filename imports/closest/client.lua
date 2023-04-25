local GetActivePlayers <const>, GetGamePool <const>, GetEntityCoords <const>, GetPlayerPed <const>, IsPedAPlayer <const> = GetActivePlayers, GetGamePool, GetEntityCoords, GetPlayerPed, IsPedAPlayer

--- supv.closest.object - Get closest object
---@param coords vec3
---@param maxDistance? number-2
---@return number|nil, vec3|nil
local function GetClosestObject(coords, maxDistance)
    local objects = GetGamePool('CObject')
    local closestObject, closestCoords
    maxDistance = maxDistance or 2

    for i = 1, #objects do
        local object = objects[i]

        local objectCoords = GetEntityCoords(object)
        local distance = #(coords - objectCoords)

        if distance < maxDistance then
            maxDistance = distance
            closestObject = object
            closestCoords = objectCoords
        end
    end

    return closestObject, closestCoords
end

--- supv.closest.player - Get closest player
---@param coords vec3
---@param maxDistance? number-2
---@param included? boolean
---@return number|nil, number|nil, vec3|nil
local function GetClosestPlayer(coords, maxDistance, included)
    local players = GetActivePlayers()
    local targetId, targetPed, targetCoords
    maxDistance = maxDistance or 2

    for i = 1, #players do
        local playerid = players[i]

        if playerid ~= supv.cache.playerid or included then
            local playerPed = GetPlayerPed(playerid)
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(coords - playerCoords)

            if distance < maxDistance then
                maxDistance = distance
                targetId = playerid
                targetPed = playerPed
                targetCoords = playerCoords
            end
        end
    end

    return targetId, targetPed, targetCoords
end

--- supv.closest.vehicle - Get closest vehicle
---@param coords vec3
---@param maxDistance? number-2
---@param inside? boolean
---@return number|nil, vec3|nil
local function GetClosestVehicle(coords, maxDistance, inside)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle, closestCoords
    maxDistance = maxDistance or 2

    for i = 1, #vehicles do
        local vehicle = vehicles[i]

        if not supv.cache.vehicle or supv.cache.vehicle ~= vehicle or inside then
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = #(coords - vehicleCoords)

            if distance < maxDistance then
                maxDistance = distance
                closestVehicle = vehicle
                closestCoords = vehicleCoords
            end
        end
    end

    return closestVehicle, closestCoords
end

--- supv.closest.ped - Get closest ped
---@param coords vec3
---@param maxDistance? number-2
---@return number|nil, vec3|nil
local function GetClosestPed(coords, maxDistance)
    local peds = GetGamePool('CPed')
    local closestPed, closestCoords
    maxDistance = maxDistance or 2

    for i = 1, #peds do
        local ped = peds[i]

        if not IsPedAPlayer(ped) then   
            local pedCoords = GetEntityCoords(ped)
            local distance = #(coords - pedCoords)

            if distance < maxDistance then
                maxDistance = distance
                closestPed = ped
                closestCoords = pedCoords
            end
        end
    end

    return closestPed, closestCoords
end

return {
    vehicle = GetClosestVehicle,
    object = GetClosestObject,
    player = GetClosestPlayer,
    ped = GetClosestPed,
}