local data = {} ---@type { [string]: string}

---@param str string
---@param ... any
---@return string
function translate(str, ...)
    local _t = data[str]
    if _t then
        if ... then
            return _t:format(...)
        end

        return _t
    end
    return str
end

--- supv.locale.init
local function Initialize()
    local env = supv.json.load(('locales/%s'):format(supv.lang))
    if not env then
       return warn(("Impossible de chargé locales/%s.json dans l'environnement : %s"):format(supv.lang, supv.env))
    end

    for k, v in pairs(env) do
        if not data[k] then
            if type(v) == 'string' then
                for var in v:gmatch('${[%w%s%p]-}') do -- credit: ox_lib <https://github.com/overextended/ox_lib/blob/master/imports/locale/shared.lua>
                    local locale = env[var:sub(3, -2)]

                    if locale then
                        locale = locale:gsub('%%', '%%%%')
                        v = v:gsub(var, locale)
                    end
                end
            end
            data[k] = v
        end
    end
end

--- supv.locale.get
---@param key? string
---@return table|string
local function GetInitialized(key)
    return data[key] or data
end

--- supv.locale.load ( example : supv.locale.load('es_extended', 'locales.en', 'lua') | supv.locale.load('supv_core', 'locales.en', 'json') )
---@param resource string
---@param path string
---@param ext string
local function LoadExternal(resource, path, ext)
    local filePath, folder, result = path, resource
    filePath = filePath:gsub('%.', '/')

    if ext == 'lua' then
        local import = LoadResourceFile(folder, filePath)
        local func, err = load(import, ('@@%s/%s/%s.lua'):format(folder, filePath))
        if not func or err then
            return error(err or ("unable to load module '%s/%s.lua'"):format(folder, filePath), 3)
        end

        result = func()
    elseif ext == 'json' then
        filePath = filePath:gsub('%.json', '')
        result = supv.json.load(filePath, folder)
    end

    if type(result) ~= 'table' then
        return error(("Le fichier '%s/%s' ne retourne pas une table"):format(folder, filePath), 2)
    end

    for k, v in pairs(result) do
        if not data[k] then
            if type(v) == 'string' then
                for var in v:gmatch('${[%w%s%p]-}') do -- credit: ox_lib <https://github.com/overextended/ox_lib/blob/master/imports/locale/shared.lua>
                    local locale = result[var:sub(3, -2)]

                    if locale then
                        locale = locale:gsub('%%', '%%%%')
                        v = v:gsub(var, locale)
                    end
                end
            end

            data[k] = v
        end
    end
end

return {
    init = Initialize,
    get = GetInitialized,
    load = LoadExternal,
}