local notif <const> = require 'client.config.notify'


if notif.type == 'native' then
    local notify <const> = require 'client.modules.notify_native'

    function supv.notify(...)
        print('supv.notify', ...)
        notify(...)
    end

    supv.eventRegister('supv_core:notify', notify)
elseif notif.type == 'react' then

    local nui <const> = require 'client.modules.nui'
    
    local function Notify(select, data)   
        if select == 'simple' then
            nui.SendReactMessage(true,{
                action = 'supv:notification:send',
                data = data
            })
        elseif select == 'advanced' then
            -- do something
        end 
    end
    
    -- nui.RegisterReactCallback('supv:notification:onCancel', function(data, cb)
    --     cb(1)
    -- end) -- not used for now
    
    function supv.notify(...)
        Notify(...)
    end

    supv.eventRegister('supv_core:notify', Notify)
end

