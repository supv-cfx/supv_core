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
    self.currentvehicle = GetVehiclePedIsIn(PlayerPedId(), false) > 0 and GetVehiclePedIsIn(PlayerPedId(), false) or false
    if self.currentvehicle then
        return self.currentvehicle
    end
    self.seat = nil
    return false
end

local function getSeat(self)
    if not self.pedid or self.pedid ~= PlayerPedId() then self.pedid = PlayerPedId() end -- évite la perte du pedid au premier chargement, sera corrigé mieux que cela dans la release de supv_core (hors beta)
    if self.currentvehicle then
        if self.seat and self.pedid == GetPedInVehicleSeat(self.currentvehicle, self.seat) then return self.seat end
        local model = GetEntityModel(self.currentvehicle)
        if model then
            for i = -1, GetVehicleModelNumberOfSeats(model), 1 do
                if GetPedInVehicleSeat(self.currentvehicle, i) == self.pedid then
                    self.seat = i
                    break
                end
            end
            return self.seat
        end
    end
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
    self.currentvehicle = GetVehiclePedIsIn(self.pedid) > 0 and GetVehiclePedIsIn(self.pedid) or false
    self.coords = GetEntityCoords(self.pedid)
    self.dist = nil
    self.seat = nil
    self.isDead = getIsDead
    self.distance = getDistanceCoords
    self.getCoords = getCoords
    self.currentVehicle = getCurrentVehicle
    self.getSeat = getSeat
    return self
end

return {
    get = getPlayer
}
