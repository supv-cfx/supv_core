---@credit overextended

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

-- Définit la fonction de requête générique
---@param _type string<'animDict' | 'model' | 'animSet' | 'ptfx' | 'weaponAsset' | 'scalformMovie' | 'textureDict'>
---@param request function
---@param hasLoaded function
---@param name string
---@param timeout? number
---@param ... unknown
---@return any
function supv.request(_type, request, hasLoaded, name, timeout, ...)
    if hasLoaded(name) then return name end

    request(name, ...)

    return supv.waitFor(function()
        if hasLoaded(name) then return name end
    end, timeout or 10000, ('Failed to load %s : %s'):format(_type, name))
end

supv.request = setmetatable({}, {
    __index = function(_, key)
        local requestFunc, hasLoadedFunc, errorMsg
        if key == "model" then
            requestFunc = RequestModel
            hasLoadedFunc = HasModelLoaded
            errorMsg = function(model) return ("attempted to load invalid model '%s'"):format(model) end
        elseif key == "animDict" then
            requestFunc = RequestAnimDict
            hasLoadedFunc = HasAnimDictLoaded
            errorMsg = function(animDict) return ("attempted to load invalid animDict '%s'"):format(animDict) end
        elseif key == "animSet" then
            requestFunc = RequestAnimSet
            hasLoadedFunc = HasAnimSetLoaded
            errorMsg = function(animSet) return ("attempted to load invalid animSet '%s'"):format(animSet) end
        elseif key == "ptfx" then
            requestFunc = RequestNamedPtfxAsset
            hasLoadedFunc = HasNamedPtfxAssetLoaded
            errorMsg = function(ptfx) return ("attempted to load invalid ptfx '%s'"):format(ptfx) end
        elseif key == "weaponAsset" then
            return function(_type, weaponFlags, extraFlags, timeout)
                if HasWeaponAssetLoaded(_type) then return _type end

                local weaponType = type(_type)

                if weaponType ~= 'string' and weaponType ~= 'number' then
                    error(("expected weaponType to have type 'string' or 'number' (received %s)"):format(weaponType),  2)
                end

                if weaponFlags and type(weaponFlags) ~= 'number' then
                    error(("expected weaponResourceFlags to have type 'number' (received %s)"):format(type(weaponFlags)))
                end

                if extraFlags and type(extraFlags) ~= 'number' then
                    error(("expected extraWeaponComponentFlags to have type 'number' (received %s)"):format(type(extraFlags)))
                end

                return supv.request("weaponAsset", RequestWeaponAsset, HasWeaponAssetLoaded, weaponType, timeout, weaponFlags, extraFlags)
            end
        elseif key == "scalformMovie" then
            return function(scaleformName, timeout)
                if HasScaleformMovieLoaded(scaleformName) then return scaleformName end

                local scalform = RequestScaleformMovie(scaleformName)

                return supv.waitFor(function()
                    if HasScaleformMovieLoaded(scalform) then return scalform end
                end, timeout or 10000, ('Failed to load scaleformMovie : %s'):format(scaleformName))
            end
        elseif key == "textureDict" then
            requestFunc = RequestStreamedTextureDict
            hasLoadedFunc = HasStreamedTextureDictLoaded
        else
            error("Unsupported request type: " .. tostring(key))
        end
        
        return function(name, timeout, ...)
            if key == "model" and not IsModelValid(name) then
                error(errorMsg(name), 2)
            elseif key == "animDict" and not DoesAnimDictExist(name) then
                error(errorMsg(name), 2)
            elseif key == "animSet" and type(name) ~= 'string' then
                error(errorMsg(name), 2)
            elseif key == 'texturedict' and type(name) ~= 'string' then
                error(("expected textureDict to have type 'string' (received %s)"):format(type(name)), 2)
            end

            return supv.request(key, requestFunc, hasLoadedFunc, name, timeout, ...)
        end
    end
})

return supv.request