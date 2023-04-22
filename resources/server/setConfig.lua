local config <const> = Config

RegisterNetEvent('supv_core:insert:config-server', function(cb)
    return cb(config)
end)