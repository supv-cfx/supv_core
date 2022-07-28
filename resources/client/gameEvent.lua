--[[ 
AddEventHandler('gameEventTriggered', function (name, args)
    if Shared.DevMod then
        print(("gameEventTriggered: %s / args: %s"):format(name, json.encode(args)))
    end
    if name == 'CEventNetworkEntityDamage' then

        if not Config.Rewards.npc then
            if args[6] == 1 then

                if Shared.DevMod then
                    print(('Remove rewards from ped passed => ped died = %s | ped = %s'):format(args[6], args[1]))
                end

                SetPedDropsWeaponsWhenDead(args[1], Config.Rewards.npc)
            end
        end

    elseif name == 'CEventNetworkPlayerEnteredVehicle' then

        if not Config.Rewards.vehicle then
            DisablePlayerVehicleRewards(PlayerId())
        end

        if Config.AudioRadio.enable then
            local found = false
            for i = 1, #Config.AudioRadio.blacklist do
                if GetEntityArchetypeName(args[2]) == Config.AudioRadio.blacklist[i] then
                    found = true
                end
            end
            if found then
                SetUserRadioControlEnabled(false)
                SetVehRadioStation(args[2], "OFF")
            else
                SetUserRadioControlEnabled(true)
            end
        elseif Config.AudioRadio.enable == 'full' then
            SetUserRadioControlEnabled(false)
            SetVehRadioStation(args[2], "OFF")
        end
    --elseif name == 'CEventNetworkPlayerCollectedAmbientPickup' then -- I keep it here because maybe is useful later
        --print('collected pickups')
    end
end)
]]
