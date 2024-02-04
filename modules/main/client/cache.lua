-- redm only
local GetMount <const> = supv.game == 'redm' and GetMount
local IsPedOnMount <const> = supv.game == 'redm' and IsPedOnMount
-- fivem & redm
local PlayerPedId <const> = PlayerPedId
local PlayerId <const> = PlayerId
local GetPlayerServerId <const> = GetPlayerServerId 
local GetVehiclePedIsIn <const> = GetVehiclePedIsIn
local GetPedInVehicleSeat <const> = GetPedInVehicleSeat
local GetVehicleMaxNumberOfPassengers <const> = GetVehicleMaxNumberOfPassengers
local GetCurrentPedWeapon <const> = GetCurrentPedWeapon
local TriggerEvent <const> = TriggerEvent

local cache = _ENV.cache
function cache:set(key, value)
    if (self[key] == nil) or (self[key] ~= value) then
        self[key] = value
        TriggerEvent(('cache:%s'):format(key), value)
        return true
    end
end

CreateThread(function()
    cache:set('playerid', PlayerId())
    cache:set('serverid', GetPlayerServerId(cache.playerid))
    local RefreshGfxToNui
    while true do
        cache:set('ped', PlayerPedId())

        if supv.game == 'redm' then
            cache:set('mount', IsPedOnMount(cache.ped) == true and GetMount(cache.ped) or false)
        end

        local hasWeapon, weaponHash = GetCurrentPedWeapon(cache.ped, true)
        cache:set('weapon', hasWeapon and weaponHash or false)

        local vehicle = GetVehiclePedIsIn(cache.ped, false)
		if vehicle > 0 then
			cache:set('vehicle', vehicle)

			if not cache.seat or GetPedInVehicleSeat(vehicle, cache.seat) ~= cache.ped then
				for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
					if GetPedInVehicleSeat(vehicle, i) == cache.ped then
						cache:set('seat', i)
						break
					end
				end
			end
		else
			cache:set('vehicle', false)
			cache:set('seat', false)
		end

        if RefreshGfxToNui then
            RefreshGfxToNui()
        elseif not RefreshGfxToNui and _ENV.RefreshGfxToNui then
            RefreshGfxToNui = _ENV.RefreshGfxToNui
        end

        Wait(500)
    end
end)


function supv.getCache(key)
    return cache[key] or key == 'vehicle' and false or false
end