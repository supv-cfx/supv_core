local notif <const> = require 'client.config.notify'
local notify = supv.require.get[('client.modules.notify_%s'):format(notif.type)]

function supv.notify(...)
    if not notify then
        notify = require(('client.modules.notify_%s'):format(notif.type))
        RegisterNetEvent('supv_core:notify', function(...)
            notify(...)
        end)
    end
    notify(...)
end