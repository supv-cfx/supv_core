oncache.playerid = PlayerId()
oncache.serverid = GetPlayerServerId(PlayerId())
oncache.screen = {GetActiveScreenResolution()}

function oncache:set(k, v)
    if self[k] ~= v then
        self[k] = v
        TriggerEvent(('supv_core:set:cache:%s'):format(k), v)
        return true
    end
end

local GetEntityCoords <const>  = GetEntityCoords
local PlayerPedId <const>  = PlayerPedId
--local GetVehiclePedIsUsing <const>  = GetVehiclePedIsUsing -- fuck perf
local GetVehiclePedIsIn <const> = GetVehiclePedIsIn

CreateThread(function()
    local ped, currentVeh, distance, coords
    oncache.coords = GetEntityCoords(PlayerPedId())
    while true do
        ped = PlayerPedId()
        currentVeh = GetVehiclePedIsIn(ped)
        coords = GetEntityCoords(ped)

        distance = #(coords - oncache.coords)
        
        if  distance > 0.80 then
            oncache:set('coords', coords)
        end

        --print(currentVeh)

        if currentVeh > 0 then
            oncache:set('currentvehicle', currentVeh)
        else
            oncache:set('currentvehicle', false)
        end

        Wait(1000)
    end
end)

_ENV.oncache = oncache


--Player:set('playerid', PlayerId(), true)
--Player:set('pedid', PlayerPedId(), true)
--Player:set('serverid', GetPlayerServerId(PlayerId()), true)
--Player:set('screen', {GetActiveScreenResolution()}, true)
--Player:set('coords', GetEntityCoords(PlayerPedId()), true)
--Player:set('currentvehicle', GetVehiclePedIsIn(PlayerPedId(), false), true)

