local mt_pvt = {
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
---@param prototype? table
---@param exportMethod? boolean
---@return table
function supv.class(name, prototype, exportMethod)
    local self = {
        __name = name,
        new = NewInstance
    }

    self.__index = self

    if exportMethod then
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

    return prototype and setmetatable(self, prototype) or self
end

return supv.class