function supv.getConfig(key, shared)
    return require(("config.%s.%s"):format(not shared and supv.service or 'shared', key))
end

return {
    'handlers', -- init handlers server & client
    'main', -- init main server & client
    'nui', -- init nui server & client
}