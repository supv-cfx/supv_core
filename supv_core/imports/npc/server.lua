--- self:remove
---
---@return nil
---@return collectgarbage
local function DeletedSync(self)
    if DoesEntityExist(self.ped) then
        DeleteEntity(self.ped)
        supv.syncData.remove('peds', self.ped)
    end
    return nil , collectgarbage()
end

--- npc.unNet
---
---@param hash string
---@param coords table|vector4
---@param data table
---@param weapon table
---@return table
local function Sync(hash, coords, data, weapon)
    local self = {}

    if hash == nil or coords == nil then
        return
    end

    self.hash = hash or default.client.hash
    self.vec4 = coords or nil

    if not self.vec4 or not self.hash then
        return
    end
    --local id = 0
    --if not supv.syncData.get('peds') then
    --    supv.syncData.set('peds', {})
    --else
    --    id = #supv.syncData.get('peds') + 1
    --end
        

    self.vec3 = vec3(self.vec4.x, self.vec4.y, self.vec4.z)
    self.insert = {}
    CreateThread(function()
        --RequestModel(self.hash)
        --while not HasModelLoaded(self.hash) do
        --    Wait(1)
        --end
        local ped = CreatePed(_, self.hash, self.vec4.x, self.vec4.y, self.vec4.z, self.vec4.w, true, true)
        
        self.ped = ped
        self.netid = NetworkGetNetworkIdFromEntity(self.ped)

        -- FreezeEntityPosition
        -- SetPedComponentVariation
        -- SetPedDefaultComponentVariation
        -- GiveWeaponToPed

        supv.syncData.set('peds',  {entity = self.ped, netid = self.netid, coords = self.vec4})
    end)

    self.remove = DeletedSync

    return self
end

return {
    server = Sync,
    -- onNet = Sync,
}
