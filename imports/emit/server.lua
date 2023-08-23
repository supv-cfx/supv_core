local TriggerEvent <const>, TriggerClientEvent <const> = TriggerEvent, TriggerClientEvent

local function PlayEvent(_, name, source, ...)
    return TriggerEvent(supv:hashEvent(name), supv.token, ...)
end

supv.emit = setmetatable({}, {
    __call = PlayEvent
})

function supv.emit.net(name, source, ...)
    return TriggerClientEvent(supv:hashEvent(name, 'client'), source, ...)
end

return supv.emit