local ConnectedPlayers = {}

RegisterNetEvent('supv_core:server:player-connected', function()
    local _src = source
    if not ConnectedPlayers[_src] then ConnectedPlayers[_src] = _src end
end)

AddEventHandler('playerDropped', function (reason)
    local _src = source
    if ConnectedPlayers[_src] then ConnectedPlayers[_src] = nil end
end)