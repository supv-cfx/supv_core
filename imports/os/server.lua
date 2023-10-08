---@param date string
---@return number
local function ConvertDateToTimestamp(date)
    local year <const>, month <const>, day <const>, hour <const>, min <const>, sec <const> = date:match("(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)")
    local convertedDate <const> = os.time({year = year, month = month, day = day, hour = hour, min = min, sec = sec})
    return convertedDate
end

---@param time number
---@return number, number, number, number, number, number
local function GetDifferenceTime(time)
    local currentTime <const> = os.time()
    local difference = currentTime - time -- en secondes
    -- année, mois, jour, heure, minute, seconde
    --local years <const> = math.floor(difference / (365 * 24 * 3600))
    --difference = difference % (365 * 24 * 3600)
    local months <const> = math.floor(difference / (30 * 24 * 3600))
    difference = difference % (30 * 24 * 3600)
    local days <const> = math.floor(difference / (24 * 3600))
    difference = difference % (24 * 3600)
    local hours <const> = math.floor(difference / 3600)
    difference = difference % 3600
    local minutes <const> = math.floor(difference / 60)
    difference = difference % 60
    local seconds <const> = difference
    return --[[ years,]] months, days, hours, minutes, seconds
end

local function DivMod(n, d)
    return math.floor(n/d), n%d
end

local function DeuxDigits(value)
    return ("%02d"):format(value)
end

local function FormatTime(sec, value)
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
        return jj, DeuxDigits(hh), DeuxDigits(mm), DeuxDigits(ss)
    elseif value == 'heure' or value == 'hours' or value == 'h' then
        hh = math.floor(sec/(60*60))
        reste = (sec%3600)
        mm = math.floor(reste/60)
        ss = (reste%60)
        return DeuxDigits(hh), DeuxDigits(mm), DeuxDigits(ss)
    elseif value == 'min' or value == 'minute' then
        mm = math.floor(sec/60)
        reste = (sec%60)
        ss = (reste)
        return mm, ss
    elseif value == 'sec' or value == 'seconde' then
        ss = sec
        return ss
    end
	return sem, jj, DeuxDigits(hh), DeuxDigits(mm), DeuxDigits(ss)
end

local function RegexOnFormat(value, on)
    local unitMap <const> = {
        -- 60*60*24*7
        ["semaine"] = "^(%d+):(%d+):(%d+):(%d+)$", 
        ["week"]    = "^(%d+):(%d+):(%d+):(%d+)$",
        -- 60*60*24
        ["jour"]    = "^(%d+):(%d+):(%d+)$",
        ["day"]     = "^(%d+):(%d+):(%d+)$",
        ["j"]       = "^(%d+):(%d+):(%d+)$",
        ["d"]       = "^(%d+):(%d+):(%d+)$",
        -- 60*60
        ["heure"]   = "^(%d+):(%d+)$",
        ["hours"]   = "^(%d+):(%d+)$",
        ["h"]       = "^(%d+):(%d+)$",
    }

    if not on or unitMap[on] then
        local divFactor = unitMap[on] or unitMap.semaine
        local v1, v2, v3, v4 = value:match(divFactor)
        --print(on.."- regex", value, v1, v2, v3, v4)
        return v1, v2, v3, v4
    end
end

---@param value string
local function ConvertTimeToSeconde(value) --- DD:HH:MM
    local days, hours, minutes = value:match("^(%d+):(%d+):(%d+)$")
    
    if not days or not hours or not minutes then
        return nil, "Invalid time format"
    end

    local totalSeconds <const> = (tonumber(days) * 86400) + (tonumber(hours) * 3600) + (tonumber(minutes) * 60)
    return totalSeconds
end

return {
    convertDateToTimestamp = ConvertDateToTimestamp,
    getDifferenceTime = GetDifferenceTime,
    formatTime = FormatTime,
    regexOnFormat = RegexOnFormat,
    convertTimeToSeconde = ConvertTimeToSeconde,
}