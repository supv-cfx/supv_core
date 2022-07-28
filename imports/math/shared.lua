--- math.round
---
---@param num number
---@param numDecimalPlaces number
---@return number
local function Round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end


return {
    round = Round,
}