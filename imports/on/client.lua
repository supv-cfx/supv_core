local RegisterNetEvent <const>, AddEventHandler <const> = RegisterNetEvent, AddEventHandler

local function EventHandler(_, name, cb, cooldown, ...)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return end

    if type(cooldown) == 'number' then
        supv.RegisterEventCooldown(name, cooldown)
    end

    local eventHandler = function(...)
        local eventCooldown <const> = cooldown and supv.IsEventCooldown(name)
        if eventCooldown and eventCooldown:onCooldown() then
            return warn('Ignoring event', name, 'because of cooldown'..'\n')
        end
        cb(...)
    end

    return AddEventHandler(supv:hashEvent(name), eventHandler)
end

supv.on = setmetatable({}, {
    __call = EventHandler
})

function supv.on.net(name, cb, cooldown)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return RegisterNetEvent(supv:hashEvent(name)) end

    if type(cooldown) == 'number' then
        supv.RegisterEventCooldown(name, cooldown)
    end

    local eventHandler = function(...)
        local eventCooldown <const> = cooldown and supv.IsEventCooldown(name)
        if eventCooldown and eventCooldown:onCooldown() then
            return warn('Ignoring event', name, 'because of cooldown'..'\n')
        end
        cb(...)
    end

    return RegisterNetEvent(self:hashEvent(name), eventHandler)
end