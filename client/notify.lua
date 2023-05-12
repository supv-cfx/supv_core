local notif <const> = require 'client.config.notify'

if notif.type == 'native' then
    local notify <const> = require 'client.modules.notify_native'

    function supv.notify(...)
        print('supv.notify', ...)
        notify(...)
    end

    --supv.eventRegister('supv_core:notify', notify)
elseif notif.type == 'react' then

    local nui <const> = require 'client.modules.nui'
    
    local function Notify(select, data)
        if select == 'simple' then
            if not data.position then data.position = 'top-right' end
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

    supv.onNet('notify', Notify, 1000)
end

--[[ some teste
RegisterCommand('test', function()
    print('ok')
end)


RegisterKeyMapping('+test', 'test', 'keyboard', 'x')
local h = ('%s'):format(joaat('+test') | 0x80000000)
--local controlValue = GetControlNormal(0, controlIndex) -- récupère la valeur de contrôle pour la touche "F
--local Control = GetControlValue(0, controlValue) -- récupère la valeur de contrôle pour la touche "F

print(GetControlInstructionalButton(0 , h, true):sub(3), '112')
]]