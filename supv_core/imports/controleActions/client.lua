local DisableControlAction <const> = DisableControlAction

local function Disable(self)
    if type(self.keys) == 'table' then
        for i = 1, #self.keys do
            DisableControlAction(0, self.keys[i], true)
        end
    else
        DisableControlAction(0, self.keys, true)
    end
end

local function Define(keys)
    local self = {}

    self.keys = keys
    self.disable = Disable
    
    return self
end


return {
    define = Define
}