---@todo A refaire avec des cooldown et que le core gère les events

local TriggerEvent <const>, TriggerClientEvent <const> = TriggerEvent, TriggerClientEvent
local token <const> = supv.getToken()

local function PlayEvent(_, name, _, ...)
    TriggerEvent(supv:hashEvent(name), token, ...)
end

supv.emit = setmetatable({}, {
    __call = PlayEvent
})

function supv.emit.net(name, source, ...)
    TriggerClientEvent(supv:hashEvent(name, 'client'), source, ...)
end

function supv.emit.netInternal(name, source, ...)
    local payload <const> = msgpack.pack_args(...)
    local payloadLen <const> = #payload
    if type(source) == 'table' and table.type(source) == 'array' then
        for i = 1, #source do
            local _source <const> = source[i]
            TriggerClientEventInternal(supv:hashEvent(name, 'client'), source[i], payload, payloadLen)
        end
        return
    end

    TriggerClientEventInternal(supv:hashEvent(name, 'client'), source, payload, payloadLen)
end

return supv.emit