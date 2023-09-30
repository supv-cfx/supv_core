local on <const> = require 'imports.on.client'
local Promise, IsNuiFocused <const> = {}, IsNuiFocused

---@class DataPropsNotify
---@field id? string
---@field title? string
---@field description? string
---@field type? string
---@field style? table
---@field position? string | 'top-right' | 'bottom-right'

---@param select string | 'simple' | 'advanced'
---@param data DataPropsNotify
local function notify(_, select, data)
    if not data.position then data.position = 'top-right' end

    if data.type == 'action' and supv.service == 'server' then
        return warn('You can\'t use action type in server side!')
    end
    
    data.key = data.type == 'action' and #Promise+1

    if select == 'simple' then
        if data.key then
            supv.sendReactMessage(true, {
                action = 'supv:notification:send',
                data = data
            }, {
                focus = not IsNuiFocused() and {true, false} or 'ignore',
                keepInput = true,
            })
            Promise[data.key] = promise.new()
            return supv.await(Promise[data.key])
        else
            supv.sendReactMessage(true, {
                action = 'supv:notification:send',
                data = data
            })
        end
    end
end

supv.registerReactCallback('supv:notify:response', function(data, cb)
    cb(1)
    if Promise[data.id] then Promise[data.id]:resolve(data.response) end
    Promise[data.id] = nil
end, true)

supv.notify = setmetatable({}, {
    __call = notify
})

function supv.notify.queue()
    return next(Promise) and true or false
end

on.net('notify', supv.notify) -- Register notify event for server

--[[RegisterCommand('notify', function()
    supv.notify('simple', {
        title = 'action 1',
        description = 'Mon teste action 1!',
        type = 'action',
    })

    Wait(300)

    supv.notify('simple', {
        title = 'action 2',
        description = 'Mon teste action 2!',
        type = 'action',
    })

    CreateThread(function()
        supv.openModal('confirm', {
            title = 'Confirmation',
            description = 'Voulez-vous vraiment faire ça?',
        })   
    end)

    supv.notify('simple', {
        title = 'action 3',
        description = 'Mon teste action 3!',
        type = 'action',
    })
    supv.notify('simple', {
        title = 'action 2',
        description = 'Mon teste action 2!',
        type = 'action',
    })
    supv.notify('simple', {
        title = 'action 2',
        description = 'Mon teste action 2!',
        type = 'action',
    })
    supv.notify('simple', {
        title = 'action 2',
        description = 'Mon teste action 2!',
        type = 'action',
    })
    supv.notify('simple', {
        title = 'action 2',
        description = 'Mon teste action 2!',
        type = 'action',
    })
    supv.notify('simple', {
        title = 'action 2',
        description = 'Mon teste action 2!',
        type = 'action',
    })

    supv.notify('simple', {
        title = 'Sans type normal',
        description = 'Mon teste sans type!',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    Wait(5000)

    supv.notify('simple', {
        title = 'Warning',
        description = 'Mon teste warn!',
        type = 'warning',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    Wait(300)

    supv.notify('simple', {
        title = 'Success',
        description = 'Mon test success',
        type = 'success',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    Wait(300)

    supv.notify('simple', {
        title = 'Error',
        description = 'Mon test error',
        type = 'error',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    Wait(300)

    supv.notify('simple', {
        title = 'Information',
        description = 'Mon test info',
        type = 'info',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })
end)]]