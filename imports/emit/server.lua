local TriggerEvent <const>, TriggerClientEvent <const> = TriggerEvent, TriggerClientEvent

local function PlayEvent(_, name, source, ...)
    TriggerEvent(supv:hashEvent(name), supv.token, ...)
end

supv.emit = setmetatable({}, {
    __call = PlayEvent
})

function supv.emit.net(name, source, ...)
    TriggerClientEvent(supv:hashEvent(name, 'client'), source, ...)
end

return supv.emit