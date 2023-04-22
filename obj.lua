local supv_core <const> = 'supv_core'
local IsDuplicityVersion <const> = IsDuplicityVersion
local LoadResourceFile <const> = LoadResourceFile
local GetResourceState <const> = GetResourceState
local GetGameName <const> = GetGameName
local GetCurrentResourceName <const> = GetCurrentResourceName
local export = exports[supv_core]

local service <const> = (IsDuplicityVersion() and 'server') or (not IsDuplicityVersion() and 'client')

if not _VERSION:find('5.4') then
    error("^1 Vous devez activer Lua 5.4 dans la resources où vous utilisez l'import, (lua54 'yes') dans votre fxmanifest!^0", 2)
end

if not GetResourceState(supv_core):find('start') then
	error('^1supv_core doit être lancé avant cette ressource!^0', 2)
end

local function load_module(self, index)
    local func, err 
    local dir <const> = ('imports/%s'):format(index)
    local chunk = LoadResourceFile(supv_core, ('%s/%s.lua'):format(dir, service))
    local shared = LoadResourceFile(supv_core, ('%s/shared.lua'):format(dir))

    if shared then
        func, err = load(shared, ('@@%s/%s/%s'):format(supv_core, index, 'shared'))
    else
        func, err = load(chunk, ('@@%s/%s/%s'):format(supv_core, index, service))
    end
    
    if err then error(("Erreur pendant le chargement du module\n- Provenant de : %s\n- Modules : %s\n- Service : %s\n - Erreur : %s"):format(dir, index, service, err), 3) end

    local result = func()
    rawset(self, index, result)
    return self[index]
end

local function call_module(self, index, ...)
    local module = rawget(self, index)
    if not module then
        module = load_module(self, index)
        if not module then
            print(index, ...)
            local method = export[index](nil, ...)
            if not method then
                error(("Erreur en appelant le module (import/export)\n- Modules : %s\n- Service : %s"):format(index, service), 3)
            end
            self[index] = method
            return method
        end
    end
    return module
end

supv = setmetatable({
    name = supv_core, 
    service = service,
    game = GetGameName(),
    env = GetCurrentResourceName(),
    lang = GetConvar('supv:locale', 'fr'),
    cache = {},
    config = {}
},
{ 
    __index = call_module, 
    __call = call_module 
})

if supv.service == 'client' then
    setmetatable(supv.cache, {
        __index = function(self, key)
            AddEventHandler(('supv_core:cache:%s'):format(key), function(value)
                self[key] = value
            end)

            return rawset(self, key, export:getCache(key) or false)
        end
    })

    setmetatable(supv.config, {
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
    setmetatable(supv.config, {
        __index = function(self, key)
            local value = rawget(self, key)
            if not value then
                value = export:getConfig(key)
                rawset(self, key, value)
            end
            return value
        end
    })
end

if GetResourceState('ox_lib') ~= 'missing' then
    if lib then return end
end

require = supv.require.load