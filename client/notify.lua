local notif <const> = require 'client.config.notify'
local notify = supv.require.get[('client.modules.notify_%s'):format(notif.type)]

function supv.notify(...)
    if not notify then
        notify = require(('client.modules.notify_%s'):format(notif.type))
        supv.eventRegister('supv_core:notify', notify)
    end
    notify(...)
end