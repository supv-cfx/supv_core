exports('load', function()
    local file = 'obj.lua'
    local import = LoadResourceFile(supv.name, file)
    local func, err = load(import, ('@@%s/%s'):format(supv.name, file))
    if not func or err then
        return error(err or ("unable to load module '%s'"):format(file), 3)
    end

    return func
end)