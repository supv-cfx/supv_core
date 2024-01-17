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

return {
    set = Set,
    clear = Clear,
}