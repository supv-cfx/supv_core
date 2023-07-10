local RegisterNetEvent <const>, AddEventHandler <const>, TriggerEvent <const>, TriggerServerEvent <const>, joaat <const> = RegisterNetEvent, AddEventHandler, TriggerEvent, TriggerServerEvent, joaat
local timers, GetGameTimer <const>, tokenClient = {}, GetGameTimer

---@param name string
---@return table|false
---@private
local function IsEventCooldown(name)
    if timers[name] then
        return timers[name]
    end
    return false
end

---@return boolean
---@private
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
---@private
local function RegisterCooldown(name, timer)
    local self = {}
    
    self.time = GetGameTimer()
    self.cooldown = timer
    self.onCooldown = GetCooldown

    timers[name] = self
end

---@param name string
---@param cb fun(...: any)
---@param cooldown? number
---@public AddEventHandler
function supv:on(name, cb, cooldown)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return end

    if type(cooldown) == 'number' then
        RegisterCooldown(name, cooldown)
    end

    local function EventHandler(...)
        local eventCooldown = IsEventCooldown(name)
        if eventCooldown and eventCooldown:onCooldown() then
            return warn('Ignoring event', name, 'because of cooldown'..'\n')
        end
        cb(...)
    end

    return AddEventHandler(self:hashEvent(name), EventHandler)
end

---@param name string
---@param cb? fun(...: any)
---@param cooldown? number
---@public RegisterNetEvent
function supv:onNet(name, cb, cooldown)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return RegisterNetEvent(self:hashEvent(name)) end

    if type(cooldown) == 'number' then
        RegisterCooldown(name, cooldown)
    end

    local function EventHandler(...)
        local eventCooldown = IsEventCooldown(name)
        if eventCooldown and eventCooldown:onCooldown() then
            return warn('Ignoring event', name, 'because of cooldown'..'\n')
        end
        cb(...)
    end

    return RegisterNetEvent(self:hashEvent(name), EventHandler)
end

---@param name string
---@param ... any
---@public TriggerServerEvent
function supv:emitNet(name, ...)
    if not tokenClient then tokenClient = callback.sync(joaat('token')) end
    if type(name) ~= 'string' then return end
    TriggerServerEvent(self:hashEvent(name, 'server'), tokenClient, ...)
end

---@param name string
---@param ... any
---@public TriggerEvent
function supv:emit(name, ...)
    if type(name) ~= 'string' then return end
    TriggerEvent(self:hashEvent(name), ...)
end