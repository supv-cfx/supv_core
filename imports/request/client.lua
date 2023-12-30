---@alias WeaponResourceFlags
---| 1 WRF_REQUEST_BASE_ANIMS
---| 2 WRF_REQUEST_COVER_ANIMS
---| 4 WRF_REQUEST_MELEE_ANIMS
---| 8 WRF_REQUEST_MOTION_ANIMS
---| 16 WRF_REQUEST_STEALTH_ANIMS
---| 32 WRF_REQUEST_ALL_MOVEMENT_VARIATION_ANIMS
---| 31 WRF_REQUEST_ALL_ANIMS

---@alias ExtraWeaponComponentFlags
---| 0 WEAPON_COMPONENT_NONE
---| 1 WEAPON_COMPONENT_FLASH
---| 2 WEAPON_COMPONENT_SCOPE
---| 4 WEAPON_COMPONENT_SUPP
---| 8 WEAPON_COMPONENT_SCLIP2
---| 16 WEAPON_COMPONENT_GRIP

---@class DataProps
---@field type 'animdict' | 'model' | 'animset' | 'ptfx' | 'weaponasset' | 'scalformmovie' | 'texturedict'
---@field name string
---@field weaponFlags? WeaponResourceFlags
---@field extraFlags? ExtraWeaponComponentFlags


---@param data DataProps
---@param timeout? number
---@return string | fun(name: data.name): void
function supv.request(data, timeout)
    if type(data.type) ~= 'string' then
        return error(('data.type must be a string (typeof selector: %s)'):format(type(data.type)), 2)
    end

    local funcRef, errmsg, flushRef
    data.type = data.type:lower()

    if data.type == 'animdict' then
        funcRef = HasAnimDictLoaded
        flushRef = RemoveAnimDict

        if funcRef(data.name) then return data.name end
        if type(data.name) ~= 'string' then
            return error(('data.name must be a string (typeof name: %s)'):format(type(data.name)), 2)
        end
        if not DoesAnimDictExist(data.name) then
            return error(('anim dict does not exist: %s'):format(data.name), 2)
        end

        errmsg = 'Failed to load anim dict : %s'
        RequestAnimDict(data.name)
    elseif data.type == 'animset' then
        funcRef = HasAnimSetLoaded
        flushRef = RemoveAnimSet

        
        if funcRef(data.name) then return data.name end
        if type(data.name) ~= 'string' then
            return error(('data.name must be a string (typeof name: %s)'):format(type(data.name)), 2)
        end
        
        errmsg = 'Failed to load anim set : %s'
        RequestAnimSet(data.name)
    elseif data.type == 'model' then
        funcRef = HasModelLoaded
        flushRef = SetModelAsNoLongerNeeded
        
        if funcRef(data.name) then return data.name end
        if type(data.name) ~= 'number' and type(data.name) ~= 'string' then
            return error(('data.name must be a number (typeof name: %s)'):format(type(data.name)), 2)
        end
        if not IsModelInCdimage(data.name) then
            return error(('model does not exist: %s'):format(data.name), 2)
        end

        errmsg = 'Failed to load model : %s'
        RequestModel(data.name)
    elseif data.type == 'ptfx' then
        funcRef = HasNamedPtfxAssetLoaded
        flushRef = RemoveNamedPtfxAsset

        if funcRef(data.name) then return data.name end
        if type(data.name) ~= 'string' then
            return error(('data.name must be a string (typeof name: %s)'):format(type(data.name)), 2)
        end

        errmsg = 'Failed to load ptfx : %s'
        RequestNamedPtfxAsset(data.name)
    elseif data.type == 'weaponasset' then
        funcRef = HasWeaponAssetLoaded
        flushRef = RemoveWeaponAsset

        if funcRef(data.name) then return flushRef end

        if type(data.name) ~= 'number' and type(data.name) ~= 'string' then
            return error(('data.name must be a number (typeof name: %s)'):format(type(data.name)), 2)
        end

        if data.weaponFlags and type(data.weaponFlags) ~= 'number' then
            return error(('data.weaponFlags must be a number (typeof weaponFlags: %s)'):format(type(data.weaponFlags)), 2)
        end

        if data.extraFlags and type(data.extraFlags) ~= 'number' then
            return error(('data.extraFlags must be a number (typeof extraFlags: %s)'):format(type(data.extraFlags)), 2)
        end

        errmsg = 'Failed to load weaponAsset : %s'
        RequestWeaponAsset(data.name, data.weaponFlags or 31, data.extraFlags or 0)
    elseif data.type == 'scalformmovie' then
        funcRef = HasScaleformMovieLoaded
        flushRef = SetScaleformMovieAsNoLongerNeeded

        if funcRef(data.name) then return data.name end
        if type(data.name) ~= 'string' then
            return error(('data.name must be a string (typeof name: %s)'):format(type(data.name)), 2)
        end

        errmsg = 'Failed to load scaleformMovie : %s'
        RequestScaleformMovie(data.name)
    elseif data.type == 'texturedict' then
        funcRef = HasStreamedTextureDictLoaded
        flushRef = SetStreamedTextureDictAsNoLongerNeeded

        if funcRef(data.name) then return data.name end
        if type(data.name) ~= 'string' then
            return error(('data.name must be a string (typeof name: %s)'):format(type(data.name)), 2)
        end

        errmsg = 'Failed to load streamedTextureDict : %s'
        RequestStreamedTextureDict(data.name)
    else
        return error(('data.type must be a valid type (type: %s)'):format(data.type), 2)
    end

    if not coroutine.isyieldable() then return data.name end
    
    return supv.waitFor(function()
        if funcRef(data.name) then return flushRef or data.name end
    end, timeout or 500, (errmsg):format(data.name))
end

return supv.request