local notify <const> = require 'client.config.notify'
local nui <const> = require 'client.modules.nui'

if notify.type == 'react' then
    nui.RegisterReactCallback('supv:react:getConfig', function(data, cb)
        cb({
            notificationStyles = json.decode(notify.react.notificationStyles),
        })
    end)
end