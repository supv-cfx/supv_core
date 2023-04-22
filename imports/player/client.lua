


--- supv.player.get
---@param target? number
---@return table
local function GetPlayer(target)
    local self = {}
    
    if target then
        return error("targets args not supported yet!", 1)
    end

    -- self.ped = supv.cache.ped
    -- self.serverid = supv.cache.serverid
    -- self.currentvehicle = supv.cache.currentvehicle
    -- self.seat = supv.cache.seat

    return self
end

return {
    get = GetPlayer,
}