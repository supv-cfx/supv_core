local config <const> = Config

RegisterNetEvent('sublime_core:import:config', function(cb)
    return cb(config)
end)