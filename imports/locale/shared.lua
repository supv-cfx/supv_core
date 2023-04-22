local data = {}

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

local function Initialize()
    local lang = GetConvar('supv:locale', 'fr')
    local env = supv.json.load(('locales/%s'):format(lang))
    if not env then
       return warn(("Impossible de chargé locales/%s.json dans l'environnement : %s"):format(lang, supv.env))
    end

    for k,v in pairs(env) do
        if type(v) == 'string' then
            data[k] = v
        end
    end
end

---@param key? string
---@return table|string
local function GetInitialized(key)
    return data[key] or data
end

return {
    init = Initialize,
    get = GetInitialized
}