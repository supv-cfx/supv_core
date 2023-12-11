local imported = {}

---@param path string @myRessouce.client.main
local function import(path)
    if type(path) ~= 'string' then return end
    if imported[path] then return imported[path] end
    if not path:find('^@') then return error(("unable to find module '%s'"):format(path), 3) end
    local rss, dir = path:gsub('%.', '/'):match('^(.-)/(.+)$')
    if not rss or not dir then return error('Invalid path format: '..path, 3) end

    rss, dir = rss:gsub('^@', ''), dir..'.lua'
    local func, err
    local chunk <const> = LoadResourceFile(rss, dir)
    if chunk then
        func, err = load(chunk, ('@@%s/%s'):format(rss, dir))
        if err then error("Error to load module", 3) end
        local result <const> = func()
        imported[path] = result or true
        return imported[path]
    end
end

return import