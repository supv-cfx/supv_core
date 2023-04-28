local RegisterNetEvent <const>, AddEventHandler <const>, TriggerClientEvent <const>, TriggerEvent <const> = RegisterNetEvent, AddEventHandler, TriggerClientEvent, TriggerEvent

local token <const> = require 'server.modules.tokenizer'

--- supv.eventRegister @ RegisterNetEvent
---@param name string
---@param cb? function
function supv.eventRegister(name, cb)
    if type(name) ~= 'string' then return end
    if cb and type(cb) ~= 'function' then return end

    while not token do
        Wait(500)
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service,name)

    RegisterNetEvent(name, cb)
end

--- supv.eventHandler @ AddEventHandler
---@param name string
---@param cb function
function supv.eventHandler(name, cb)
    if type(name) ~= 'string' then return end
    if cb and type(cb) ~= 'function' then return end

    while not token do
        Wait(500)
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service,name)
    
    AddEventHandler(name, cb)
end

--- supv.trigger @ TriggerEvent
---@param name string
---@param ... any
function supv.trigger(name, ...)
    if type(name) ~= 'string' then return end

    while not token do
        Wait(500)
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service, name)
    
    TriggerEvent(name, ...)
end

--- supv.triggerClient @ TriggerClientEvent
---@param name string
---@param ... any
function supv.triggerClient(name, ...)
    if type(name) ~= 'string' then return end

    while not token do
        Wait(500)
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, 'client', name)
    
    TriggerClientEvent(name, ...)
end

supv.callback.register('event', function(source)
    return token
end)