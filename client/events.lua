local RegisterNetEvent <const>, AddEventHandler <const>, TriggerServerEvent <const>, TriggerEvent <const> = RegisterNetEvent, AddEventHandler, TriggerServerEvent, TriggerEvent

--- supv.eventHandler @ RegisterNetEvent
---@param name string
---@param cb? function
function supv.eventRegister(name, cb)
    if type(name) ~= 'string' then return end
    if cb and type(cb) ~= 'function' then return end
    name = ("__%s__:%s:%s"):format('supv', supv.service,name)
    
    RegisterNetEvent(name, cb)
end

--- supv.eventHandler @ AddEventHandler
---@param name string
---@param cb function
function supv.eventHandler(name, cb)
    if type(name) ~= 'string' then return end
    if cb and type(cb) ~= 'function' then return end
    name = ("__%s__:%s:%s"):format('supv', supv.service,name)
    
    AddEventHandler(name, cb)
end

--- supv.trigger @ TriggerEvent
---@param name string
---@param ... any
function supv.trigger(name, ...)
    if type(name) ~= 'string' then return end
    name = ("__%s__:%s:%s"):format('supv', supv.service, name)
    
    TriggerEvent(name, ...)
end

--- supv.triggerServer @ TriggerServerEvent
---@param name string
---@param ... any
function supv.triggerServer(name, ...)
    if type(name) ~= 'string' then return end
    name = ("__%s__:%s:%s"):format('supv', 'server', name)
    
    TriggerServerEvent(name, ...)
end