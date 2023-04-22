local string <const>, math <const> = string, math

--- supv.string.starts
---@param str string
---@param start number
---@return boolean
local function Starts(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

--- supv.string.firstToUpper
---@param str string
---@return string
local function FirstToUpper(str)
    str = str:lower()
    return str:gsub("^%l", string.upper)
end

--- supv.string.random
---@param length? number-70
---@param data? table
---@return string
local function RandomString(length, data)
    local output, l, default, characterSet = "", length or 70, {
        upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        lowerCase = "abcdefghijklmnopqrstuvwxyz",
        numbers = "0123456789",
        symbols = "!@#$%&()*+-,./:;<=>?^[]{}"
    }, ''

    if next(data) then
        for k in pairs(data) do
            characterSet = characterSet..default[k]
        end
    else
        for _,v in pairs(default) do
            characterSet = characterSet..v
        end
    end

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