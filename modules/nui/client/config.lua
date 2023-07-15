---@todo: more implementation about config interface from .cfg file

-- local p <const> = require 'imports.promise.shared'
local config <const> = {
    notificationStyles = json.decode(GetConvar('supv_core:interface:notification:simple', ''))
}

supv.registerReactCallback('supv:react:getConfig', function(data, cb)
    Wait(500)
    supv.notify('simple', {
        id = 'init_nui',
        type = 'success',
        description = 'supv interface initialized',
    })
end)

--[[
p.new(function(resolve, reject)
    local playerId = cache.playerid('playerid')
    while not playerId do
        playerId = cache.playerid
        Wait(500)
    end
    resolve()
end):Then(function(result)
    supv.sendReactMessage(false, {
        action = 'supv:react:getConfig',
        data = config
    })
end) ]]