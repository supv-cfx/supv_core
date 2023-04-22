local string <const>, math <const> = string, math

--- string.starts
---
---@param str string
---@param start number
---@return boolean
local function Starts(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

--- string.firstToUpper
---
---@param str string
---@return string
local function FirstToUpper(str)
    return str:gsub("^%l", string.upper)
end

--- string.random
---
---@param length number
---@param s? boolean
---@return string
local function RandomString(length, s)
    local l = length or 70
    local upperCase, lowerCase, numbers, symbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz", "0123456789"
    if s then symbols = "!@#$%&()*+-,./:;<=>?^[]{}" else symbols = nil end
    local characterSet = symbols and upperCase..lowerCase..numbers..symbols or upperCase..lowerCase..numbers
    local output = ""

    for i = 1, l do
        local random = math.random(#characterSet)
        output = output..characterSet:sub(random, random)
    end
    
    return output
end

return {
    starts = Starts,
    random = RandomString,
    firstToUpper = FirstToUpper
}