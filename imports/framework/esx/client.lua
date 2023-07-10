local ESX = exports["es_extended"]:getSharedObject()
local PlayerData = setmetatable({}, {
    __index = function(self, key)
        local value = rawget(self, key)
        if not value then
            if key ~= 'gang' then
                value = ESX.PlayerData?[key]
                rawset(self, key, value)
            else
                value = ESX.PlayerData?.faction
                rawset(self, key, value)
            end
        end
        return value
    end
})

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    PlayerData.job = xPlayer.PlayerData?.job
    PlayerData.gang = xPlayer.PlayerData?.faction
end)

AddEventHandler('esx:setPlayerData', function(key, value)
    if GetInvokingResource() ~= 'es_extended' then return end
    Wait(500)
    if key == 'job' then
        PlayerData.job = value
    elseif key == 'faction' then -- or 'job2'
        PlayerData.gang = value
    end
end)

return {
    playerData = PlayerData,
    onSetPlayerData = function(cb)
        AddEventHandler('esx:setPlayerData', function(key, value)
            cb(key, value)
        end)
    end,
    onPlayerLoaded = function(cb)
        AddEventHandler("esx:playerLoaded", cb)
    end,
}