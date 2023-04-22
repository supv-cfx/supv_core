local cfg = {}

function supv.getConfig(key)
    if not cfg[key] then
        local module = ('client.config.%s'):format(key)
        cfg[key] = require ('%s'):format(module)
    end
    return cfg[key]
end

print(json.encode(supv.getCache('npc'), {indent=true}))