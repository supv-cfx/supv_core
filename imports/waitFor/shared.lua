---@param cb function
---@param timeout? number
---@param errmsg? string
---@return any
function supv.waitFor(cb, timeout, errmsg)
    local value = cb()
    if value ~= nil then return value end

    if type(timeout) ~= 'number' then
        timeout = 1000
    end

    local start <const> = GetGameTimer()

    while value == nil do Wait(0)

        local timer <const> = timeout and GetGameTimer() - start

        if timer and timer > timeout then
            error(('%s (waited %.2fseconds)'):format(errmsg or 'Failed to resolve callback', timer / 1000), 2)
        end

        value = cb()
    end

    return value
end

return supv.waitFor