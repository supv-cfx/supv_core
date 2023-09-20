local useModule = require 'config.shared.handlers'.blips

if not useModule then return end
useModule = nil

local blips = {}

function supv.CreateBlips(env, blipId, _type)
    if not blips[env] then
        blips[env] = {}
    end

    if not blips[env][blipId] then
        blips[env][blipId] = _type
    end
end

function supv.DeleteBlipsByType(_type)
    if not next(blips) then return end
    for env in pairs(blips) do
        for blipId, blipType in pairs(blips[env]) do
            if blipType == _type then
                blips[env][blipId] = nil
            end
        end
    end
end

function supv.DeleteBlips(env, blipId)
    if not blips[env] then return end
    if blipId then
        if blips[env][blipId] then
            blips[env][blipId] = nil
        end
    else
        blips[env] = nil
    end
end