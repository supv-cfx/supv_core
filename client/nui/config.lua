local notify <const> = require 'client.config.notify'
local nui <const> = require 'client.modules.nui'

if notify.type == 'react' then
    print(json.decode(json.encode(notify.react.notificationStyles, {indent = true})))
    nui.RegisterReactCallback('supv:react:getConfig', function(data, cb)
        cb({
            notificationStyles = json.decode(notify.react.notificationStyles),
        })
    end)
end