local function RemoveVehicle(self)
    if DoesEntityExist(self.vehicle) then
        DeleteEntity(self.vehicle)
    end
    return nil, collectgarbage()
end

local function Edit(self, data)
    if DoesEntityExist(self.vehicle) then
        if data.plate then SetVehicleNumberPlateText(self.vehicle, data.plate) end
        if data.alpha then SetEntityAlpha(self.vehicle, data.alpha[1], data.alpha[2]) end
        if data.ground then SetVehicleOnGroundProperly(self.vehicle) end
        if data.coords then 
            SetEntityCoords(self.vehicle, data.coords.x, data.coords.y, data.coords.z)
            SetEntityHeading(self.vehicle, data.coords.w) 
        end
    end
end

local function SpawnVehicle(model, coords, data)
    local self, p = {}, promise.new()

    self.model = type(model) == 'number' and model or joaat(model)
    self.coords = coords
    self.data = data

    self.remove = RemoveVehicle
    self.edit = Edit

    CreateThread(function()
        for i = 1, 10 do
            RequestModel(self.model)

            if HasModelLoaded(self.model) then
                break
            end
            Wait(100)
        end

        self.vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, self.data?.network or true, self.data?.mission or false)

        ---@todo: add vehicle data setter

        if DoesEntityExist(self.vehicle) then
            if self.data?.plate then SetVehicleNumberPlateText(self.vehicle, self.data.plate) else self.data.plate = GetVehicleNumberPlateText(self.vehicle) end
            if self.data?.alpha then SetEntityAlpha(self.vehicle, self.data.alpha[1], self.data.alpha[2]) end
            if self.data?.ground then SetVehicleOnGroundProperly(self.vehicle) end
            SetModelAsNoLongerNeeded(self.model)
            p:resolve(self)
        else
            p:reject(('unable to spawn vehicle %s'):format(model))
        end
    end)

    return supv.await(p)
end

return {
    spawn = SpawnVehicle,
}