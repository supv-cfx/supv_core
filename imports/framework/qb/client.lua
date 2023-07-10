local QBCore = exports["qb-core"]:GetCoreObject()
local PlayerData = setmetatable({}, {
    __index = function(self, key)
        local value = rawget(self, key)
        if not value then
            value = QBCore.PlayerData?[key] or QBCore.Functions.GetPlayerData()[key]
            rawset(self, key, value)
        end
        return value
    end
})

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    PlayerData.job = data.job
    PlayerData.gang = data.gang
    TriggerEvent('setPlayerData', data)
end)

return {
    playerData = PlayerData,
    onSetPlayerData = function(cb)
        AddEventHandler('setPlayerData', function(data)
            local resourceName = GetInvokingResource()
            if resourceName ~= supv.env then return end
            cb(data)
        end)
    end,
    onPlayerLoaded = function(cb)
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', cb)
    end,
}