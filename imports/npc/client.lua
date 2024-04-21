local CreatePed <const> = CreatePed
local DoesEntityExist <const> = DoesEntityExist
local DeleteEntity <const> = DeleteEntity
local joaat <const> = joaat
local SetBlockingOfNonTemporaryEvents <const> = SetBlockingOfNonTemporaryEvents
local SetEntityInvincible <const> = SetEntityInvincible
local FreezeEntityPosition <const> = FreezeEntityPosition
local SetPedComponentVariation <const> = SetPedComponentVariation
local SetPedDefaultComponentVariation <const> = SetPedDefaultComponentVariation
local GiveWeaponToPed <const> = GiveWeaponToPed

---@class NpcWeaponsProps
---@field model string|number
---@field ammo? number-0
---@field visible? boolean-true
---@field hand? boolean-false

---@class DataNpcProps
---@field network? boolean-true
---@field blockevent? boolean-true
---@field godmode? boolean-true
---@field freeze? boolean-true
---@field variation? number
---@field weapon? NpcWeaponsProps

---@return nil
local function Remove(self)
    if DoesEntityExist(self.ped) then
        DeleteEntity(self.ped)
        return nil, collectgarbage()
    end
end

---@param useVec4? boolean
---@return vec3 | vec4
local function GetCoords(self, useVec4)
    if DoesEntityExist(self.ped) then
        local coords <const> = GetEntityCoords(self.ped)
        self.vec3 = coords
        if not useVec4 then return self.vec3 end
        local heading <const> = GetEntityHeading(self.ped)
        self.vec4 = vec4(coords.x, coords.y, coords.z, heading)
        return self.vec4
    end
end

---@param targetCoords vec3
---@return integer
local function Distance(self, targetCoords, useVec4)
    local coords <const> = self:getCoords(useVec4)
    return coords and #(coords - targetCoords)
end

---@param data DataNpcProps
local function Edit(self, data)
    if DoesEntityExist(self.ped) then
        if data.network then SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(self.ped), data.network) end
        if data.blockevent then SetBlockingOfNonTemporaryEvents(self.ped, data.blockevent) end
        if data.godmode then SetEntityInvincible(self.ped, data.godmode) end
        if data.freeze then FreezeEntityPosition(self.ped, data.freeze) end
        if data.variation then SetPedComponentVariation(self.ped, data.variation) else SetPedDefaultComponentVariation(self.ped) end
        if type(data.weapon) == 'table' and data.weapon.model then
            local weapon <const> = type(data.weapon.model) == 'number' and data.weapon.model or joaat(data.weapon.model)
            GiveWeaponToPed(self.ped, weapon, data.weapon.ammo or 0, data.weapon.visible or true, data.weapon.hand or false)
        end
        if data.coords then
            SetEntityCoordsNoOffset(self.ped, data.coords.x, data.coords.y, data.coords.z)
            self.vec3 = vec3(data.coords.x, data.coords.y, data.coords.z)
            if data.coords.w or data.coords.h or data.coords.heading then
                self.vec4 = vec4(data.coords.x, data.coords.y, data.coords.z, data.coords.w or data.coords.h or data.coords.heading or .0)
                SetEntityHeading(self.ped, data.coords.w or data.coords.h or data.coords.heading or .0)
            end
        end

        return self
    end 
end

---@param model string|number
---@param coords vec4
---@param data? DataNpcProps
---@return table
local function New(model, coords, data)

    local p = promise.new()

    CreateThread(function()
        local self = {}

        self.model = model
        self.vec3 = vec3(coords.x, coords.y, coords.z)
        self.vec4 = vec4(coords.x, coords.y, coords.z, coords.w or coords.h or .0)
        self.network = data.network == nil and true or data.network
        self.blockevent = data.blockevent == nil and true or data.blockevent
        self.godmode = data.godmode == nil and true or data.godmode
        self.freeze = data.freeze == nil and true or data.freeze
        self.variation = data.variation
        self.weapon = data.weapon
        self.distance = Distance
        self.getCoords = GetCoords
        self.remove = Remove
        self.edit = Edit

        supv.request({ type = 'model', name = self.model })

        self.ped = CreatePed(_, self.model, self.vec4.x, self.vec4.y, self.vec4.z, self.vec4.w, self.network, false)

        if DoesEntityExist(self.ped) then
            SetBlockingOfNonTemporaryEvents(self.ped, self.blockevent or true)
            SetEntityInvincible(self.ped, self.godmode or true)
            FreezeEntityPosition(self.ped, self.freeze or true)
            if self.variation then SetPedComponentVariation(self.ped, self.variation) else SetPedDefaultComponentVariation(self.ped) end
            if type(self.weapon) == 'table' and self.weapon.model then
                local weapon <const> = type(self.weapon.model) == 'number' and self.weapon.model or joaat(self.weapon.model)
                GiveWeaponToPed(self.ped, weapon, self.weapon.ammo or 0, self.weapon.visible or true, self.weapon.hand or false)
            end

            SetEntityCoordsNoOffset(self.ped, self.vec4.x, self.vec4.y, self.vec4.z)
            SetEntityHeading(self.ped, self.vec4.w)
            SetModelAsNoLongerNeeded(self.model)
            p:resolve(self)
        else
            p:reject(('Failed to create ped in %s'):format(supv.env))
        end
    end)

    return supv.await(p)
end

---@deprecated Use new method instead
---@param model string|number
---@param coords vec4
---@param cb? function
---@param network? boolean-true
local function Create(model, coords, cb, network)
    model = type(model) == 'number' and model or joaat(model)
    local flushModel <const> = supv.request({ type = 'model', name = model })
    local ped = CreatePed(_, model, coords.x, coords.y, coords.z, coords.w or coords.h or 0.0, network or true, false)
    flushModel(model)
    if cb then cb(ped) end
end

return {
    new = New,
    create = Create ---@deprecated Use new method instead
}