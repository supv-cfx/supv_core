local cache = {}

function cache:set(key, value)
    if not self[key] or self[key] ~= value then
        self[key] = value
        TriggerEvent(('supv_core:cache:%s'):format(key), value)
        return true
    end
end

-- redm only
local GetMount <const> = GetMount
local IsPedOnMount <const> = IsPedOnMount

-- fivem & redm
local PlayerPedId <const> = PlayerPedId
local PlayerId <const> = PlayerId
local GetPlayerServerId <const> = GetPlayerServerId 
local GetVehiclePedIsIn <const> = GetVehiclePedIsIn
local GetPedInVehicleSeat <const> = GetPedInVehicleSeat
local GetVehicleMaxNumberOfPassengers <const> = GetVehicleMaxNumberOfPassengers
local GetCurrentPedWeapon <const> = GetCurrentPedWeapon
local GetActiveScreenResolution <const> = GetActiveScreenResolution

local size = 100

CreateThread(function()
    while true do
        cache:set('ped', PlayerPedId())

        if size > 100 then
            local screen_x, screen_y = GetActiveScreenResolution()
            cache:set('playerid', PlayerId())
            cache:set('serverid', GetPlayerServerId(cache.playerid))
            cache:set('screen_x', screen_x)
            cache:set('screen_y', screen_y)
            size = 0
        end

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

        size += 1
        Wait(750)
    end
end)


function supv.getCache(key)
    return cache[key]
end