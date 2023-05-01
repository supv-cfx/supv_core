local RegisterNetEvent <const>, AddEventHandler <const>, TriggerServerEvent <const>, TriggerEvent <const>, token = RegisterNetEvent, AddEventHandler, TriggerServerEvent, TriggerEvent

Citizen.CreateThreadNow(function()
    token = supv.callback.sync('event')
end)

--- supv.eventHandler @ RegisterNetEvent
---@param name string
---@param cb? function
function supv.eventRegister(name, cb)
    if type(name) ~= 'string' then return end
    if cb and type(cb) ~= 'function' then return end

    CreateThread(function()
        while not token do
            Wait(500)
        end

        name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service,name)
        
        RegisterNetEvent(name, cb)
    end)
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

--- supv.triggerServer @ TriggerServerEvent
---@param name string
---@param ... any
function supv.triggerServer(name, ...)
    if type(name) ~= 'string' then return end

    while not token do
        Wait(500)
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, 'server', name)
    
    TriggerServerEvent(name, ...)
end