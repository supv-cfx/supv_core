local CreateVehicleServerSetter <const> = CreateVehicleServerSetter
local GetGameTimer <const> = GetGameTimer
local GetPedInVehicleSeat <const> = GetPedInVehicleSeat
local SetPedIntoVehicle <const> = SetPedIntoVehicle
local GetEntityCoords <const> = GetEntityCoords
local GetEntityHeading <const> = GetEntityHeading
local DeleteEntity <const> = DeleteEntity
local GetPlayerPed <const> = GetPlayerPed
local GetAllVehicles <const> = GetAllVehicles
local GetVehicleNumberPlateText <const> = GetVehicleNumberPlateText

local function SpawnVehicle(model, coords, data, properties)
    local p = promise.new()

    CreateThread(function()
        
    end)

    return supv.await(p)
end

local function SearchVehicle(plate)
    local p = promise.new()

    CreateThread(function()
        local vehicles = GetAllVehicles()
        if vehicles and #vehicles > 0 then
            plate = plate:gsub('%s+', ''):upper()
            for i = 1, #vehicles do
                local vehicle = vehicles[i]
                if vehicle and DoesEntityExist(vehicle) then
                    local plateVehicle = GetVehicleNumberPlateText(vehicle):gsub('%s+', ''):upper()
                    if plateVehicle == plate then
                        p:resolve(vehicle)
                        return
                    end
                end
            end
        end
        p:resolve(false)
    end)

    return supv.await(p)
end

return {
    spawn = SpawnVehicle
    search = SearchVehicle
}