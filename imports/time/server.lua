local function ConvertTimeToMonthWeekDayHourMinuteSecond(time)
    local millisecondsInASecond <const> = 1000
    local secondsInAMinute <const> = 60
    local millisecondsInAMinute <const> = millisecondsInASecond * secondsInAMinute
    local secondsInAnHour <const> = 60 * secondsInAMinute
    local millisecondsInAnHour <const> = millisecondsInASecond * secondsInAnHour
    local secondsInADay <const> = 24 * secondsInAnHour
    local millisecondsInADay <const> = millisecondsInASecond * secondsInADay
    local secondsInAMonth <const> = 30 * secondsInADay
    local millisecondsInAMonth <const> = millisecondsInASecond * secondsInAMonth

    local months = math.floor(time / millisecondsInAMonth)
    local days = math.floor((time % millisecondsInAMonth) / millisecondsInADay)
    local hours = math.floor((time % millisecondsInADay) / millisecondsInAnHour)
    local minutes = math.floor((time % millisecondsInAnHour) / millisecondsInAMinute)
    local seconds = math.floor((time % millisecondsInAMinute) / millisecondsInASecond)
    local milliseconds = time % millisecondsInASecond

    return months, days, hours, minutes, seconds, milliseconds
end

return {
    convertTimerToTime = ConvertTimeToMonthWeekDayHourMinuteSecond,
}