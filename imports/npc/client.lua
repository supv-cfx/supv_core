

local default <const> = {
    client = supv.config.client.import.npc.client,
    syncClient = supv.config.client.import.npc.synclient
}

----------------------------------------------------------------------------------
---------------------------------------Sync---------------------------------------
----------------------------------------------------------------------------------

--- self:remove
---
---@return nil
---@return collectgarbage
local function DeletedSync(self)
    if DoesEntityExist(self.ped) then
        DeleteEntity(self.ped)
        supv.syncData.remove('peds', self.ped)
    end
    return nil, collectgarbage()
end

--- npc.onNet
---
---@param hash string
---@param coords table|vector4
---@param data table
---@param weapon table
---@return table
local function Sync(hash, coords, data, weapon)
    local self = {}
    local iter = 0
    if hash == nil or coords == nil then
        return
    end

    self.hash = hash or default.client.hash
    self.vec4 = coords or nil

    if not self.vec4 or not self.hash then
        return
    end

    self.vec3 = vec3(self.vec4.x, self.vec4.y, self.vec4.z)

    self.data = {}

    if data then
        self.data.blockevent = data.blockevent --or default.client.data.blockevent
        self.data.freeze = data.freeze --or default.client.data.freeze
        self.data.godmode = data.godmode --or default.client.data.godmode
        self.data.variation = data.varation --or default.client.data.varation
    else
        self.data.blockevent = default.client.data.blockevent
        self.data.freeze = default.client.data.freeze
        self.data.godmode = default.client.data.godmode
        self.data.variation = default.client.data.varation
    end


    self.weapon = {}

    if weapon then
        self.weapon.hash = weapon.hash or default.client.weapon.hash
    end

    CreateThread(function()
        RequestModel(self.hash)
        while not HasModelLoaded(self.hash) do
            Wait(1)
        end
        local ped = CreatePed(_, self.hash, self.vec4.x, self.vec4.y, self.vec4.z, self.vec4.w, true, true)
        
        self.ped = ped

        SetBlockingOfNonTemporaryEvents(ped, self.data.blockevent)
        SetEntityInvincible(ped, self.data.godmode)
        FreezeEntityPosition(ped, self.data.freeze)

        if self.data.variation then
            SetPedComponentVariation(ped, self.data.variation)
        else
            SetPedDefaultComponentVariation(ped)
        end

        if weapon then
            self.weapon.ammo = weapon.ammo or default.client.weapon.ammo
            self.weapon.visible = weapon.visible or default.client.weapon.visible
            GiveWeaponToPed(ped, self.weapon.hash, self.weapon.ammo, self.weapon.visible, true)
        end

        supv.syncData.set('peds',  {entity = self.ped, netid = self.netid, coords = self.vec4})
    end)

    self.remove = DeletedSync

    return self
end

----------------------------------------------------------------------------------
-------------------------------------NoSync---------------------------------------
----------------------------------------------------------------------------------

--- self:remove
---
---@return nil
---@return collectgarbage
local function DeletedNoSync(self)
    if DoesEntityExist(self.ped) then
        DeleteEntity(self.ped)
    end
    return nil, collectgarbage()
end

--- npc.unNet
---
---@param hash string
---@param coords table|vector4
---@param data table
---@param weapon table
---@return table
local function NoSync(hash, coords, data, weapon)
    local self = {}

    if hash == nil or coords == nil then
        return
    end

    self.hash = hash or default.client.hash
    self.vec4 = coords or nil

    if not self.vec4 or not self.hash then
        return
    end

    self.vec3 = vec3(self.vec4.x, self.vec4.y, self.vec4.z)

    self.data = {}

    if data then
        self.data.blockevent = data?.blockevent or default.client.data.blockevent
        self.data.freeze = data?.freeze or default.client.data.freeze
        self.data.godmode = data?.godmode or default.client.data.godmode
        self.data.variation = data?.variation or default.client.data.varation
    else
        self.data.blockevent = default.client.data.blockevent
        self.data.freeze = default.client.data.freeze
        self.data.godmode = default.client.data.godmode
        self.data.variation = default.client.data.varation
    end


    self.weapon = {}

    if weapon then
        self.weapon.hash = weapon.hash or default.client.weapon.hash
    end

    CreateThread(function()
        RequestModel(self.hash)
        while not HasModelLoaded(self.hash) do
            Wait(1)
        end
        local ped = CreatePed(_, self.hash, self.vec4.x, self.vec4.y, self.vec4.z, self.vec4.w, false, true)
        
        self.ped = ped

        SetBlockingOfNonTemporaryEvents(ped, self.data.blockevent)
        SetEntityInvincible(ped, self.data.godmode)
        FreezeEntityPosition(ped, self.data.freeze)

        if self.data.variation then
            SetPedComponentVariation(ped, self.data.variation)
        else
            SetPedDefaultComponentVariation(ped)
        end

        if weapon then
            self.weapon.ammo = weapon.ammo or default.client.weapon.ammo
            self.weapon.visible = weapon.visible or default.client.weapon.visible
            GiveWeaponToPed(ped, self.weapon.hash, self.weapon.ammo, self.weapon.visible, true)
        end
    end)

    self.remove = DeletedNoSync

    return self
end

return {
    unNet = NoSync,
    onNet = Sync,
}


