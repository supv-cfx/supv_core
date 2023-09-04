local on <const> = require 'imports.on.client'

---@class DataPropsNotify
---@field id? string
---@field title? string
---@field description? string
---@field type? string
---@field style? table
---@field position? string | 'top-right' | 'bottom-right'

---@param select string | 'simple' | 'advanced'
---@param data DataPropsNotify
local function notify(select, data)
    if not data.position then data.position = 'top-right' end

    if select == 'simple' then
        supv.sendReactMessage(true, {
            action = 'supv:notification:send',
            data = data
        })
    end
end

--[[
RegisterCommand('notify', function()
    notify('simple', {
        title = 'Sans type normal',
        description = 'Mon teste sans type!',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    Wait(300)

    notify('simple', {
        title = 'Warning',
        description = 'Mon teste warn!',
        type = 'warning',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    Wait(300)

    notify('simple', {
        title = 'Success',
        description = 'Mon test success',
        type = 'success',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    Wait(300)

    notify('simple', {
        title = 'Error',
        description = 'Mon test error',
        type = 'error',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    Wait(300)

    notify('simple', {
        title = 'Information',
        description = 'Mon test info',
        type = 'info',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })
end)]]

supv.notify = notify -- Export notify function
on.net('notify', notify) -- Register notify event for server