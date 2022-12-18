local GetEntityCoords <const> = GetEntityCoords
local GetVehiclePedIsIn <const> = GetVehiclePedIsIn
local PlayerId <const> = PlayerId
local GetPlayerServerId <const> = GetPlayerServerId
local PlayerPedId <const> = PlayerPedId
local GetActiveScreenResolution <const> = GetActiveScreenResolution
local GetPlayerPed <const> = GetPlayerPed

--- self:getCoords
---
---@return vector3
local function getCoords(self)
    self.coords = GetEntityCoords(PlayerPedId())
    return self.coords
end

--- self:distance
---
---@param coords table|vector3
---@return integer
local function getDistanceCoords(self, coords)
    self.dist = #(self:getCoords() - coords)
    return self.dist
end

--- self:currentVehicle
---@param target nil|boolean
---@return entity|false
local function getCurrentVehicle(self)
    self.currentvehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if self.currentvehicle > 0 then
        return self.currentvehicle
    end
    return false
end

local function getIsDead(self)
    return IsPedDeadOrDying(self.pedid, 1) or false
end

--- player.get
---
---@param target nil|source
---@return table
local function getPlayer(target)
    local self = {}
    self.pedid = PlayerPedId()
    self.playerid = PlayerId()
    self.serverid = GetPlayerServerId(self.playerid)
    self.screen = GetActiveScreenResolution()
    self.currentvehicle = GetVehiclePedIsIn(self.pedid)
    self.coords = GetEntityCoords(self.pedid)
    self.dist = nil
    self.isDead = getIsDead
    self.distance = getDistanceCoords
    self.getCoords = getCoords
    self.currentVehicle = getCurrentVehicle
    return self
end

return {
    get = getPlayer
}
