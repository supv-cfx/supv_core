local Request = {}
Request.__index = Request

-- Fonction générique pour gérer les requêtes
---@param _type string<'animDict' | 'model' | 'animSet' | 'ptfx' | 'weaponAsset' | 'scalformMovie' | 'textureDict'>
---@param request function
---@param hasLoaded function
---@param name string
---@param timeout? number
---@param ... unknown
---@return any
function Request:_request(_type, request, hasLoaded, name, timeout, ...)
    if hasLoaded(name) then return name end

    request(name, ...)

    return supv.waitFor(function()
        if hasLoaded(name) then return name end
    end, timeout or 10000, ('Failed to load %s : %s'):format(_type, name))
end

-- Définition des méthodes spécifiques pour chaque type de requête
function Request:model(name, timeout)
    if not IsModelValid(name) then
        error(("attempted to load invalid model '%s'"):format(name), 2)
    end
    return self:_request('model', RequestModel, HasModelLoaded, name, timeout)
end

function Request:animDict(name, timeout)
    if not DoesAnimDictExist(name) then
        error(("attempted to load invalid animDict '%s'"):format(name), 2)
    end
    return self:_request('animDict', RequestAnimDict, HasAnimDictLoaded, name, timeout)
end

function Request:animSet(name, timeout)
    if type(name) ~= 'string' then
        error(("attempted to load invalid animSet '%s'"):format(name), 2)
    end
    return self:_request('animSet', RequestAnimSet, HasAnimSetLoaded, name, timeout)
end

function Request:ptfx(name, timeout)
    return self:_request('ptfx', RequestNamedPtfxAsset, HasNamedPtfxAssetLoaded, name, timeout)
end

function Request:weaponAsset(weaponType, weaponFlags, extraFlags, timeout)
    if HasWeaponAssetLoaded(weaponType) then return weaponType end

    local weaponTypeStr = type(weaponType)
    if weaponTypeStr ~= 'string' and weaponTypeStr ~= 'number' then
        error(("expected weaponType to have type 'string' or 'number' (received %s)"):format(weaponTypeStr), 2)
    end

    if weaponFlags and type(weaponFlags) ~= 'number' then
        error(("expected weaponResourceFlags to have type 'number' (received %s)"):format(type(weaponFlags)), 2)
    end

    if extraFlags and type(extraFlags) ~= 'number' then
        error(("expected extraWeaponComponentFlags to have type 'number' (received %s)"):format(type(extraFlags)), 2)
    end

    return self:_request('weaponAsset', RequestWeaponAsset, HasWeaponAssetLoaded, weaponType, timeout, weaponFlags, extraFlags)
end

function Request:scalformMovie(scaleformName, timeout)
    if HasScaleformMovieLoaded(scaleformName) then return scaleformName end

    local scalform = RequestScaleformMovie(scaleformName)

    return supv.waitFor(function()
        if HasScaleformMovieLoaded(scalform) then return scalform end
    end, timeout or 10000, ('Failed to load scaleformMovie : %s'):format(scaleformName))
end

function Request:textureDict(name, timeout)
    if type(name) ~= 'string' then
        error(("expected textureDict to have type 'string' (received %s)"):format(type(name)), 2)
    end
    return self:_request('textureDict', RequestStreamedTextureDict, HasStreamedTextureDictLoaded, name, timeout)
end

supv.request = setmetatable({}, Request)

return supv.request