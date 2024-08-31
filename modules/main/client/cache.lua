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

local RefreshGfxToNui, MinimapToNui
if supv.game == 'fivem' then
    ---@return { mini_x: number, mini_y: number, mini_w: number, mini_h: number }
    MinimapToNui = function()
        SetScriptGfxAlign(('L'):byte(), ('B'):byte())
        local minimapTopX <const>, minimapTopY <const> = GetScriptGfxPosition(-0.00, 0.002 + (-0.188888))
        local minimapBottomX <const>, minimapBottomY <const> = GetScriptGfxPosition(-0.0045 + 0.145, 0.002)
        ResetScriptGfxAlign()
        local w <const>, h <const> = GetActiveScreenResolution()
        local base <const> = GetAspectRatio(true)
        local ratio <const> = (16/9) / base
        local x1 <const>, y1 <const> = w * minimapTopX, h * (minimapTopY + .01)
        local x2 <const>, y2 <const> = w * minimapBottomX, h * (minimapBottomY - .02)
        local minimapWidth <const>, minimapHeight <const> = x2 - x1, y2 - y1

        return {
            mini_x = math.abs(x1),
            mini_y = math.abs(y1),
            mini_w = minimapWidth * ratio,
            mini_h = minimapHeight,
        }
    end

    ---@param force boolean
    RefreshGfxToNui = function(force)
        local minimap <const> = MinimapToNui()
        for k, v in pairs(minimap) do
            if k == 'w' then
                local expanded <const> = IsBigmapActive()
                local hidden <const> = IsRadarHidden()

                cache:set('mini_visible', not hidden, force)
                if not hidden then
                    cache:set(k, expanded and v * 1.5825 or v, force)
                    cache:set('mini_expanded', expanded, force)
                else
                    cache:set(k, v, force)
                    cache:set('mini_expanded', false, force)
                end
            elseif k == 'h' then
                local hidden <const> = IsRadarHidden()
                local expanded <const> = IsBigmapActive()

                cache:set('mini_visible', not hidden, force)
                if not expanded then
                    cache:set(k, hidden and (v - v) + 16 or v, force)
                else
                    if hidden then
                        cache:set(k, hidden and (v - v) + 16 or v, force)
                    else
                        cache:set(k, v * 2.5825, force)
                    end
                end
            else
                cache:set(k, v, force)
            end
        end
    end
end

CreateThread(function()
    cache:set('playerid', PlayerId())
    cache:set('serverid', GetPlayerServerId(cache.playerid))
    local count = supv.game ~= 'redm' and 0

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

        if supv.game == 'fivem' then
            RefreshGfxToNui(count == 0)

            count += 1

            if count >= 10 then
                count = 0
            end
        end

        Wait(500)
    end
end)


function supv.GetCache(key)
    return cache[key] or key == 'vehicle' and false or false
end