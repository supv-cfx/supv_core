
--- self:distance
---
---@param coords table|vector3
---@param target nil|boolean
---@return integer
local function getDistanceCoords(self, coords, target)
    if not target then 
        if not supv.oncache.coords then return end
        if self.coords ~= supv.oncache.coords then self.coords = supv.oncache.coords end
    else
        if GetEntityCoords(self.pedid, false) ~= self.coords then self.coords = GetEntityCoords(self.pedid, false) end  
    end 
    if not coords then return end
    return #(self.coords - coords)
end


--- self:getCoords
---
---@param target nil|boolean
---@return vector3
local function getCoords(self, target)
    if not target then
        if self.coords ~= supv.oncache.coords then self.coords = supv.oncache.coords end
    else
        if GetEntityCoords(self.pedid, false) ~= self.coords then self.coords = GetEntityCoords(self.pedid, false) end
    end
    return self.coords
end

--- self:currentVehicle
---@param target nil|boolean
---@return entity|number
local function getCurrentVehicle(self, target)
    if not target then
        if self.currentvehicle ~= supv.oncache.currentvehicle then self.currentvehicle = supv.oncache.currentvehicle end
    else
        if GetVehiclePedIsIn(self.pedid, false) ~= self.currentvehicle then self.currentvehicle = GetVehiclePedIsIn(self.pedid, false) end
    end
    return self.currentvehicle
end

--- player.GetLocalPlayer
---
---@param target nil|source
---@return table
local function getPlayer(target)
    local self = {}
    if target then
        --GetPlayerFromServerId(GetPlayerServerId(GetPlayerPed(target)))
        self.currentvehicle = GetVehiclePedIsIn(GetPlayerPed(target), false)
        self.serverid = GetPlayerServerId(GetPlayerFromServerId(GetPlayerPed(target))) -- à teste
        self.playerid = GetPlayerFromServerId(GetPlayerServerId(GetPlayerPed(target))) -- à teste
        self.pedid = GetPlayerPed(target)
        self.coords = GetEntityCoords(GetPlayerPed(target), false)
    else
        self.currentvehicle = supv.oncache.currentvehicle
        self.serverid = supv.oncache.serverid
        self.playerid = supv.oncache.playerid
        self.pedid = supv.oncache.pedid
        self.screen = supv.oncache.screen
        self.coords = supv.oncache.coords
    end

    self.distance = getDistanceCoords
    self.getCoords = getCoords
    self.currentVehicle = getCurrentVehicle

    return self
end

return {
    GetLocalPlayer = getPlayer
}
