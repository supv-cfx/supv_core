---@class MarkerDataProps
---@field id? integer
---@field color1? table
---@field color2? table
---@field dir? vector3
---@field rot? vector3
---@field scale? vector3
---@field updown? boolean
---@field faceToCam? boolean
---@field p19? integer
---@field textureDict? string
---@field textureName? string
---@field drawOnEnts? boolean
---@field z? number
---@field op? integer
---@field rotate? boolean

---@class MarkerOptionProps
---@field visible? boolean-true
---@field double? boolean
---@field insible? boolean

local DrawMarker <const>, HasStreamedTextureDictLoaded <const>, RequestStreamedTextureDict <const> = DrawMarker, HasStreamedTextureDictLoaded, RequestStreamedTextureDict
local default <const> = require '@supv_core.config.client.marker'
--- supv.marker.draw
---@param coords vec3
---@param data? MarkerDataProps
---@param options? MarkerOptionProps
function supv.drawMarker(coords, data, options)
    local p1, p2, visible = {}, options?.double and {} or default.double, options?.visible or true
    --p1.visible = data?[1]?.visible or true ---@deprecated
    p1.id = data?[1]?.id or default[1].id
    p1.color1 = data?[1]?.color1 or default[1].color1
    p1.color2 = data?[1]?.color2 or default[1].color2
    p1.dir = data?[1]?.dir or default[1].dir
    p1.rot = data?[1]?.rot or default[1].rot
    p1.scale = data?[1]?.scale or default[1].scale
    p1.updown = data?[1]?.updown or default[1].updown
    p1.faceToCam = data?[1]?.faceToCam or default[1].faceToCam
    p1.p19 = data?[1]?.p19 or default[1].p19
    p1.textureDict = data?[1]?.textureDict or default[1].textureDict
    p1.textureName = data?[1]?.textureName or default[1].textureName
    p1.drawOnEnts = data?[1]?.drawOnEnts or default[1].drawOnEnts
    p1.z = data?[1]?.z or default[1].z
    p1.op = data?[1]?.op or default[1].op
    p1.rotate = data?[1]?.rotate or default[1].rotate

    if p2 then
        --p2.visible = data?[2]?.visible or true ---@deprecated
        p2.id = data?[2]?.id or default[2].id
        p2.color1 = data?[2]?.color1 or default[2].color1
        p2.color2 = data?[2]?.color2 or default[2].color2
        p2.dir = data?[2]?.dir or default[2].dir
        p2.rot = data?[2]?.rot or default[2].rot
        p2.scale = data?[2]?.scale or default[2].scale
        p2.updown = data?[2]?.updown or default[2].updown
        p2.faceToCam = data?[2]?.faceToCam or default[2].faceToCam
        p2.p19 = data?[2]?.p19 or default[2].p19
        p2.textureDict = data?[2]?.textureDict or default[2].textureDict
        p2.textureName = data?[2]?.textureName or default[2].textureName
        p2.drawOnEnts = data?[2]?.drawOnEnts or default[2].drawOnEnts
        p2.z = data?[2]?.z or default[2].z
        p2.op = data?[2]?.op or default[2].op
        p2.rotate = data?[2]?.rotate or default[2].rotate
    end

    if p1.textureDict and p1.textureName and not HasStreamedTextureDictLoaded(p1.textureDict) then
        RequestStreamedTextureDict(p1.textureDict, true)
        while not HasStreamedTextureDictLoaded(p1.textureDict) do
            Wait(1)
        end
    end

    if p2 then
        if p2.textureDict and p2.textureName and not HasStreamedTextureDictLoaded(p2.textureDict) then
            RequestStreamedTextureDict(p2.textureDict, true)
            while not HasStreamedTextureDictLoaded(p2.textureDict) do
                Wait(1)
            end
        end
    end

    local z1, z2, color1, color2 = (p1.z + coords.z), p2 and (p2.z + coords.z)

    if options?.inside then
        color1 = p1.color1
        color2 = p2 and p2.color1
    else
        color1 = p1.color2
        color2 = p2 and p2.color2
    end
    
    if visible then
        DrawMarker(p1.id, coords.x, coords.y, z1, p1.dir.x, p1.dir.y, p1.dir.z, p1.rot.x, p1.rot.y, p1.rot.z, p1.scale.x, p1.scale.y, p1.scale.z, color1[1], color1[2], color1[3], color1[4], p1.updown, p1.faceToCam, p1.p19, p1.rotate, p1.textureDict, p1.textureName, p1.drawOnEnts)
        if p2 then
            DrawMarker(p2.id, coords.x, coords.y, z2, p2.dir.x, p2.dir.y, p2.dir.z, p2.rot.x, p2.rot.y, p2.rot.z, p2.scale.x, p2.scale.y, p2.scale.z, color2[1], color2[2], color2[3], color2[4], p2.updown, p2.faceToCam, p2.p19, p2.rotate, p2.textureDict, p2.textureName, p2.drawOnEnts)
        end
    end
end

return supv.drawMarker