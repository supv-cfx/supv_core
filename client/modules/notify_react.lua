local config <const>, nui <const> = require 'client.config.notify', require 'client.modules.nui'

---@class notification_react_simple
---@field title? string
---@field description? string
---@field type? string 'info' | 'success' | 'warning' | 'error' | 'loading'
---@field color? string https://mantine.dev/theming/colors/#default-colors
---@field icon? string https://fontawesome.com/search?o=r&m=free
---@field duration? integer-3000
---@field position? string-top-right 'top-right' | 'top-left' | 'bottom-right' | 'bottom-left'
---@todo
---@field closable? boolean-false semi-implemented
---@field sound? string not implemented yet
---@field animation? string not implemented yet

local queu = {} ---@type array
local count = 0 ---@type integer

--- supv.notify
---@param select string
---@param data notification_react_simple
local function Notify(select, data)
    if count >= config.maxNotification then
        queu[#queu+1] = {
            select = select,
            data = data
        }
        return
    end

    count += 1

    if select == 'simple' then
        ---@todo visible?: true but useless for this notification remove visible from nui (client\modules\nui.lua) and this file (client\modules\notify_react.lua) 
        nui.SendReactMessage(true,{
            action = 'supv:notificiation:send',
            data = data
        })
    elseif select == 'advanced' then
        ---@todo
    end 
end

---@param cb fun(data: queueId, cb: fun(...: any))
nui.RegisterReactCallback('supv:notificiation:onRemove', function(_, cb)
    count -= 1
    if count < config.maxNotification and #queu > 0 then
        local queuData = queu[1]
        table.remove(queu, 1)
        Notify(queuData.select, queuData.data)
    end
    cb(1)
end)

return Notify