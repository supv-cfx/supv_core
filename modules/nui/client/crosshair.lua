local isToolOpen, isVisible

function supv.openCrosshairTool(bool)    
    if type(bool) ~= 'boolean' then return end
    isToolOpen = bool

    supv.sendReactMessage(true, {
        action = 'supv_core:crosshairtool:visible',
        data = isToolOpen
    }, bool and {
        focus = true,
        locations = 'center'
    })

    if not bool then
        supv.resetFocus()
    end
end

supv.registerReactCallback('supv_core:crosshair:save', function(data, cb)
    TriggerEvent('supv_core:crosshair:save', data)
    cb(1)
end)

supv.registerReactCallback('supv_core:crosshairtool:close', function(data, cb)
    supv.resetFocus()
    cb(1)
end)

function supv.setCrosshairVisible(bool)
    if type(bool) ~= 'boolean' then return end
    isVisible = bool

    supv.sendReactMessage(nil, {
        action = 'supv_core:crosshair:visible',
        data = isVisible
    })
end

function supv.setCrosshairData(data)
    if type(data) ~= 'table' then return end

    supv.sendReactMessage(nil, {
        action = 'supv_core:crosshair:setter',
        data = data
    })
end