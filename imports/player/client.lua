---@param vector4? boolean-false
local function GetCoords(self, vector4)
    local coords = GetEntityCoords(supv.cache.ped)
    self.coords = coords
    if vector4 then
        local heading = GetEntityHeading(supv.cache.ped)
        self.heading = heading
        return vec4(coords.x, coords.y, coords.z, heading)
    end
    return coords
end

---@param coords vec3
---@return float
local function GetDistanceBetweenCoords(self, coords)
    self.dist = #(self:getCoords().xyz - coords)
    return self.dist
end

--- supv.player.get
---@param target? number
---@return table
local function GetPlayer(target)
    local self = {}
    
    if target then
        return error("targets args not supported yet!", 1)
    end

    self.getCoords = GetCoords
    self.distance = GetDistanceBetweenCoords
    self.dist = math.huge
    self.coords = self:getCoords()

    return self
end

return {
    get = GetPlayer,
}