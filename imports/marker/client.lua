

local default <const> = {
    m1 = supv.config.client.import.marker.m1,
    m2 = supv.config.client.import.marker.m2
}

local DrawMarker <const> = DrawMarker

local function Simple(coords, params)

    local args = {}

    args.visible = params?.visible or true
    args.id = params?.id or default.m1.id
    args.color1 =  params?.color1 or default.m1.color1
    args.dir =  params?.dir or default.m1.dir
    args.rot =  params?.rot or default.m1.rot
    args.scale =  params?.scale or default.m1.scale
    args.updown =  params?.updown or default.m1.updown
    args.faceToCam =  params?.faceToCam or default.m1.faceToCam
    args.p19 =  params?.p19 or default.m1.p19
    args.textureDict =  params?.textureDict or default.m1.textureDict
    args.textureName =  params?.textureName or default.m1.textureName
    args.drawOnEnts =  params?.drawOnEnts or default.m1.drawOnEnts
    args.z =  params?.z or default.m1.z
    args.op =  params?.op or default.m1.op
    args.rotate = params?.rotate or default.m1.rotate

    local z = (coords.z + args.z)

    if args.textureDict and args.textureName and not HasStreamedTextureDictLoaded(args.textureDict) then
        RequestStreamedTextureDict(args.textureDict, true)
        while not HasStreamedTextureDictLoaded(args.textureDict) do
            Wait(1)
        end
    end

    if args.visible then
        DrawMarker(args.id, coords.x, coords.y, z, args.dir[1], args.dir[2], args.dir[3], args.rot[1], args.rot[2], args.rot[3], args.scale[1], args.scale[2], args.scale[3], args.color1[1], args.color1[2], args.color1[3], args.color1[4], args.updown, args.faceToCam, args.p19, args.rotate, args.textureDict, args.textureName, args.drawOnEnts)
    end
end

local function Advanced(double, inside, coords, m1, m2)
    local p1, p2 = {}, {}

    p1.visible = m1?.visible or default.m1.visible
    p1.id = m1?.id or default.m1.id
    p1.color1 = m1?.color1 or default.m1.color1
    p1.color2 = m1?.color2 or default.m1.color2
    p1.dir = m1?.dir or default.m1.dir
    p1.rot = m1?.rot or default.m1.rot
    p1.scale = m1?.scale or default.m1.scale
    p1.updown = m1?.updown or default.m1.updown
    p1.faceToCam = m1?.faceToCam or default.m1.faceToCam
    p1.p19 = m1?.p19 or default.m1.p19
    p1.rotate = m1?.rotate or default.m1.rotate
    p1.textureDict = m1?.textureDict or default.m1.textureDict
    p1.textureName = m1?.textureName or default.m1.textureName
    p1.drawOnEnts = m1?.drawOnEnts or default.m1.drawOnEnts
    p1.z = m1?.z or default.m1.z
    p1.op = m1?.op or default.m1.op

    p2.visible = m2?.visible or default.m2.visible
    p2.id = m2?.id or default.m2.id
    p2.color1 = m2?.color1 or default.m2.color1
    p2.color2 = m2?.color2 or default.m2.color2
    p2.dir = m2?.dir or default.m2.dir
    p2.rot = m2?.rot or default.m2.rot
    p2.scale = m2?.scale or default.m2.scale
    p2.updown = m2?.updown or default.m2.updown
    p2.faceToCam = m2?.faceToCam or default.m2.faceToCam
    p2.p19 = m2?.p19 or default.m2.p19
    p2.rotate = m2?.rotate or default.m2.rotate
    p2.textureDict = m2?.textureDict or default.m2.textureDict
    p2.textureName = m2?.textureName or default.m2.textureName
    p2.drawOnEnts = m2?.drawOnEnts or default.m2.drawOnEnts
    p2.z = m2?.z or default.m2.z
    p2.op = m2?.op or default.m2.op

    local z1 = (coords.z + p1.z)
    local z2 = (coords.z + p2.z)

    if p1.textureDict and p1.textureName and not HasStreamedTextureDictLoaded(p1.textureDict) then
        RequestStreamedTextureDict(p1.textureDict, true)
        while not HasStreamedTextureDictLoaded(p1.textureDict) do
            Wait(1)
        end
    end

    if p2.textureDict and p2.textureName and not HasStreamedTextureDictLoaded(p2.textureDict) then
        RequestStreamedTextureDict(p2.textureDict, true)
        while not HasStreamedTextureDictLoaded(p2.textureDict) do
            Wait(1)
        end
    end

    local color1, color2

    if inside then 
        color1 = p1.color1
        color2 = p2.color1
    else
        color1 = p1.color2
        color2 = p2.color2
    end

    if p1.visible then
        DrawMarker(p1.id, coords.x, coords.y, z1, p1.dir[1], p1.dir[2], p1.dir[3], p1.rot[1], p1.rot[2], p1.rot[3], p1.scale[1], p1.scale[2], p1.scale[3], color1[1], color1[2], color1[3], color1[4], p1.updown, p1.faceToCam, p1.p19, p1.rotate, p1.textureDict, p1.textureName, p1.drawOnEnts)
    end

    if p2.visible then
        DrawMarker(p2.id, coords.x, coords.y, z2, p2.dir[1], p2.dir[2], p2.dir[3], p2.rot[1], p2.rot[2], p2.rot[3], p2.scale[1], p2.scale[2], p2.scale[3], color2[1], color2[2], color2[3], color2[4], p2.updown, p2.faceToCam, p2.p19, p2.rotate, p2.textureDict, p2.textureName, p2.drawOnEnts)
    end
end

return {
    advanced = Advanced,
    simple = Simple
}