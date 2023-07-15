local LoadResourceFile <const> = LoadResourceFile

local function import(inventory)
    local file <const> = ('imports/inventory/%s/server.lua'):format(inventory)
    local chunk, err = load(LoadResourceFile('supv_core', file), ('@@supv_core/%s'):format(file))

    if err or not chunk then
        error(err or ("Unable to load file of inventory '%s'"):format(file))
    end

    return chunk()
end

if supv.useInventory then
    return import(supv.useInventory) 
end