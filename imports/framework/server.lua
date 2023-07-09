local GetResourceState <const> = GetResourceState
local core <const> = (GetResourceState('es_extended') ~= 'missing' and 'esx') or (GetResourceState('qb-core') ~= 'missing' and 'qbcore')

local function import(framework)
    local file <const> = ('imports/framework/%s/server.lua'):format(framework)
    local chunk, err = load(LoadResourceFile('supv_core', file), ('@@supv_core/%s'):format(file))

    if err or not chunk then
        error(err or ("Unable to load file of framework '%s'"):format(file))
    end

    return chunk()
end

if core then
   return import(core) 
end