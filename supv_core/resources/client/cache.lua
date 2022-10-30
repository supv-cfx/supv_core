oncache.playerid = PlayerId()
oncache.serverid = GetPlayerServerId(PlayerId())
oncache.screen = {GetActiveScreenResolution()}

function oncache:set(k, v)
    if self[k] ~= v then
        --print(k,v)
        self[k] = v
        TriggerEvent(('supv_core:set:cache:%s'):format(k), v)
        return true
    end
end

local GetEntityCoords <const>  = GetEntityCoords
local PlayerPedId <const>  = PlayerPedId
local GetVehiclePedIsUsing <const>  = GetVehiclePedIsUsing

CreateThread(function()
    local ped, currentVeh
    oncache.coords = GetEntityCoords(PlayerPedId())
    while true do
        ped = PlayerPedId()
        currentVeh = GetVehiclePedIsUsing(ped)

        if currentVeh > 0 then
            oncache:set('currentvehicle', currentVeh)
        else
            oncache:set('currentvehicle', false)
        end

        Wait(500)
    end
end)

_ENV.oncache = oncache