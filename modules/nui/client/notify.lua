local on <const> = require 'imports.on.client'

local function notify(select, data)
    if not data.position then data.position = 'top-right' end

    if select == 'simple' then
        supv.sendReactMessage(true,{
            action = 'supv:notification:send',
            data = data
        })
    end
end

supv.notify = notify -- Export notify function
on.net('notify', notify) -- Register notify event for server