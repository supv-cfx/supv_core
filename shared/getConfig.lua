local cfg = {}

---@param key string
---@return table
function supv.getConfig(key)
    if not cfg[key] then
        local module = ("%s.config.%s"):format(supv.service, key)
        cfg[key] = require(module)
    end
    return cfg[key]
end