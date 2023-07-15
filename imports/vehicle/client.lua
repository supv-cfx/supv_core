local function RemoveVehicle(self)
    if DoesEntityExist(self.vehicle) then
        DeleteEntity(self.vehicle)
    end
    return nil, collectgarbage()
end

local function SpawnVehicle(model, coords, data)
    local self, p = {}, promise.new()

    self.model = type(model) == 'number' and model or joaat(model)
    self.coords = coords
    self.data = data or {}

    self.remove = RemoveVehicle

    CreateThread(function()
        for i = 1, 10 do
            if HasModelLoaded(self.model) then
                break
            end
            RequestModel(self.model)
            Wait(100)
        end

        self.vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, self.data?.network or true, self.data?.mission or false)

        ---@todo: add vehicle data setter

        if DoesEntityExist(self.vehicle) then
            p:resolve(self)
        else
            p:reject(('unable to spawn vehicle %s'):format(model))
        end
    end)

    return supv.await(p)
end