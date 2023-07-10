---@todo: more documentation soon in this code

local RegisterNetEvent <const>, AddEventHandler <const>, TriggerEvent <const>, joaat <const> = RegisterNetEvent, AddEventHandler, TriggerEvent, joaat

supv.token = require 'imports.string.shared'.uuid() -- @return string uuid (randomly generated when resource start)
print('token : ', supv.token)
callback.register(joaat('token'), function(source)
    return supv.token
end)

local timers = {}

---@param name string
---@return table|false
local function IsEventCooldown(name, source)
    if timers[source] then
        return timers[source][name]
    elseif timers[name] then
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
---@param global? boolean
local function RegisterCooldown(name, timer, global)
    local self = {}
    
    self.time = GetGameTimer()
    self.cooldown = timer
    self.onCooldown = GetCooldown

    if global then
        timers[name] = self
    else
        if not timers[source] then
            timers[source] = {}
        end
        timers[source][name] = self
    end
end

---@param name string
---@param token? string
---@param source? integer
---@param cb fun(source: integer, ...: any)
---@param cooldown? number
---@param global? boolean
---@param ... any
local function EventHandler(name, token, source, cb, cooldown, global, ...)
    if (source and source ~= '') and (not token or token ~= sl.token) then return warn(("This player id : %s have execute event %s without token! (identifier: %s)"):format(source, name, sl.getIdentifierFromId(source, 'license'))) end
    if cooldown and not global then
        local eventCooldown = IsEventCooldown(name, source)
        if eventCooldown and eventCooldown:onCooldown() then
            return warn('Ignoring event', name, 'because of cooldown for source : '..source..'\n')
        end
        RegisterCooldown(name, cooldown)
    elseif cooldown and global then
        local eventCooldown = IsEventCooldown(name)
        if eventCooldown and eventCooldown:onCooldown() then
            return warn('Ignoring event : '..name, 'because of global cooldown'..'\n')
        end
        RegisterCooldown(name, cooldown, global)
    end
    cb(source, ...)
end

--- supv:on @ AddEventHandler
---@param name string
---@param cb fun(source: integer, ...: any)
---@param cooldown? number
function supv:on(name, cb, cooldown)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return end

    --if sl.debug then
    --    ---@todo: add debug log
    --end

    local eventHandler = function(token, ...)
        local eventCooldown = IsEventCooldown(name)
        if eventCooldown and eventCooldown:onCooldown() then
            return warn('Ignoring event : '..name, 'because of global cooldown'..'\n')
        end
        cb(...)
    end
    return AddEventHandler(self:hashEvent(name), eventHandler)
end

--- sl:onNet @ RegisterNetEvent
---@param name string
---@param cb fun(source: integer, ...: any)
---@param cooldown? number
---@param globa? boolean
function supv:onNet(name, cb, cooldown, global)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return RegisterNetEvent(self:hashEvent(name)) end

    local eventHandler = function(token, ...)
        return EventHandler(name, token, source, cb, cooldown, global, ...)
    end

    return RegisterNetEvent(self:hashEvent(name), eventHandler)
end

local TriggerClientEvent <const> = TriggerClientEvent

---@param name string
---@param source integer
---@param ... any
function supv:emitNet(name, source, ...) -- @ TriggerClientEvent
    if type(name) ~= 'string' then return end
    TriggerClientEvent(self:hashEvent(name, 'client'), source, ...)
end

---@param name string
---@param ... any
function supv:emit(name, ...) -- @ TriggerEvent
    if type(name) ~= 'string' then return end
    TriggerEvent(self:hashEvent(name), self.token, ...)
end