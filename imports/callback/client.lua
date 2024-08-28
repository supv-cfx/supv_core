-- credit: ox_lib <https://github.com/overextended/ox_lib/tree/master/imports/callback>
local events, timers, nameEvent = {}, {}, ('__supv_cb:%s')
local RegisterNetEvent <const>, TriggerServerEvent <const>, pcall <const>, unpack <const> = RegisterNetEvent, TriggerServerEvent, pcall, table.unpack

RegisterNetEvent(nameEvent:format(supv.name), function(name, ...)
    local cb = events[name]
    return cb and cb(...)
end)

local function EventTimer(name, timer)
    if type(timer) == 'number' and timer > 0 then
        local time = GetGameTimer()
       
        if (timers[name] or 0) > time then
            return false
        end

        timers[name] = time + timer
    end

    return true
end

local function TriggerServerCallback(name, timer, cb, ...)
    if not EventTimer(name, timer) then return end

    local k

    repeat
        k = ('%s:%s'):format(name, math.random(0, 999999))
    until not events[name]

    TriggerServerEvent(nameEvent:format(supv:hashEvent(name, 'cb')), supv.name, k, ...)

    local p = not cb and promise.new() or nil

    events[k] = function (resp, ...)
        resp = {resp, ...}
        events[k] = nil

        if p then
            return p:resolve(resp)
        elseif cb then
            cb(unpack(resp))
        end
    end

    if p then
        return unpack(supv.await(p))
    end
end

local function CallbackSync(name, timer, ...)
    return TriggerServerCallback(name, timer, nil, ...)
end

local function CallackResponse(success, result, ...)
    if not success then
        if result then
            return error(("ERROR callback : %s"):format(result))
        end
        return false
    end
    return result, ...
end

local function RegisterCallback(name, cb)
    RegisterNetEvent(nameEvent:format(supv:hashEvent(name, 'cb')), function(resource, k, ...)
        TriggerServerEvent(nameEvent:format(resource), k, CallackResponse(pcall(cb, ...)))
    end)
end

return {
    register = RegisterCallback,
    sync = CallbackSync,
    async = TriggerServerCallback
}