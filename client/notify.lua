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
    local count = 0
    local queu = {}

    local function Notify(select, data)
        if count >= notif.react.maxNotification then
            queu[#queu+1] = {
                select = select,
                data = data
            }
            return
        end
    
        count += 1
    
        if select == 'simple' then
            ---@todo visible?: true but useless for this notification remove visible from nui (client\modules\nui.lua) and this file (client\modules\notify_react.lua) 
            print('here')
            nui.SendReactMessage(true,{
                action = 'supv:notification:send',
                data = data
            })
        elseif select == 'advanced' then
            ---@todo
        end 
    end
    
    ---@param cb fun(data: queueId, cb: fun(...: any))
    nui.RegisterReactCallback('supv:notification:removeQueue', function(data, cb)
        count -= 1
        if count < notif.react.maxNotification and #queu > 0 then
            local queuData = queu[1]
            table.remove(queu, 1)
            Notify(queuData.select, queuData.data)
        end
        cb(1)
    end)

    function supv.notify(...)
        Notify(...)
    end

    supv.eventRegister('supv_core:notify', Notify)
end