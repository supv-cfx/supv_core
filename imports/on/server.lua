local RegisterNetEvent <const>, AddEventHandler <const> = RegisterNetEvent, AddEventHandler

local function EventHandler(name, token, source, cb, cooldown, global, ...)
    if (source and source ~= '') and (not token or token ~= supv.token) then return warn(("This player id : %s have execute event %s without token! (identifier: %s)"):format(source, name, supv.getIdentifierFromId(source, 'license'))) end
    if cooldown then
        local eventCooldown <const> = cooldown and supv.IsEventCooldown(name, global or source)
        if eventCooldown and eventCooldown:onCooldown then
            return global and warn('Ignoring event : '..name, 'because of global cooldown'..'\n') or warn('Ignoring event', name, 'because of cooldown for source : '..source..'\n')
        end
        supv.RegisterEventCooldown(name, cooldown, global)
    end
    cb(source, ...)
end

local function PlayHandler(_, name, cb, cooldown)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return end

    if type(cooldown) == 'number' then
        supv.RegisterEventCooldown(name, cooldown)
    end

    local eventHandler = function(token, ...)
        local eventCooldown <const> = cooldown and supv.IsEventCooldown(name, source)
        if eventCooldown and eventCooldown:onCooldown then
            return warn('Ignoring event', name, 'because of cooldown for source : '..source..'\n')
        end
        cb(...)
    end

    return AddEventHandler(supv:hashEvent(name), eventHandler)
end

supv.on = setmetatable({}, {
    __call = PlayHandler
})

function supv.on.net(name, cb, cooldown, global)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return RegisterNetEvent(supv:hashEvent(name)) end

    local eventHandler = function(token, ...)
        return EventHandler(name, token, source, cb, cooldown, global, ...)
    end

    return RegisterNetEvent(supv:hashEvent(name), eventHandler)
end