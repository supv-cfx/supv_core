local CreatePed <const> = CreatePed
local DoesEntityExist <const> = DoesEntityExist
local DeleteEntity <const> = DeleteEntity
local joaat <const> = joaat
local RequestModel <const> = RequestModel
local HasModelLoaded <const> = HasModelLoaded
local SetBlockingOfNonTemporaryEvents <const> = SetBlockingOfNonTemporaryEvents
local SetEntityInvincible <const> = SetEntityInvincible
local FreezeEntityPosition <const> = FreezeEntityPosition
local SetPedComponentVariation <const> = SetPedComponentVariation
local SetPedDefaultComponentVariation <const> = SetPedDefaultComponentVariation
local GiveWeaponToPed <const> = GiveWeaponToPed
local Await <const> = Citizen.Await

---@class NpcWeaponsProps
---@field model string|number
---@field ammo? number-0
---@field visible? boolean-true

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

---@param model string|number
---@param coords vec4
---@param data? DataNpcProps
---@return table
local function New(model, coords, data)
    local self = {}

    self.model = type(model) == 'number' and model or joaat(model)
    self.vec3 = vec3(coords.x, coords.y, coords.z)
    self.vec4 = vec4(coords.x, coords.y, coords.z, coords.w or coords.h or 0.0)
    self.remove = Remove

    local p = promise.new()

    CreateThread(function()
        RequestModel(self.hash)
        while not HasModelLoaded(self.hash) do
            Wait(1)
        end

        self.ped = CreatePed(_, self.model, self.vec4.x, self.vec4.y, self.vec4.z, self.vec4.w, data?.network or true, false)

        if DoesEntityExist(self.ped) then
            SetBlockingOfNonTemporaryEvents(self.ped, data?.blockevent or true)
            SetEntityInvincible(self.ped, data?.godmode or true)
            FreezeEntityPosition(self.ped, data?.freeze or true)
            if data?.variation then SetPedComponentVariation(self.ped, data.variation) else SetPedDefaultComponentVariation(self.ped) end
            if data?.weapon and type(data.weapon) == 'table' and data.weapon.model then
                local weapon = type(data.weapon.model) == 'number' and data.weapon.model or joaat(data.weapon.model)
                GiveWeaponToPed(self.ped, weapon, data.weapon?.ammo or 0, data.weapon?.visible or true, true)
            end
            p:resolve(self)
        else
            p:reject(('Failed to create ped in %s'):format(supv.env))
        end
    end)

    return Await(p)
end

return {
    new = New,

}