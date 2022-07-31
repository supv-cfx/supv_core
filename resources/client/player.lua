local ConnectedPlayers = {}

CreateThread(function()
    Wait(10*1000)
    TriggerServerEvent('supv_core:server:player-connected')
end)

RegisterNetEvent('supv_core:client:player-connected', function(newData)
    ConnectedPlayers = newData
end)