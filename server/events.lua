local RegisterNetEvent <const>, AddEventHandler <const>, TriggerClientEvent <const>, TriggerEvent <const> = RegisterNetEvent, AddEventHandler, TriggerClientEvent, TriggerEvent
local token <const> = require 'server.modules.tokenizer'

---@todo: Need some time to imagine process of cooldowns for not change it in future
-- local timerSource, TimerGlobal, GetGameTimer <const> = {}, {}, GetGameTimer 

supv.callback.register('event', function(source)
    return token
end)

--- supv.eventRegister @ RegisterNetEvent
---@param name string
---@param cb? function
---@param cooldown CooldDownProps
function supv.eventRegister(name, cb)
    if type(name) ~= 'string' then return end
    if cb and type(cb) ~= 'function' then return end

    name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service,name)
    RegisterNetEvent(name, cb)
end

--- supv.eventHandler @ AddEventHandler
---@param name string
---@param cb function
---@param cooldown CooldDownProps
function supv.eventHandler(name, cb, cooldown)
    if type(name) ~= 'string' then return end
    if cb and type(cb) ~= 'function' then return end

    if type(cooldown) == 'table' then
        RegisterCooldown(name, cooldown.time, cooldown.type)
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service,name)
    AddEventHandler(name, cb)
end

--- supv.trigger @ TriggerEvent
---@param name string
---@param ... any
function supv.trigger(name, ...)
    if type(name) ~= 'string' then return end

    name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service, name)
    TriggerEvent(name, ...)
end

--- supv.triggerClient @ TriggerClientEvent
---@param name string
---@param ... any
function supv.triggerClient(name, ...)
    if type(name) ~= 'string' then return end

    name = ("__%s__:%s:%s:%s"):format('supv', token, 'client', name)
    TriggerClientEvent(name, ...)
end