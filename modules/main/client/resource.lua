local opened = false

supv:onNet('open:rm', function(menu)
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
    supv:emitNet('rm:edit', data)
    cb(1)
end, false)

supv.registerReactCallback('supv:rm:close', function(data, cb)
    cb(1)
    opened = false
end, true)