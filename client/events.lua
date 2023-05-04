local RegisterNetEvent <const>, AddEventHandler <const>, TriggerServerEvent <const>, TriggerEvent <const>, token = RegisterNetEvent, AddEventHandler, TriggerServerEvent, TriggerEvent
local timers, GetGameTimer <const> = {}, GetGameTimer

local function GetToken()
    return supv.callback.sync('event')
end

---@param name string
---@return table|false
local function IsEventCooldown(name)
    if timers[name] then
        return timers[name]
    end
    return false
end

---@return boolean
local function GetCooldown(self)
    if not self then return end
    local time = GetGameTimer()
    if (time - self.time) < self.cooldown then
        return true
    end
    self.time = time
    return false
end

---@param name string
---@param timer number
local function RegisterCooldown(name, timer)
    local self = {}
    
    self.time = GetGameTimer()
    self.cooldown = timer
    self.onCooldown = GetCooldown

    timers[name] = self
end

Citizen.CreateThreadNow(function()
    token = GetToken()
end)

--- supv.eventHandler @ RegisterNetEvent
---@param name string
---@param cb? function
---@param cooldown? number
function supv.eventRegister(name, cb, cooldown)
    if type(name) ~= 'string' then return end
    if cb and type(cb) ~= 'function' then return end

    if type(cooldown) == 'number' then
        RegisterCooldown(name, cooldown)
    end

    if not token then
        token = GetToken()
        if not token then return warn(("This RegisterEvent '%s' not registered"):format(name)) end
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service,name)
    RegisterNetEvent(name, cb)
end

--- supv.eventHandler @ AddEventHandler
---@param name string
---@param cb function
---@param cooldown? number
function supv.eventHandler(name, cb, cooldown)
    if type(name) ~= 'string' then return end
    if cb and type(cb) ~= 'function' then return end

    if type(cooldown) == 'number' then
        RegisterCooldown(name, cooldown)
    end

    if not token then
        token = GetToken()
        if not token then return warn(("This AddEventHandler '%s' not registered"):format(name)) end
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service,name) 
    AddEventHandler(name, cb)
end

--- supv.trigger @ TriggerEvent
---@param name string
---@param ... any
function supv.trigger(name, ...)
    if type(name) ~= 'string' then return end

    local event = IsEventCooldown(name)
    if event and event:onCooldown() then return end

    if not token then
        token = GetToken()
        if not token then return warn(("This TriggerEvent '%s' can not be played"):format(name)) end
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, supv.service,name)
    TriggerEvent(name, ...)
end

--- supv.triggerServer @ TriggerServerEvent
---@param name string
---@param ... any
function supv.triggerServer(name, ...)
    if type(name) ~= 'string' then return end

    local event = IsEventCooldown(name)
    if event and event:onCooldown() then return end

    if not token then
        token = GetToken()
        if not token then return warn(("This TriggerServerEvent '%s' can not be played"):format(name)) end
    end

    name = ("__%s__:%s:%s:%s"):format('supv', token, 'server', name)
    TriggerServerEvent(name, ...)
end