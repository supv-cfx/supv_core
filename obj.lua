local supv_core <const> = 'supv_core'
local GetConvar <const> = GetConvar
local IsDuplicityVersion <const> = IsDuplicityVersion
local LoadResourceFile <const> = LoadResourceFile
local GetResourceState <const> = GetResourceState
local GetGameName <const> = GetGameName
local GetCurrentResourceName <const> = GetCurrentResourceName
local Await <const> = Citizen.Await
local export <const> = exports[supv_core]
local service <const> = (IsDuplicityVersion() and 'server') or 'client'
local eventCaches = {}

if not _VERSION:find('5.4') then
    error("^1 Vous devez activer Lua 5.4 dans la resources où vous utilisez l'import, (lua54 'yes') dans votre fxmanifest!^0", 2)
end

if not GetResourceState(supv_core):find('start') then
	error('^1supv_core doit être lancé avant cette ressource!^0', 2)
end

local _settings = {
    framework = GetConvar('supv_core:auto_use:framework', 'true') == 'true',
    inventory = GetConvar('supv_core:auto_use:inventory', 'true') == 'true',
    mysql = GetConvar('supv_core:auto_use:mysql', 'true') == 'true',
}

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
    if eventCaches[name] then return eventCaches[name] end
    eventCaches[name] = FormatByte(("%s%s"):format(from and joaat(from) or joaat(service), joaat(name)))
    return eventCaches[name]
end

local function void() end
local function load_module(self, index)
    local func, err 
    local dir <const> = ('imports/%s'):format(index)
    local chunk <const> = LoadResourceFile(supv_core, ('%s/%s.lua'):format(dir, service))
    local shared <const> = LoadResourceFile(supv_core, ('%s/shared.lua'):format(dir))

    if chunk or shared then
        if shared then
            func, err = load(shared, ('@@%s/%s/%s'):format(supv_core, index, 'shared'))
        else
            func, err = load(chunk, ('@@%s/%s/%s'):format(supv_core, index, service))
        end
        
        if err then error(("Error to loading modules :\n- From : %s\n - Modules : %s\n - Service : %s\n - Error : %s"):format(dir, index, service, err), 3) end

        local result = func()
        rawset(self, index, result or void)
        return self[index]
    end
end

local function call_module(self, index, ...)
    local module = rawget(self, index)
    if not module then
        self[index] = void
        module = load_module(self, index)
        if not module then
            local function method(...)
                return export[index](nil, ...)
            end
            
            if not ... then
                self[index] = method
            end
            
            return method
        end
    end
    return module
end

local supv = setmetatable({
    name = supv_core, 
    service = service,
    game = GetGameName(),
    env = GetCurrentResourceName(),
    lang = GetConvar('supv:locale', 'fr'),
    cache = service == 'client' and {},
    await = Await,
    hashEvent = FormatEvent,
    useFramework = _settings.framework and ((GetResourceState('es_extended') ~= 'missing' and 'esx') or (GetResourceState('qb-core') ~= 'missing' and 'qbcore')),
    useInventory = _settings.inventory and ((GetResourceState('ox_inventory') ~= 'missing' and 'ox') or (GetResourceState('qb-inventory') ~= 'missing' and 'qbcore') or (GetResourceState('es_extended') ~= 'missing' and 'esx')),
    useMySQL = _settings.mysql and (GetResourceState('oxmysql') ~= 'missing' and true),
}, { 
    __index = call_module, 
    __call = call_module 
})

_ENV.supv = supv
_ENV.void = void

if supv.service == 'client' then
    setmetatable(supv.cache, {
        __index = function(self, key)
            AddEventHandler(('cache:%s'):format(key), function(value)
                self[key] = value
                return self[key]
            end)

            rawset(self, key, export:getCache(key) or false)
            return self[key]
        end
    })

    supv.config = setmetatable({}, {
        __index = function(self, key)
            local value = rawget(self, key)
            if not value then
                value = export:getConfig(key)
                rawset(self, key, value)
            end
            return value
        end
    })
elseif supv.service == 'server' then
    if supv.useMySQL then
        local MySQL = setmetatable({}, {
            __index = function(self, key)
                local value = rawget(self, key)
                if not value then
                    supv.mysql()
                    value = MySQL[key]
                end
                return value
            end
        })
        _ENV.MySQL = MySQL
    end
end

if supv.useFramework then
    local framework = setmetatable({}, {
        __index = function(self, key)
            local value = rawget(self, key)
            if not value then
                value = load_module(self, 'framework')[key]
                rawset(self, key, value)
            end
            return value
        end
    })

    _ENV.framework = framework
end

if supv.useInventory then
    local inventory = setmetatable({}, {
        __index = function(self, key)
            local value = rawget(self, key)
            if not value then
                value = load_module(self, 'inventory')[key]
                rawset(self, key, value)
            end
            return value
        end
    })

    _ENV.inventory = inventory
end

_settings = nil
if _ENV.lib then return end

-- credit: ox_lib <https://github.com/overextended/ox_lib/blob/master/init.lua>
local intervals = {}
---@param callback function | number
---@param interval? number
---@param ... any
local function SetInterval(callback, interval, ...)
	interval = interval or 0

    if type(interval) ~= 'number' then
        return error(('Interval must be a number. Received %s'):format(json.encode(interval --[[@as unknown]])))
    end

	local cbType = type(callback)

	if cbType == 'number' and intervals[callback] then
		intervals[callback] = interval or 0
		return
	end

    if cbType ~= 'function' then
        return error(('Callback must be a function. Received %s'):format(cbType))
    end

	local args, id = { ... }

	Citizen.CreateThreadNow(function(ref)
		id = ref
		intervals[id] = interval or 0
		repeat
			interval = intervals[id]
			Wait(interval)
			callback(table.unpack(args))
		until interval < 0
		intervals[id] = nil
	end)

	return id
end

---@param id number
local function ClearInterval(id)
    if type(id) ~= 'number' then
        return error(('Interval id must be a number. Received %s'):format(json.encode(id --[[@as unknown]])))
	end

    if not intervals[id] then
        return error(('No interval exists with id %s'):format(id))
	end

	intervals[id] = -1
end

require = supv.require

_ENV.SetInterval = SetInterval
_ENV.ClearInterval = ClearInterval