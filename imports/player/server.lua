local GetPlayerIdentifiers <const>, GetPlayerPed <const>, GetEntityCoords <const>, GetEntityHeading <const> = GetPlayerIdentifiers, GetPlayerPed, GetEntityCoords, GetEntityHeading
local string <const>, ipairs <const>, vec4 <const>, GetVehiclePedIsIn <const>, GetPlayerName <const> = string, ipairs, vec4, GetVehiclePedIsIn, GetPlayerName
--- player:GetVehicle()
---
---@param last? nil|boolean
---@return entity|boolean
local function GetVehicle(self, last)
    if not last then last = false else last = last end
    self.currentVehicle = GetVehiclePedIsIn(self.pedId, last)
    return self.currentVehicle > 0 and self.currentVehicle or false
end

--- player.vec3
---
---@return vector3
local function Vector3(self)
    self.vec3 = GetEntityCoords(self.pedId)
    return self.vec3
end

--- player.vec4
---
---@return vector4
local function Vector4(self)
    local pcoords = self:getVec3()
    local h = GetEntityHeading(self.pedId)
    self.vec4 = vec4(pcoords.x, pcoords.y, pcoords.z, h)
    return self.vec4
end

--- player:distance(coords)
---
---@param coords vec3|vector3
---@return integer
local function GetDistanceBetweenCoords(self, coords)
    self.dist = #(self:getVec3() - coords)
    return self.dist
end

--- player.getIdentifier
---
---@param key nil|string
---@return string
local function GetPlayerIdentifier(self, key)

    for _,v in ipairs(GetPlayerIdentifiers(self.playerId)) do
        if string.match(v, 'steam:') then
            local steam = string.gsub(v, 'steamid:', '')
            self.steamid = steam
        elseif string.match(v, 'license:') then
            local license = string.gsub(v, 'license:', '')
            self.license = license
        elseif string.match(v, 'xbl:') then
            local xbl = string.gsub(v, 'xbl:', '')
            self.xbl = xbl
        elseif string.match(v, 'ip:') then
            local ip = string.gsub(v, 'ip:', '')
            self.ip = ip
        elseif string.match(v, 'discord:') then
            local discord = string.gsub(v, 'discord:', '')
            self.discord = discord
        elseif string.match(v, 'live:') then
            local live = string.gsub(v, 'live:', '')
            self.live = live
        end
    end

    if not key then return self.license end
    if self[key] then return self[key] end
end

local function UpdateCoords(self)
    self.lastCoords = self:getVec3()
end

local function GetLastCoords(self)
    return self.lastCoords
end

--- player.getFromId
---
---@param source number
---@return table
local function GetPlayerFromId(source)
    
    local self = {}

    self.playerId = source
    self.pedId = GetPlayerPed(source)
    self.name = GetPlayerName(source)
    
    self.getIdentifier = GetPlayerIdentifier
    self.getVec3 = Vector3
    self.getVec4 = Vector4
    self.distance = GetDistanceBetweenCoords
    self.getPedInVehicle = GetVehicle
    self.updateCoords = UpdateCoords

    self.license = self:getIdentifier('license')
    self.steamid = self:getIdentifier('steamid')
    self.lastCoords = self:getVec3()

    self.dist = 0

    return self
end

return {
    getFromId = GetPlayerFromId,
}
