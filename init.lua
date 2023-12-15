

local supv_core <const>, service <const> = 'supv_core', (IsDuplicityVersion() and 'server') or 'client'
local LoadResourceFile <const>, IsDuplicityVersion <const>, joaat <const>, await <const>, GetCurrentResourceName <const> = LoadResourceFile, IsDuplicityVersion, joaat, Citizen.Await, GetCurrentResourceName
local GetGameName <const> = GetGameName

---@param str string
---@return string
local function FormatByte(str)
    local binaryString = ""
    for i = 1, #str do
        local byte <const> = str:byte(i)
        local bits = {}
        for j = 7, 0, -1 do
            bits[#bits + 1] = (byte >> j) & 1
        end
        binaryString = binaryString .. table.concat(bits)
    end
    return binaryString
end

---@param name string
---@param from? string<'client' | 'server'> default is supv.service
---@return string
local function FormatEvent(self, name, from)
    return FormatByte(("%s%s"):format(from and joaat(from) or joaat(self.service), joaat(name)))
end

local supv = setmetatable({
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

local callback <const> = require(('imports.callback.%s'):format(service))

if service == 'server' then
    require('imports.version.server').check('github', nil, 500)
elseif service == 'client' then
    local cache = {}
    _ENV.cache = cache
end

_ENV.supv = supv
_ENV.callback = callback