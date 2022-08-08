local supv_core <const> = 'supv_core'
local IsDuplicityVersion <const> = IsDuplicityVersion
local LoadResourceFile <const> = LoadResourceFile

local service <const> = (IsDuplicityVersion() and 'server') or (not IsDuplicityVersion() and 'client')


if not _VERSION:find('5.4') then
    error("^1 Vous devez activer Lua 5.4 dans la resources où vous utilisez l'import, (lua54 'yes') dans votre fxmanifest!^0", 2)
end

if not GetResourceState(supv_core):find('start') then
	error('^1supv_core doit être lancé avant cette ressource!^0', 2)
end

local function load_module(self, index)
    local dir <const> = ('imports/%s'):format(index)
    local chunk = LoadResourceFile(supv_core, ('%s/%s.lua'):format(dir, service))
    --print(index) -- décommente pour voir les modules appelées
    local func, err = load(chunk, ('@@%s/%s/%s'):format(supv_core, index, service))
    
    if err then error(("Erreur pendant le chargement du module\n- Provenant de : %s\n- Modules : %s\n- Service : %s\n - Erreur : %s"):format(dir, index, service, err), 3) end

    local result = func()
    rawset(self, index, result)
    return self[index]
end

local function call_module(self, index)
    local module = rawget(self, index)
    if not module then
        module = load_module(self, index)
        if not module then
            error(("Erreur en appelant le module\n- Modules : %s\n- Service : %s"):format(index, service), 3)
        end
    end
    return module
end

supv = setmetatable({name = supv_core, service = service, oncache = {}, config = {client = {}, server = {}}},{ __index = call_module, __call = call_module })

if service == 'client' then
    local PlayerPedId <const>, PlayerId <const>, GetPlayerServerId <const> = PlayerPedId, PlayerId, GetPlayerServerId
    RegisterNetEvent('supv_core:refresh:cache', function(cache)
        for k,v in pairs(cache)do
            supv.oncache[k] = v
        end
        supv.oncache.pedid = PlayerPedId()
        supv.oncache.playerid = PlayerId()
        supv.oncache.serverid = GetPlayerServerId(PlayerId())
        return supv.oncache
    end)
    TriggerEvent('supv_core:insert:config-client', function(cfg)
        for k,v in pairs(cfg) do
            supv.config.client[k] = v
        end
       return supv.config.client   
    end)
elseif service == 'server' then
    TriggerEvent('supv_core:insert:config-server', function(cfg)
        for k,v in pairs(cfg) do
            supv.config.server[k] = v
        end 
        return supv.config.server   
    end)
end