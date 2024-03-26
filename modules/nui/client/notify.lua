local Promise, IsNuiFocused <const>, hud = {}, IsNuiFocused, {}
local on <const> = require 'imports.on.client'
local SetScriptGfxAlign <const>, ResetScriptGfxAlign <const> = SetScriptGfxAlign, ResetScriptGfxAlign
local GetActiveScreenResolution <const>, GetAspectRatio <const> = GetActiveScreenResolution, GetAspectRatio
local IsRadarHidden <const>, IsBigmapActive <const>, SetBigmapActive <const> = IsRadarHidden, IsBigmapActive, SetBigmapActive

---@param key string
---@param value any
---@param force boolean
function hud:set(key, value, force)
    if not force and self[key] == value then return end

    self[key] = value
    SendNUIMessage({
        action = 'supv_core:hud:minimap',
        data = { name = key, value = value },
    })
end

local function MinimapToNui()
    SetScriptGfxAlign(('L'):byte(), ('B'):byte())
    local minimapTopX <const>, minimapTopY <const> = GetScriptGfxPosition(-0.00, 0.002 + (-0.188888))
    local minimapBottomX <const>, minimapBottomY <const> = GetScriptGfxPosition(-0.0045 + 0.145, 0.002)
    ResetScriptGfxAlign()
    local w <const>, h <const> = GetActiveScreenResolution()
    local base <const> = GetAspectRatio(true)
    local ratio <const> = (16/9) / base
    local x1 <const>, y1 <const> = w * minimapTopX, h * (minimapTopY + .01)
    local x2 <const>, y2 <const> = w * minimapBottomX, h * (minimapBottomY - .02)
    local minimapWidth <const>, minimapHeight <const> = x2 - x1, y2 - y1

    return {
        x = math.abs(x1),
        y = math.abs(y1),
        w = minimapWidth * ratio,
        h = minimapHeight,
    }
end

local function RefreshGfxToNui(force)
    local minimap <const> = MinimapToNui()
    for k, v in pairs(minimap) do
        if k == 'w' then
            local expanded <const> = IsBigmapActive()
            local hidden <const> = IsRadarHidden()
            if not hidden then
                hud:set(k, expanded and v * 1.5825 or v, force)
                hud:set('expanded', expanded, force)
            else
                hud:set(k, v, force)
                hud:set('expanded', false, force)
            end
        elseif k == 'h' then
            local hidden <const> = IsRadarHidden()
            local expanded <const> = IsBigmapActive()
            if not expanded then
                hud:set(k, hidden and (v - v) + 16 or v, force)
            else
                if hidden then
                    hud:set(k, hidden and (v - v) + 16 or v, force)
                else
                    hud:set(k, v * 2.5825, force)
                end
            end
        else
            hud:set(k, v, force)
        end
    end
end

_ENV.RefreshGfxToNui = RefreshGfxToNui

---@class DataPropsNotify
---@field id? string
---@field title? string
---@field description? string
---@field type? string
---@field style? table
---@field position? string | 'top-right' | 'bottom-right' | 'minimap'

---@param select string | 'simple' | 'advanced'
---@param data DataPropsNotify
local function notify(select, data)
    if not data.position then data.position = 'minimap' end

    if data.type == 'action' and supv.service == 'server' then
        return warn('You can\'t use action type in server side!')
    end
    
    data.key = data.type == 'action' and #Promise+1

    if select == 'simple' then
        if data.key then
            if data.position == 'minimap' then
                RefreshGfxToNui()
            end

            supv.sendReactMessage(true, {
                action = 'supv:notification:send',
                data = data
            }, {
                focus = not IsNuiFocused() and { true, false } or 'ignore',
                keepInput = true,
            })
            Promise[data.key] = promise.new()
            return supv.await(Promise[data.key])
        else
            if data.position == 'minimap' then
                RefreshGfxToNui()
            end

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

supv.notify = notify

function supv.notifyQueue()
    return next(Promise) and true or false
end

require 'modules.nui.client.action'

on.net('notify', notify) -- Register notify event for server
--[[]

local toggle = {
    ex = false,
    hide = false,
}
RegisterCommand('min', function()
    toggle.hide = not toggle.hide
    DisplayRadar(not toggle.hide)
end)
RegisterCommand('minex', function()
    toggle.ex = not toggle.ex
    SetBigmapActive(toggle.ex, false)
end)

RegisterCommand('notify', function()
    -- supv.notify('simple', {
    --     title = 'action 1',
    --     description = 'Mon teste action 1!',
    --     type = 'action',
    -- })

    -- Wait(300)

    -- supv.notify('simple', {
    --     title = 'action 2',
    --     description = 'Mon teste action 2!',
    --     type = 'action',
    -- })

    -- CreateThread(function()
    --     supv.openModal('confirm', {
    --         title = 'Confirmation',
    --         description = 'Voulez-vous vraiment faire ça?',
    --     })   
    -- end)

    -- supv.notify('simple', {
    --     title = 'action 3',
    --     description = 'Mon teste action 3!',
    --     type = 'action',
    -- })
    -- supv.notify('simple', {
    --     title = 'action 2',
    --     description = 'Mon teste action 2!',
    --     type = 'action',
    -- })
    -- supv.notify('simple', {
    --     title = 'action 2',
    --     description = 'Mon teste action 2!',
    --     type = 'action',
    -- })
    -- supv.notify('simple', {
    --     title = 'action 2',
    --     description = 'Mon teste action 2!',
    --     type = 'action',
    -- })
    -- supv.notify('simple', {
    --     title = 'action 2',
    --     description = 'Mon teste action 2!',
    --     type = 'action',
    -- })
    -- supv.notify('simple', {
    --     title = 'action 2',
    --     description = 'Mon teste action 2!',
    --     type = 'action',
    -- })

    supv.notify('simple', {
        title = 'Sans type normal',
        description = 'Mon teste sans type!',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    Wait(3000)

    supv.notify('simple', {
        title = 'Warning',
        description = 'Mon teste warn!',
        type = 'warning',
        -- style = {
        --     background= 'linear-gradient(135deg, rgba(8, 25, 56, 0.94) 50%, rgba(11, 42, 100, 0.86) 100%)',
        -- },
    })

    supv.notify('simple', {
        title = 'Loading',
        description = 'Mon teste loading! sqdqsd sq dqsdqsd qsdqs dqsdsqdqsdqsdqsdqsdqsdqsd',
        type = 'loading',
        duration = 7500,
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
end)
--]]