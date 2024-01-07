local GetGamePool <const> = GetGamePool
local GetEntityCoords <const> = GetEntityCoords

local function GetVehicleInArea(coords, maxDistance, inside)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle, closestCoords
    maxDistance = maxDistance or 2
    local vehiclesFound = {}

    for i = 1, #vehicles do
        local vehicle = vehicles[i]

        if not supv.cache.vehicle or supv.cache.vehicle ~= vehicle or inside then
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = #(coords - vehicleCoords)

            if distance < maxDistance then
                vehiclesFound[#vehiclesFound + 1] = {
                    vehicle = vehicle,
                    coords = vehicleCoords,
                    distance = distance
                }
            end
        end
    end

    return #vehiclesFound > 0 and vehiclesFound or false
end

local function ZoneClear(coords, maxDistance, ignore)
    local vehicles <const> = GetVehicleInArea(coords, maxDistance)
    if vehicles and #vehicles == 1 and ignore then
        return vehicles[1].vehicle == ignore
    elseif vehicles and #vehicles > 0 then
        return false
    end
    return true
end

return {
    vehicles = GetVehicleInArea,
    isClear = ZoneClear
}