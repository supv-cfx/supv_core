local RegisterNetEvent <const>, AddEventHandler <const> = RegisterNetEvent, AddEventHandler
local GetPlayerIdentifierByType <const> = GetPlayerIdentifierByType
local Token <const> = supv.getToken()

local function EventHandler(name, token, source, cb, ...)
    if (source and source ~= '') and (not token or token ~= Token) then 
        return warn(("This player id : %s have execute event %s without token! (identifier: %s)"):format(source, name, GetPlayerIdentifierByType(source, 'license'))) 
    end
    cb(source, ...)
end

local function PlayHandler(_, name, cb)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return end

    local eventHandler = function(token, ...)
        cb(...)
    end

    AddEventHandler(supv:hashEvent(name), eventHandler)
end

supv.on = setmetatable({}, {
    __call = PlayHandler
})

function supv.on.net(name, cb, cooldown, global)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return RegisterNetEvent(supv:hashEvent(name)) end

    local eventHandler = function(token, ...)
        EventHandler(name, token, source, cb, ...)
    end

    RegisterNetEvent(supv:hashEvent(name), eventHandler)
end

return supv.on