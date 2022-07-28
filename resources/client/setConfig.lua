local config <const> = Config

RegisterNetEvent('supv_core:insert:config-client', function(cb)
    return cb(config)
end)