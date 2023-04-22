local supv_core <const> = 'supv_core'
local LoadResourceFile <const>, IsDuplicityVersion <const> = LoadResourceFile, IsDuplicityVersion
local service <const> = (IsDuplicityVersion() and 'server') or 'client'
local GetGameName <const> = GetGameName
local GetCurrentResourceName <const> = GetCurrentResourceName

local function load_module(self, index)
    local dir <const> = ("imports/%s"):format(index)
    local chunk <const> = LoadResourceFile(supv_core, ('%s/%s.lua'):format(dir, service))
    local shared <const> = LoadResourceFile(supv_core, ('%s/shared.lua'):format(dir))
    local func, err
    
    if chunk or shared then
        if shared then
            func, err = load(shared, ('@@%s/%s/%s'):format(supv_core, index, 'shared'))
        else
            func, err = load(chunk, ('@@%s/%s/%s'):format(supv_core, index, service))
        end

        if not func or err then return error(("Erreur pendant le chargement du module\n- Provenant de : %s\n- Modules : %s\n- Service : %s\n - Erreur : %s"):format(dir, index, service, err), 3) end

        local result = func()
        self[index] = result
        return self[index]
    end
end

local function call_module(self, index, ...)
    local module = rawget(self, index)

    if not module then
        module = load_module(self, index)
        return module
    end
end

supv = setmetatable({
    service = service, 
    name = GetCurrentResourceName(),
    game = GetGameName(),
    env = GetCurrentResourceName(),
    lang = GetConvar('supv:locale', 'fr')
}, {
    __index = call_module, 
    __call = call_module, 
    __newindex = function(self, name, func)
    rawset(self, name, func)
    exports(name, func)
end})

require = supv.require.load

supv.locale.init()

if supv.service == 'server' then
    supv.version.check('github', nil, 500)
end