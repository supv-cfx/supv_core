local stock = {}
local DisableControlAction <const> = DisableControlAction


---@todo need finish this module

--- oop

local function Add(self, keys)
    if self.type == 'table' then
        for i = 1, #self.keys do
            local k = self.keys[i]

        end
    else return end
end

local function Remove(self, keys)
    if self.type == 'table' then

    else
        stock[self.id] = self:clear()
    end
end

local function Clear(self)
    if stock[self.id] then
        stock[self.id] = nil
        return nil, collectgarbage()
    end
end

local function Play(self)
    if self.type == 'table' then
        for i = 1, #self.keys do
            local v = self.keys[i]
            DisableControlAction(0, v, true)
        end
    else
        DisableControlAction(0, self.keys, true)
    end
end

local function Register(keys)
    local self = {}

    self.id = #stock + 1
    self.type = type(keys)
    
    if self.type == 'table' then
        if table.type(keys) ~= 'array' then return end
        self.keys = keys
        -- todo
    elseif self.type == 'number' then
        if math.type(keys) ~= 'integer' then return end
        self.keys = keys
        -- todo
    end

    self.remove = Remove
    self.add = Add
    self.clear = Clear
    self.play = Play

    stock[self.id] = self
    return self
end

--- not oop

-- todo
local function Disable(keys)
    if type(keys) == 'table' and table.type(keys) == 'array' then
        for i = 1, keys do
            local k = keys[i]
            DisableControlAction(0, k, true)
        end
    elseif type(keys) == 'number' and math.type(keys) == 'integer' then
        DisableControlAction(0, keys, true)
    else return end
end

return {
    -- oop
    new = Register,
    -- default
    disable = Disable
}