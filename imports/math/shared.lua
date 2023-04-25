local math <const>, type <const>, tonumber <const>, tostring <const>, string <const> = math, type, tonumber, tostring, string

--- supv.math.round (ex: 1.234 -> 1)
---@param num number
---@param numDecimalPlaces? number
---@return number
local function Round(num, numDecimalPlaces)
    return tonumber(string.format("%."..(numDecimalPlaces or 0).."f", num))
end

--- supv.math.chance
---@param percent number
---@param cb? function
---@return boolean, number|nil
local function Chance(percent, cb)
    if type(percent) ~= 'number' then return end
    if percent < 1 then return false end
    if percent > 99 then return true end
    local result = math.random(1,100)
    if cb then cb(result) end ---@deprecated use the second return value
    return result <= percent, result
end

--- supv.math.double_digits (ex: 1 -> 01)
---@param nombre string|number
---@return string
local function deuxDigits(nombre)
	nombre = type(nombre) == 'string' and ('%02d'):format(nombre) or ('%02d'):format(tostring(nombre))
	return nombre
end

--- supv.math.format_time (SEM JJ HH MM SS) seconde
---@param sec number
---@param value? string
---@return number, number, string, string, string
local function format_temps(sec, value)
	local sem, jj, hh, mm, ss, reste = 0, 0, 0, 0, 0
    if not value or value == 'semaine' or value == 'week' then
        sem = math.floor(sec/(60*60*24*7))
        reste = sec%604800
        jj = math.floor(reste/(60*60*24))
        reste = (reste%86400)
        hh = math.floor(reste/(60*60))
        reste = (reste%3600)
        mm = math.floor(reste/60)
        ss = (reste%60)
    elseif value == 'jour' or value == 'day' or value == 'j' or value == 'd' then
        jj = math.floor(sec/(60*60*24))
        reste = (sec%86400)
        hh = math.floor(reste/(60*60))
        reste = (reste%3600)
        mm = math.floor(reste/60)
        ss = (reste%60)
    elseif value == 'heure' or value == 'hours' or value == 'h' then
        hh = math.floor(sec/(60*60))
        reste = (sec%3600)
        mm = math.floor(reste/60)
        ss = (reste%60)
    elseif value == 'min' or value == 'minute' then
        mm = math.floor(sec/60)
        reste = (sec%60)
        ss = (reste)
    elseif value == 'sec' or value == 'seconde' then
        ss = sec
    end
	return sem, jj, deuxDigits(hh), deuxDigits(mm), deuxDigits(ss)
end

return {
    round = Round,
    chance = Chance,
    double_digits = deuxDigits,
    format_time = format_temps
}