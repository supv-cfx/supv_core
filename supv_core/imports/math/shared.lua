local math <const>, type <const>, tonumber <const> = math, type, tonumber

--- math.round
---
---@param num number
---@param numDecimalPlaces? number
---@return number
local function Round(num, numDecimalPlaces)
    return tonumber(string.format("%."..(numDecimalPlaces or 0).."f", num))
end

--- math.chance
---
---@param percent number
---@param cb? function
---@return boolean
local function Chance(percent, cb)
    if type(percent) ~= 'number' then return end
    if percent < 1 then return false end
    if percent > 99 then return true end
    local result = math.random(1,100)
    if cb then
        cb(result)
    end
    return result <= percent
end

return {
    round = Round,
    chance = Chance,
}