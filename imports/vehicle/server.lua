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

local Vehicles = {}

local function GetAllVehiclesCreated()
    return Vehicles    
end

local function RemoveVehicle(self)
    if DoesEntityExist(self.vehicle) then
        DeleteEntity(self.vehicle)
        Vehicles[self.id] = nil
    end
    return nil, collectgarbage()
end

local function SpawnVehicle(model, _type, coords, data, properties)
    local p = promise.new()

    CreateThread(function()
        local self = {
            model = model,
            properties = properties,
            vehicle = nil,
            type = _type,
            vec3 = vec3(coords.x, coords.y, coords.z),
            vec4 = vec4(coords.x, coords.y, coords.z, coords.w or 0.0),
        }

        if self.model and self.vec3 then
            self.vehicle = CreateVehicleServerSetter(self.model, self.type, self.vec4.x, self.vec4.y, self.vec4.z, self.vec4.w)
            if DoesEntityExist(self.vehicle) then
                self.remove = RemoveVehicle
                if data.plate then
                    self.plate = data.plate
                    SetVehicleNumberPlateText(self.vehicle, self.plate)
                else
                    self.plate = GetVehicleNumberPlateText(self.vehicle)
                end

                local ped
                Wait(500)
                for i = -1, 6 do
                    ped = GetPedInVehicleSeat(self.vehicle, i)
                    local popType = ped and GetEntityPopulationType(ped)
                    if popType and popType <= 5 or popType >= 1 then
                        DeleteEntity(ped)
                    end
                end

                --local entityOwner = NetworkGetEntityOwner(self.vehicle)
                --local playerId = NetworkGetNetworkIdFromEntity(entityOwner)
                self.netId = NetworkGetNetworkIdFromEntity(self.vehicle)

                --if playerId then
                --    print('playerID as owner: ', playerId)
                --    if self.properties and next(self.properties) then
                --        supv.setVehiclesProperties(playerId, self.netId, self.properties, --data.fixed or false)
                --    elseif not self.properties then
                --        self.properties = supv.getVehiclesProperties(playerId, self.netId)
                --    end
                --end
                
                local id = #Vehicles + 1
                self.id = id
                Vehicles[self.id] = self
                p:resolve(self)
            else
                p:resolve(false)
            end
        else
            p:resolve(false)
        end
    end)

    return supv.await(p)
end

local function SearchVehicle(plate)
    local p = promise.new()

    CreateThread(function()
        local vehicles <const> = GetAllVehicles()
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
    spawn = SpawnVehicle,
    search = SearchVehicle,
    getAllCreated = GetAllVehiclesCreated,
}