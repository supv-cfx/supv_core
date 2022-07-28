oncache.player = {}
oncache.player.coords = nil
oncache.player.screen = {}

CreateThread(function()
    local step, needUpdate = 0

    while step == 0 do
        oncache.player.pedid = PlayerPedId();
        oncache.player.playerid = PlayerId();
        oncache.player.serverid = GetPlayerServerId(PlayerId());
        oncache.player.currentvehicle = GetVehiclePedIsIn(PlayerPedId(), false);
        oncache.player.screen.x, oncache.player.screen.y = GetActiveScreenResolution();
        oncache.player.coords = GetEntityCoords(PlayerPedId(), false);
        if (oncache.player.coords) and (oncache.player.screen.x and oncache.player.screen.y)  then
            step += 1
        end
        Wait(50)
    end
 
    while true do

        if (step == 1) then
            TriggerEvent('supv_core:refresh:cache', oncache.player)
            step += 1
        end

        needUpdate = false

        if #(oncache.player.coords - GetEntityCoords(oncache.player.pedid, false)) > 1.5 then
            oncache.player.coords = GetEntityCoords(oncache.player.pedid, false)
            needUpdate = true
        end
    
        if (oncache.player.currentvehicle ~= GetVehiclePedIsIn(oncache.player.pedid, false)) then
            oncache.player.currentvehicle = GetVehiclePedIsIn(oncache.player.pedid, false)
            needUpdate = true
        end

        if needUpdate then
            TriggerEvent('supv_core:refresh:cache', oncache.player)
        end

        Wait(300)
        if not needUpdate then
            Wait(500)
        end
    end
end)



-- garde de côté pour l'utilisation de statebag un jour mais bon ca consomme légèrement plus que le system de cache
--[[
CreateThread(function()
    local loaded = false
    while true do
        screenX, screenY = GetActiveScreenResolution()
        if not loaded then
            loaded = true
            Cache.player.pedId = PlayerPedId()
            Cache.player.id = PlayerId()
            Cache.player.serverId = GetPlayerServerId(PlayerId())
            --LocalPlayer.state:set('playerPedId', PlayerPedId(), true)
            --LocalPlayer.state:set('playerId', PlayerId(), true)
            --LocalPlayer.state:set('serverId', GetPlayerServerId(PlayerId()), true)
        end
        if not next(Cache.player.screen) or (Cache.player.screen.x ~= screenX and Cache.player.screen.y ~= screenY ) then
            Cache.player.screen.x, Cache.player.screen.y = GetActiveScreenResolution()
            --LocalPlayer.state:set('resolution', GetActiveScreenResolution(), true)
            needUpdate = true
        end
        if not Cache.player.coords or #(GetEntityCoords(PlayerPedId()) - Cache.player.coords) > 3.0 then
            Cache.player.coords = GetEntityCoords(PlayerPedId())
            --LocalPlayer.state:set('coords', GetEntityCoords(PlayerPedId()), true)
            needUpdate = true
        end
        if not Cache.player.currentVehicle or (GetVehiclePedIsIn(PlayerPedId(), false) ~= Cache.player.currentVehicle) then
            Cache.player.currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            --LocalPlayer.state:set('currentVehicle', GetVehiclePedIsIn(PlayerPedId(), false), true)
            needUpdate = true
        end
        if needUpdate then
            TriggerEvent('supv_core:refresh:cache', Cache.player)
        end
        Wait(500)
    end
end)
]]

_ENV.oncache = oncache