

local supv_core <const>, service <const> = 'supv_core', (IsDuplicityVersion() and 'server') or 'client'
local LoadResourceFile <const>, IsDuplicityVersion <const>, joaat <const>, await <const>, GetCurrentResourceName <const> = LoadResourceFile, IsDuplicityVersion, joaat, Citizen.Await, GetCurrentResourceName
local GetGameName <const> = GetGameName

---@param name string
---@param from? string<'client' | 'server'> default is sl.service
---@return string
local function FormatEvent(self, name, from)
    return ("__sl__:%s:%s"):format(from or self.service, joaat(name))
end

supv = setmetatable({
    service = service, ---@type string<'client' | 'server'>
    name = supv_core, ---@type string<'supv_core'>
    env = supv_core, ---@type string<'resource_name?'>
    game = GetGameName(), ---@type string<'fivem' | 'redm'>
    hashEvent = FormatEvent,
    await = await,
    lang = GetConvar('supv:locale', 'fr') ---@type string<'fr' | 'en' | unknown>
}, {
    __newindex = function(self, name, value)
        rawset(self, name, value)
        if type(value) == 'function' then
            exports(name, value)
        end
    end
})

local loaded = {}
package = {
    loaded = setmetatable({}, {
        __index = loaded,
        __newindex = function() end,
        __metatable = false,
    }),
    path = './?.lua;'
}

local _require = require
function require(modname)

    local module = loaded[modname]
    if not module then
        if module == false then
            error(("^1circular-dependency occurred when loading module '%s'^0"):format(modname), 2)
        end

        local success, result = pcall(_require, modname)

        if success then
            loaded[modname] = result
            return result
        end

        local modpath = modname:gsub('%.', '/')
        local paths = { string.strsplit(';', package.path) }
        for i = 1, #paths do
            local scriptPath = paths[i]:gsub('%?', modpath):gsub('%.+%/+', '')
            local resourceFile = LoadResourceFile(supv_core, scriptPath)
            if resourceFile then
                loaded[modname] = false
                scriptPath = ('@@%s/%s'):format(supv_core, scriptPath)

                local chunk, err = load(resourceFile, scriptPath)

                if err or not chunk then
                    loaded[modname] = nil
                    return error(err or ("unable to load module '%s'"):format(modname), 3)
                end
                
                module = chunk(modname) or true
                loaded[modname] = module

                return module
            end
        end

        return error(("module '%s' not found"):format(modname), 2)
    end

    return module
end