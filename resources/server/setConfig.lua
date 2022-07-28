local c = {}
c.server = Config
c.shared = Shared

local config <const> = c

RegisterNetEvent('sublime_core:import:config', function(cb)
    return cb(config)
end)