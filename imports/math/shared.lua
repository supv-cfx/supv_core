local math <const>, type <const>, tonumber <const>, tostring <const>, string <const> = math, type, tonumber, tostring, string

--- supv.math.round (ex: 1.234 -> 1)
---@param num number
---@param numDecimalPlaces? number
---@return number
local function Round(num, numDecimalPlaces)
    return tonumber(("%."..(numDecimalPlaces or 0).."f"):format(num))
end

--- supv.math.chance(50) -> 50% de chance de retourner true
---@param percent number
---@return boolean, number
local function Chance(percent)
    if type(percent) ~= 'number' then
        error("Invalid percent value provided. Expected number, got " .. type(percent))
    end

    local result <const> = math.random(1, 100)
    return result <= percent, result
end

--- supv.math.double_digits (ex: 1 -> 01)
---@param nombre string|number
---@return string
local function deuxDigits(nombre)
	return ('%02d'):format(tonumber(nombre))
end

--- supv.math.divmod -> Retourne le quotient et le reste d'une division
---@param n number Le numérateur ou le nombre à diviser
---@param d number Le dénominateur ou le nombre par lequel diviser
---@return integer quotient Le résultat de la division entière
---@return integer remainder Le reste de la division
local function DivMod(n, d)
    return math.floor(n/d), n%d
end

--- supv.math.format_years(6000) -> 16, 5, 15 ? (YEARS, MONTHS, DAYS) : 0, 0, 0
---@param days number Le total de jours à diviser
---@return integer years Le nombre d'années
---@return integer months Le nombre de mois
---@return integer days Le nombre de jours restants
local function FormatTempsYears(days)
    local daysInYear <const>, daysInMonth <const> = 365, 30
    local years <const>, daysLeftAfterYears <const> = DivMod(days, daysInYear)
    local months <const>, daysLeftAfterMonths <const> = DivMod(daysLeftAfterYears, daysInMonth)
    
    return years, months, daysLeftAfterMonths
end

---@param coord1 vector2 | vector3 | vector4
---@param coord2 vector2 | vector3 | vector4
---@return number
local function GetHeadingFromCoords(coord1, coord2)
    if not coord1 or not coord2 then return end
    if not coord1.x or not coord1.y or not coord2.x or not coord2.y then return end
    local deltaX <const>, deltaY <const> = coord2.x - coord1.x, coord2.y - coord1.y
    local heading <const> = (math.deg(math.atan(deltaY, deltaX)) - 90) % 360
    return heading
end

--- supv.math.format_time(1560351654) -> 2581, 6, "06", "17", "54" ? (WEEKS, DAYS, HOURS, MINUTES, SECONDS) : 0, 0, "00", "00", "00"
---@param sec number
---@param value? string
---@return number, number, string, string, string
--[[
local function FormatTemps(value, needed)
    local week, days, hours, minutes, secondes = 0, 0, 0, 0, value

    local unitMap <const> = {
        -- 60*60*24*7
        ["semaine"] = 604800, 
        ["week"]    = 604800,
        -- 60*60*24
        ["jour"]    = 86400,
        ["day"]     = 86400,
        ["j"]       = 86400,
        ["d"]       = 86400,
        -- 60*60
        ["heure"]   = 3600,
        ["hours"]   = 3600,
        ["h"]       = 3600,
        ["min"]     = 60,
        ["minute"]  = 60,
        {"s"}       = 1,
        ["sec"]     = 1,
        ["seconde"] = 1
    }

    if not needed or unitMap[needed] then
        local divFactor = unitMap[needed] or 1
        days, secondes = DivMod(secondes, 86400)
        hours, secondes = DivMod(secondes, 3600)
        minutes, secondes = DivMod(secondes, 60)
        
        if divFactor == 604800 then
            week, days = DivMod(days, 7)
        end
    end

    return week, days, deuxDigits(hours), deuxDigits(minutes), deuxDigits(secondes)
end
]]
---@param value number
---@return string
local function Digits(value)
    local left, num, right = tostring(value):match('^([^%d]*%d)(%d*)([%.%d]*)$')
    local formattedNumber = ("%s%s"):format(left, (num:reverse():gsub('(%d%d%d)', '%1 '):reverse()))
    return right ~= '' and ("%s%s"):format(formattedNumber, right) or formattedNumber
end

---@param currentPosition vector3 | vector4
---@param heading number
---@param distance? number
---@return vector3
local function GetCoordsInDirection(currentPosition, heading, distance)
    if not currentPosition or not heading then return end
    if not currentPosition.x or not currentPosition.y then return end

    local headingRadians <const> = math.rad(heading)
    local deltaX <const> = (distance or 10) * math.cos(headingRadians)
    local deltaY <const> = (distance or 10) * math.sin(headingRadians)

    return vec3(currentPosition.x + deltaX, currentPosition.y + deltaY, currentPosition.z)
end

return {
    round = Round,
    chance = Chance,
    double_digits = deuxDigits,
    digits = Digits,
    --format_time = FormatTemps,
    format_years = FormatTempsYears,
    divmod = DivMod,
    headingFromCoords = GetHeadingFromCoords,
    coordsInDirection = GetCoordsInDirection
}

--[[

Old code save here

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


--- supv.math.format_time (SEM JJ HH MM SS) seconde (old method)
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

--]]