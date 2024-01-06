local opened = false

on.net('open:rm', function(menu)
    if opened then return end

    if not next(menu) then
        return warn('No resources registered!')
    end

    supv.sendReactMessage(true, {
        action = 'supv:open:rm',
        data = menu
    }, {
        focus = true
    })

    opened = true
end)

supv.registerReactCallback('supv:rm:validate', function(data, cb)
    -- print(json.encode(data, { indent = true }))
    emit.net('rm:edit', data)
    cb(1)
end, false)

supv.registerReactCallback('supv:rm:action', function(data, cb)
    emit.net('rm:action', data)
    cb(1)
end)

supv.registerReactCallback('supv:rm:close', function(data, cb)
    opened = false
    cb(1)
end, true)