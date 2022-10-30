

local default <const> = {
    m1 = supv.config.client.import.marker.m1,
    m2 = supv.config.client.import.marker.m2
}

local DrawMarker <const> = DrawMarker

local function Show(coords, params)

    local args = {}

    --print(json.encode(params, {indent=true}), 'show')

    args.visible = params?.visible or nil
    args.id = params?.id or default.m1.id
    args.color =  params?.color or default.m1.color
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
    args.color =  params?.color or default.m1.color1

    local z = (coords.z + args.z)

    if args.textureDict and args.textureName and not HasStreamedTextureDictLoaded(args.textureDict) then
        RequestStreamedTextureDict(args.textureDict, true)
        while not HasStreamedTextureDictLoaded(args.textureDict) do
            Wait(1)
        end
    end

    if args.visible then
        DrawMarker(args.id, coords.x, coords.y, z, args.dir[1], args.dir[2], args.dir[3], args.rot[1], args.rot[2], args.rot[3], args.scale[1], args.scale[2], args.scale[3], args.color[1], args.color[2], args.color[3], args.color[4], args.updown, args.faceToCam, args.p19, args.rotate, args.textureDict, args.textureName, args.drawOnEnts)
    end
end

local function Marker(double, inside, coords, params, params2)

    if double then
        
        local args = {}
        
        if params2 then
            if params2.visible then args.visible = params2.visible else args.visible = default.m2.visible end
            if params2.id then args.id = params2.id else args.id = default.m2.id end
            if params2.color then args.color = params2.color else args.color = default.m2.color end
            if params2.dir then args.dir = params2.dir else args.dir = default.m2.dir end
            if params2.rot then args.rot = params2.rot else args.rot = default.m2.rot end
            if params2.scale then args.scale = params2.scale else args.scale = default.m2.scale end
            if params2.updown then args.updown = params2.updown else args.updown = default.m2.updown end
            if params2.faceToCam then args.faceToCam = params2.faceToCam else args.faceToCam = default.m2.faceToCam end
            if params2.p19 then args.p19 = params2.p19 else args.p19 = default.m2.p19 end
            if params2.rotate then args.rotate = params2.rotate else args.rotate = default.m2.rotate end
            if params2.textureDict then args.textureDict = params2.textureDict else args.textureDict = default.m2.textureDict end
            if params2.textureName then args.textureName = params2.textureName else args.textureName = default.m2.textureName end
            if params2.drawOnEnts  then args.drawOnEnts = params2.drawOnEnts else args.drawOnEnts = default.m2.drawOnEnts end
            if params2.z then args.z = params2.z else args.z = default.m2.z end
            if params2.op then args.op = params2.op else args.op = default.m2.op end
        else
            args.visible = default.m2.visible 
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

        if args.visible then
            DrawMarker(args.id, coords.x, coords.y, z, args.dir[1], args.dir[2], args.dir[3], args.rot[1], args.rot[2], args.rot[3], args.scale[1], args.scale[2], args.scale[3], args.color[1], args.color[2], args.color[3], args.color[4], args.updown, args.faceToCam, args.p19, args.rotate, args.textureDict, args.textureName, args.drawOnEnts)
        end
    end

    local args = {}

    if params then
        if params.visible then args.visible = params.visible else args.visible = default.m1.visible end
        if params.id then args.id = params.id else args.id = default.m1.id end
        if params.color then args.color = params.color else args.color = default.m1.color end
        if params.dir then args.dir = params.dir else args.dir = default.m1.dir end
        if params.rot then args.rot = params.rot else args.rot = default.m1.rot end
        if params.scale then args.scale = params.scale else args.scale = default.m1.scale end
        if params.updown then args.updown = params.updown else args.updown = default.m1.updown end
        if params.faceToCam then args.faceToCam = params.faceToCam else args.faceToCam = default.m1.faceToCam end
        if params.p19 then args.p19 = params.p19 else args.p19 = default.m1.p19 end
        if params.rotate then args.rotate = params.rotate else args.rotate = default.m1.rotate end
        if params.textureDict then args.textureDict = params.textureDict else args.textureDict = default.m1.textureDict end
        if params.textureName then args.textureName = params.textureName else args.textureName = default.m1.textureName end
        if params.drawOnEnts  then args.drawOnEnts = params.drawOnEnts else args.drawOnEnts = default.m1.drawOnEnts end
        if params.z then args.z = params.z else args.z = default.m1.z end
        if params.op then args.op = params.op else args.op = default.m1.op end
    else
        args.visible = default.m1.visible 
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

    if args.visible then
        DrawMarker(args.id, coords.x, coords.y, z, args.dir[1], args.dir[2], args.dir[3], args.rot[1], args.rot[2], args.rot[3], args.scale[1], args.scale[2], args.scale[3], args.color[1], args.color[2], args.color[3], args.color[4], args.updown, args.faceToCam, args.p19, args.rotate, args.textureDict, args.textureName, args.drawOnEnts)
    end
end


return {
    simple = Marker,
    show = Show
}