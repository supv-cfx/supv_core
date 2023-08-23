local TriggerEvent <const>, TriggerServerEvent <const> = TriggerEvent, TriggerServerEvent
local token

local function PlayEvent(_, name, ...)
    return TriggerEvent(supv:hashEvent(name), supv.token, ...)
end

supv.emit = setmetatable({}, {
    __call = PlayEvent
})

function supv.emit.net(name, ...)
    if not token then token = callback.sync(joaat('token')) end
    return TriggerServerEvent(supv:hashEvent(name, 'server'), token, ...)
end

return supv.emit