local string <const> = string

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

return {
    starts = Starts,
    firstToUpper = FirstToUpper
}