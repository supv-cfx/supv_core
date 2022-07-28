

local default <const> = {
    m1 = supv.config.client.import.marker.m1,
    m2 = supv.config.client.import.marker.m2
}

local function Marker(double, inside, coords, params, params2)

    if double then
        
        local args = {}
        
        if params2 then
            args.id = params2.id or default.m2.id
            args.color = params2.color or default.m2.color
            args.dir = params2.dir or default.m2.dir
            args.rot = params2.rot or default.m2.rot
            args.scale = params2.scale or default.m2.scale
            args.updown = params2.updown or default.m2.updown
            args.faceToCam = params2.faceToCam or default.m2.faceToCam
            args.p19 = params2.p19 or default.m2.p19
            args.rotate = params2.rotate or default.m2.rotate
            args.textureDict = params2.textureDict or default.m2.textureDict
            args.textureName = params2.textureName or default.m2.textureName
            args.drawOnEnts = params2.drawOnEnts or default.m2.drawOnEnts
            args.z = params2.z or default.m2.z
            args.op = params2.op or default.m2.op
        else
            args.id = default.m2.id
            args.color = default.m2.color
            args.dir = default.m2.dir
            args.rot = default.m2.rot
            args.scale = default.m2.scale
            args.updown = default.m2.updown
            args.faceToCam = default.m2.faceToCam
            args.p19 = default.m2.p19
            args.rotate = default.m2.rotate
            args.textureDict = default.m2.textureDict
            args.textureName = default.m2.textureName
            args.drawOnEnts = default.m2.drawOnEnts
            args.z = default.m2.z
            args.op = default.m2.op
        end

        if inside then
            args.color = default.m2.color2
        else
            args.color = default.m2.color1
        end

        local z = (coords.z + args.z)

        if args.textureDict and args.textureName and not HasStreamedTextureDictLoaded(args.textureDict) then
            RequestStreamedTextureDict(args.textureDict, true)
            while not HasStreamedTextureDictLoaded(args.textureDict) do
                Wait(1)
            end
        end

        DrawMarker(args.id, coords.x, coords.y, z, args.dir[1], args.dir[2], args.dir[3], args.rot[1], args.rot[2], args.rot[3], args.scale[1], args.scale[2], args.scale[3], args.color[1], args.color[2], args.color[3], args.color[4], args.updown, args.faceToCam, args.p19, args.rotate, args.textureDict, args.textureName, args.drawOnEnts)
    end

    local args = {}

    if params then
        args.id = params.id or default.m1.id
        args.color = params.color or default.m1.color
        args.dir = params.dir or default.m1.dir
        args.rot = params.rot or default.m1.rot
        args.scale = params.scale or default.m1.scale
        args.updown = params.updown or default.m1.updown
        args.faceToCam = params.faceToCam or default.m1.faceToCam
        args.p19 = params.p19 or default.m1.p19
        args.rotate = params.rotate or default.m1.rotate
        args.textureDict = params.textureDict or default.m1.textureDict
        args.textureName = params.textureName or default.m1.textureName
        args.drawOnEnts = params.drawOnEnts or default.m1.drawOnEnts
        args.z = params.z or default.m1.z
        args.op = params.op or default.m1.op
    else
        args.id = default.m1.id
        args.color = default.m1.color
        args.dir = default.m1.dir
        args.rot = default.m1.rot
        args.scale = default.m1.scale
        args.updown = default.m1.updown
        args.faceToCam = default.m1.faceToCam
        args.p19 = default.m1.p19
        args.rotate = default.m1.rotate
        args.textureDict = default.m1.textureDict
        args.textureName = default.m1.textureName
        args.drawOnEnts = default.m1.drawOnEnts
        args.z = default.m1.z
        args.op = default.m1.op
    end

    if inside then
        args.color = default.m1.color2
    else
        args.color = default.m1.color1
    end

    local z = (coords.z + args.z)

    if args.textureDict and args.textureName and not HasStreamedTextureDictLoaded(args.textureDict) then
        RequestStreamedTextureDict(args.textureDict, true)
        while not HasStreamedTextureDictLoaded(args.textureDict) do
            Wait(1)
        end
    end

    DrawMarker(args.id, coords.x, coords.y, z, args.dir[1], args.dir[2], args.dir[3], args.rot[1], args.rot[2], args.rot[3], args.scale[1], args.scale[2], args.scale[3], args.color[1], args.color[2], args.color[3], args.color[4], args.updown, args.faceToCam, args.p19, args.rotate, args.textureDict, args.textureName, args.drawOnEnts)
end


return {
    simple = Marker
}