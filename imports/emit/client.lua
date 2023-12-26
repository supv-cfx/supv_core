local TriggerEvent <const>, TriggerServerEvent <const> = TriggerEvent, TriggerServerEvent
local token

local function PlayEvent(_, name, ...)
    TriggerEvent(supv:hashEvent(name), ...)
end

supv.emit = setmetatable({}, {
    __call = PlayEvent
})

function supv.emit.net(name, ...)
    if not token then token = supv.callback.sync(supv:hashEvent('token', 'server')) end
    TriggerServerEvent(supv:hashEvent(name, 'server'), token, ...)
end

return supv.emit