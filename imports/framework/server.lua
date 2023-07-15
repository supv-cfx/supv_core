local LoadResourceFile <const> = LoadResourceFile

local function import(framework)
    local file <const> = ('imports/framework/%s/server.lua'):format(framework)
    local chunk, err = load(LoadResourceFile('supv_core', file), ('@@supv_core/%s'):format(file))

    if err or not chunk then
        error(err or ("Unable to load file of framework '%s'"):format(file))
    end

    return chunk()
end

if supv.useFramework then
    return import(supv.useFramework) 
end