
-- @param time number
-- @return number, number, number, number, number, number
--local function ConvertTimeToMonthWeekDayHourMinuteSecond(timeInMilliseconds)
--    local millisecondsInASecond <const> = 1000
--    local secondsInAMinute <const> = 60
--    local millisecondsInAMinute <const> = millisecondsInASecond * secondsInAMinute
--    local secondsInAnHour <const> = 60 * secondsInAMinute
--    local millisecondsInAnHour <const> = millisecondsInASecond * secondsInAnHour
--    local secondsInADay <const> = 24 * secondsInAnHour
--    local millisecondsInADay <const> = millisecondsInASecond * secondsInADay
--    local secondsInAWeek <const> = 7 * secondsInADay
--    local millisecondsInAWeek <const> = millisecondsInASecond * secondsInAWeek
--    local weeksInAMonth <const> = 4 -- Approximation
--    local secondsInAMonth <const> = weeksInAMonth * secondsInAWeek
--    local millisecondsInAMonth <const> = millisecondsInASecond * secondsInAMonth
--
--    local months = math.floor(timeInMilliseconds / millisecondsInAMonth)
--    local weeks = math.floor((timeInMilliseconds % millisecondsInAMonth) / millisecondsInAWeek)
--    local days = math.floor((timeInMilliseconds % millisecondsInAWeek) / millisecondsInADay)
--    local hours = math.floor((timeInMilliseconds % millisecondsInADay) / millisecondsInAnHour)
--    local minutes = math.floor((timeInMilliseconds % millisecondsInAnHour) / millisecondsInAMinute)
--    local seconds = math.floor((timeInMilliseconds % millisecondsInAMinute) / millisecondsInASecond)
--    local milliseconds = timeInMilliseconds % millisecondsInASecond
--
--    return months, weeks, days, hours, minutes, seconds
--end

---@param n number
---@param d number
---@return integer
---@return integer
local function DivMod(n, d)
    return math.floor(n/d), n%d
end

---@param value number
---@return string
local function DeuxDigits(value)
    return ("%02d"):format(value)
end

---@param time number
---@param needed? string
---@return number
---@return number
---@return string
---@return string
---@return string
local function FormatTime(time, needed)
    local week, days, hours, minutes, secondes = 0, 0, 0, 0, time

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
        ["s"]       = 1,
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

    return week, days, DeuxDigits(hours), DeuxDigits(minutes), DeuxDigits(secondes)
end

---@param value string
---@param on? string
---@return string
---@return string
---@return string
---@return string
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
        local v1, v2, v3, v4 = value:match(unitMap[on])
        --print(value, v1, v2, v3, v4)
        return v1, v2, v3, v4
    end
end

return {
    --convertTimerToTime = ConvertTimeToMonthWeekDayHourMinuteSecond,
    formatTime = FormatTime,
    regexOnFormat = RegexOnFormat,
    divmod = DivMod,
}