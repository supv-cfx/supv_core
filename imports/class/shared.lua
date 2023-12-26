local mt_pvt = {
    __metatable = 'private',
    __ext = 0,
    __pack = function() return '' end,
}

---@param obj table
---@return table
local function NewInstance(self, obj)
    if obj.private then
        setmetatable(obj.private, mt_pvt)
    end

    setmetatable(obj, self)

    if self.Init then obj:Init() end

    if obj.export then
        self.__export[obj.export] = obj
    end

    return obj
end

---@param name string
---@param super? table
---@param exportMethod? boolean
---@return table
function supv.class(name, super, exportMethod)
    local self = {
        __name = name,
        New = NewInstance
    }

    self.__index = self

    if exportMethod and not super then
        self.__exportMethod = {}
        self.__export = {}

        setmetatable(self, {
            __newindex = function(_, key, value)
                rawset(_, key, value)
                self.__exportMethod[key] = true
            end
        })

        exports('GetExportMethod', function()
            return self.__exportMethod
        end)

        exports('CallExportMethod', function(name, method, ...)
            local export <const> = self.__export[name]
            return export[method](export, ...)
        end)
    end
    
    return super and setmetatable(self, {
        __index = super,
        __newindex = function(_, key, value)
            rawset(_, key, value)
            if type(value) == 'function' then
                self.__exportMethod[key] = true
            end
        end
    }) or self
end

return supv.class