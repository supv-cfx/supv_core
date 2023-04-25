-- credit: ox_lib <https://github.com/overextended/ox_lib/tree/master/imports/callback>
local events, nameEvent = {}, ('__supv_cb:%s')
local RegisterNetEvent <const>, TriggerClientEvent <const>, pcall <const>, unpack <const> = RegisterNetEvent, TriggerClientEvent, pcall, table.unpack

RegisterNetEvent(nameEvent:format(supv.name), function(name, ...)
    local cb = events[name]
    return cb and cb(...)
end)

local function TriggerClientCallback(name, source, cb, ...)
    local k

    repeat
        k = ('%s:%s:%s'):format(name, math.random(0, 999999), source)
    until not events[k]

    TriggerClientEvent(nameEvent:format(name), source, supv.name, k, ...)

    local p = not cb and promise.new() or nil

    events[k] = function(resp, ...)
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

local function CallbackSynchrone(name, source, ...)
    return TriggerClientCallback(name, source, nil, ...)
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

local function RegisterCallback(name, cb, ...)
    RegisterNetEvent(nameEvent:format(name), function(resource, k, ...)
        TriggerClientEvent(nameEvent:format(resource), source, k, CallackResponse(pcall(cb, source, ...)))
    end)
end

return {
    register = RegisterCallback,
    sync = CallbackSynchrone,
    async = TriggerClientCallback
}