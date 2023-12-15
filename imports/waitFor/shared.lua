---@param cb function
---@param timeout? number
---@param errmsg? string
---@return any
function supv.waitFor(cb, timeout, errmsg)
    local value = cb()
    if value ~= nil then return value end

    timeout = timeout or 1000
    local startTimer <const> = GetGameTimer()

    while value == nil do Wait(0)
        if GetGameTimer() - startTimer > timeout then
            error(('%s (waited %.2fseconds)'):format(errmsg or 'Failed to resolve callback', (GetGameTimer() - startTimer) / 1000), 2)
        end

        value = cb()
    end

    return value
end

return supv.waitFor