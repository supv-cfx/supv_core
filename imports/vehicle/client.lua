local DoesEntityExist <const> = DoesEntityExist
local CreateVehicle <const> = CreateVehicle
local DeleteEntity <const> = DeleteEntity
local SetVehicleNumberPlateText <const> = SetVehicleNumberPlateText
local SetEntityAlpha <const> = SetEntityAlpha
local SetVehicleOnGroundProperly <const> = SetVehicleOnGroundProperly
local SetEntityCoords <const> = SetEntityCoords
local SetEntityHeading <const> = SetEntityHeading
local GetVehicleNumberPlateText <const> = GetVehicleNumberPlateText

---@todo documentation

local function RemoveVehicle(self)
    if DoesEntityExist(self.vehicle) then
        DeleteEntity(self.vehicle)
    end
    return nil, collectgarbage()
end

---@param data any ---@todo
---@param cb fun(self: table)
local function Edit(self, data, cb)
    if DoesEntityExist(self.vehicle) then
        if data.plate and (self.data.plate and self.data.plate ~= data.plate) then 
            SetVehicleNumberPlateText(self.vehicle, data.plate)
            self.data.plate = data.plate
        end
        if data.alpha then 
            SetEntityAlpha(self.vehicle, data.alpha[1], data.alpha[2])
            self.data.alpha = data.alpha
        end
        if data.ground then 
            SetVehicleOnGroundProperly(self.vehicle)
            self.data.ground = data.ground
        end
        if data.vec4 then
            SetEntityCoords(self.vehicle, data.vec4.x, data.vec4.y, data.vec4.z)
            SetEntityHeading(self.vehicle, data.vec4.w)
            self.vec4 = data.vec4
            self.vec3 = vec3(data.vec4.x, data.vec4.y, data.vec4.z)
        end
        if data.vec3 then
            SetEntityCoords(self.vehicle, data.vec3.x, data.vec3.y, data.vec3.z)
            self.vec3 = data.vec3
            self.vec4 = vec4(data.vec3.x, data.vec3.y, data.vec3.z, data.vec4.w or data.vec3.h or 0.0)
        end
        if data.freeze and (self.data.freeze and self.data.freeze ~= data.freeze) then
            FreezeEntityPosition(self.vehicle, data.freeze)
            self.data.freeze = data.freeze
        end
        if data.collision then 
            SetEntityCollision(self.vehicle, data.collision)
            self.data.collision = data.collision
        end
        if cb then cb(self) end
    end
end

---@param model any
---@param coords any
---@param data any ---@todo
---@return table
local function SpawnVehicle(model, coords, data)
    local self, p = {}, promise.new()

    self.model = model
    self.vec3 = vec3(coords.x, coords.y, coords.z)
    self.vec4 = vec4(coords.x, coords.y, coords.z, coords.w or coords.h or 0.0)
    self.data = {
        plate = data.plate,
        alpha = data.alpha,
        ground = data.ground,
        network = data.network or true,
        mission = data.mission or false,
        freeze = data.freeze,
        collision = data.collision,
    }

    self.remove = RemoveVehicle
    self.edit = Edit

    CreateThread(function()
        local FlushModel <const> = supv.request({ type = 'model', name = self.model })

        self.vehicle = CreateVehicle(self.model, self.vec4.x, self.vec4.y, self.vec4.z, self.vec4.w, self.data.network, self.data.mission)
        FlushModel(self.model)
        ---@todo: add vehicle data setter

        if DoesEntityExist(self.vehicle) then
            if self.data.plate then SetVehicleNumberPlateText(self.vehicle, self.data.plate) else self.data.plate = GetVehicleNumberPlateText(self.vehicle) end
            if self.data.alpha then SetEntityAlpha(self.vehicle, self.data.alpha[1], self.data.alpha[2]) end
            if self.data.ground then SetVehicleOnGroundProperly(self.vehicle) end
            if self.data.freeze then FreezeEntityPosition(self.vehicle, self.data.freeze) end
            if self.data.collision then SetEntityCollision(self.vehicle, self.data.collision[1], self.data.collision[2]) end

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