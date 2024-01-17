local SetTimeout <const> = Citizen.SetTimeout
local Timeout = {}

---@param cb function
---@param time integer
---@return number
local function Set(cb, time)
    local id = #Timeout + 1
    
    SetTimeout(time, function()
        if not Timeout[id] then return end
        cb()
    end)

    Timeout[id] = true
    return id
end

---@param id number
local function Clear(id)
    if Timeout[id] then
        Timeout[id] = nil
    end
end

local function Play(self, newCb, newTime)
    if newCb then
        self.cb = newCb
    end

    if newTime then
        self.time = newTime
    end

    self.played = true
    SetTimeout(self.time, function()
        if not self.played then return end
        self.callback()
    end)
end

local function Cancel(self)
    if self.played then
        self.played = false
    end
end

local function Remove(self)
    Timeout[self.id] = nil
    return nil
end

---@param data { time: integer, callback: function }
---@return table
local function New(data)
    local self = {}

    self.id = #Timeout + 1
    self.time = data?.time or 1000
    self.callback = data?.callback or function() end
    self.played = false

    self.play = Play
    self.cancel = Cancel
    self.remove = Remove

    return self
end

return {
    new = New,
    set = Set,
    clear = Clear,
}

--[[

    Exemple : classic

    -- SetTimeout
    local timeout = supv.timeout.set(function()
        print('timeout passed after 10s')
    end, 10000)


    -- ClearTimeout
    supv.timeout.clear(timeout)

    Exemple : class

    local timeout = supv.timeout.new({
        time = 10000,
        callback = function()
            print('timeout passed after 10s')
        end
    })

    -- Play
    timeout:play()

    -- Play with new callback & timer
    timeout:play(function()
        print('timeout passed after 5s')
    end, 5000)

    -- Cancel
    timeout:cancel()

    -- Remove
    timeout = timeout:remove()
--]]