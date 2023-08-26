local RegisterNetEvent <const>, AddEventHandler <const> = RegisterNetEvent, AddEventHandler

local function addEventHandler(_, name, cb)
    AddEventHandler(supv:hashEvent(name), cb)
end

supv.on = setmetatable({}, {
    __call = addEventHandler
})

function supv.on.net(name, cb)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return RegisterNetEvent(supv:hashEvent(name)) end

    RegisterNetEvent(supv:hashEvent(name), cb)
end

function supv.on.cache(key, cb)
    if not cb then return end
    AddEventHandler(('cache:%s'):format(key), cb)
end

return supv.on