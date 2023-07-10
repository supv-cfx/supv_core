local loadjson <const> = require 'imports.json.client'.load
local marker = loadjson('data/client/marker')

marker[1], marker[2] = marker["1"], marker["2"] 
marker["1"], marker["2"] = nil, nil

return marker

--[[
return { -- https://docs.fivem.net/natives/?_0x28477EC23D892089
    double = false, -- double default

    -- marker 1 default value
    [1] = {
        id = 27,
        z = -0.99,
        color1 = {6, 34, 86, 100}, -- default or inside color
        color2 = {255, 255, 255, 100}, -- optional and outside color
        dir = vec3(0.0, 0.0, 0.0), --{0.0,0.0,0.0},
        rot = vec3(0.0, 0.0, 0.0),
        scale = vec3(2.0, 2.0, 2.0),
        updown = false,
        faceToCam = false,
        p19 = 2,
        rotate = false,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false
    },

    -- marker 2 (optional) default value
    [2] = {
        id = 20,
        z = 0.5,
        color1 = {6, 34, 86, 100}, -- default or inside color
        color2 = {255, 255, 255, 100}, -- optional and outside color
        dir = vec3(0.0, 0.0, 0.0),
        rot = vec3(0.0, 180.0, 0.0),
        scale = vec3(0.5, 0.5, 0.2),
        updown = false,
        faceToCam = false,
        p19 = 2,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false
    }
}
]]