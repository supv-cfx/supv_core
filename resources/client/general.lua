local Traffic, Npc, VehicleParked = Config.Traffic.amount.traffic, Config.Traffic.amount.npc, Config.Traffic.amount.parked
local EnableBoats, EnableTrain, EnableGarbageTruck, EnablePolice = Config.Traffic.enable.boats, Config.Traffic.enable.trains, Config.Traffic.enable.garbageTruck, Config.Traffic.enable.polices

local function ClearPickupsFromRewards()
    CreateThread(function()
        while true do
            Wait((6*10000)*30) -- every 30min
            if Shared.DevMod then
                print(json.encode(GetGamePool('CPickup')))
            end
            RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
            RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
            RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
        end
    end)
end

CreateThread(function()

    while next(oncache.player) == nil do Wait(50) end

    SetRandomBoats(EnableBoats)
    SetRandomTrains(EnableTrain)
    SetGarbageTrucks(EnableGarbageTruck)

    SetCreateRandomCops(EnablePolice)
    SetCreateRandomCopsNotOnScenarios(EnablePolice)
    SetCreateRandomCopsOnScenarios(EnablePolice)
    SetDispatchCopsForPlayer(oncache.player.playerid, EnablePolice)

    SetPedPopulationBudget(Npc) -- 0 = none / 3 = normal (max is 3)
    SetVehiclePopulationBudget(Traffic) -- https://docs.fivem.net/natives/?_0xCB9E1EB3BE2AF4E9 no more info but is like SetPedPopulationBudget I think...
    SetNumberOfParkedVehicles(VehicleParked) -- https://docs.fivem.net/natives/?_0xCAA15F13EBD417FF no more info but is like SetPedPopulationBudget I think...

    for k,v in pairs(Config.Traffic.dispatch) do
        local list = v.list
        if k then
            for i = 1, #list do
                EnableDispatchService(v.enable, list[i])
                local enabled = v.enable
                enabled = not enabled
                BlockDispatchServiceResourceCreation(list[i], enabled)
            end
        end
    end

    if not Config.Rewards.vehicle then
        DisablePlayerVehicleRewards(oncache.player.playerid)
    end

    if not Config.Rewards.npc then
        for i = 1, #Shared.Pickups.Blacklisted do
            ToggleUsePickupsForPlayer(oncache.player.playerid, Shared.Pickups.Blacklisted[i], false)
        end
        if Config.Rewards.clearPickUpsRewards then
            ClearPickupsFromRewards()
        end
    end

    if Config.AudioFlag.enable then
        for _,v in ipairs(Config.AudioFlag.list) do
            SetAudioFlag(v.name, v.enable)
        end
    end

    if Config.Relationship.enable then
        for _,v in ipairs(Config.Relationship.list) do
            for i = 1, #v.group1 do
                for j = 1, #v.group2 do
                    SetRelationshipBetweenGroups(v.relation, v.group1[i], v.group2[j])
                    if Shared.DevMod then
                        print(v.relation, json.encode(v.group1[i]), json.encode(v.group2[j]))
                    end
                end
            end
        end 
    end

    if Config.PlayerOptions.flag.enable then
        local list = Config.PlayerOptions.flag.list
        for i = 1, #list do
            assert(type(list[i].flagId) == 'number', ("[Error] : In Config.PlayerOptions.flag.list flagId: %s, isn't a number"):format(list[i].flagId))
            assert(type(list[i].value) == 'boolean', ("[Error] : In Config.PlayerOptions.flag.list value %s, isn't a boolean"):format(list[i].value))
            SetPedConfigFlag(oncache.player.pedid, list[i].flagId, list[i].value)
        end
    end

    if not Config.PlayerOptions.canRagdoll then
        SetPedCanRagdoll(oncache.player.pedid, false) 
    end

    if Config.PlayerOptions.gotDamagedOnlyByPlayers then
        SetEntityOnlyDamagedByPlayer(oncache.player.pedid, true)
    end

    if not Config.PlayerOptions.showRadar.visible then
        DisplayRadar(false)
    else
        DisplayRadar(true)
    end

    if Config.PlayerOptions.canDoDriveBy == false then
        SetPlayerCanDoDriveBy(oncache.player.playerid, false)
    elseif Config.PlayerOptions.canDoDriveBy == true then
        SetPlayerCanDoDriveBy(oncache.player.playerid, true)
    end

end)


if not Config.Traffic.enable.polices then

    local coords = vector3(409.160736, -990.443726, 28.843187)

    CreateThread(function()
        while true do
            Wait(2500)
            if #(oncache.player.coords - coords) < 100 then
                ClearAreaOfCops(coords.x, coords.y, coords.z, 100.0)
                Wait(10000)
            end
        end
    end)
end


if Config.PlayerOptions.showRadar.visible == 'vehicle' then

    local vehicleBlacklisted, currentValue = Config.PlayerOptions.showRadar.blacklist, false

    local function ShowRadar(bool)
        if currentValue == bool then
            return
        else
            currentValue = bool
            DisplayRadar(bool)
            return currentValue
        end
    end

    CreateThread(function()
        ShowRadar(false)
        if next(vehicleBlacklisted) then
            while true do
                Wait(1000)
                if vehicleBlacklisted[GetEntityModel(oncache.player.currentVehicle)] then
                    ShowRadar(true)
                end
                if oncache.player.currentVehicle == 0 then
                    ShowRadar(false)
                end
            end
        else
            while true do
                Wait(1000)
                if oncache.player.currentVehicle == 0  then
                    ShowRadar(false)
                else
                    ShowRadar(true)
                end
            end
        end
    end)
end


if not Config.Rewards.vehicle then
    local listeVehicle = Config.Rewards.listVehicle

    local function RemoveRewardsFromPoliceVehicle() -- for more secure

        local time<const>, timer = 5000, 0
        CreateThread(function()
            timer = GetGameTimer()
            while true do
                Wait(1)
    
                DisablePlayerVehicleRewards(oncache.player.playerid)
                if (GetGameTimer() - time > timer) then
                    return false
                end
                
            end
        end)
    end

    CreateThread(function()
        while true do
            Wait(500)

            if listeVehicle[GetEntityModel(GetVehiclePedIsTryingToEnter(oncache.player.pedid))] then
                RemoveRewardsFromPoliceVehicle()
                Wait(2500)
            end
        end
    end)
end

if Config.PlayerOptions.hideHudComponent.enable then
    local intervale
    local list = Config.PlayerOptions.hideHudComponent.list
    local scopeList = Config.PlayerOptions.hideHudComponent.scopeList
    if #list > 0 then
        CreateThread(function()
            while true do
                Wait(0)
                intervale = true
                for i = 1, #list do
                    if list[i] ~= 14 then
                        if IsHudComponentActive(list[i]) then intervale = false
                            HideHudComponentThisFrame(list[i])
                        end
                    else
                        if IsPedArmed(oncache.player.pedid, 4) then intervale = false 
                            local _, hash = GetCurrentPedWeapon(oncache.player.pedid, true)
                            if scopeList[hash] then
                                HideHudComponentThisFrame(14)
                            end
                        end
                    end
                end

                if intervale then
                    Wait(500)
                end
            end
        end)
    end
end


if not Config.PlayerOptions.afkCam then
    CreateThread(function()
        while true do
            Wait(2000)
            InvalidateIdleCam()
		    InvalidateVehicleIdleCam()
        end
    end)
end


if not Config.PlayerOptions.CrossHit then
    local intervale
    CreateThread(function()
        while true do
            Wait(0)
            intervale = true
            if IsPedArmed(oncache.player.pedid, 4) then intervale = false
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end

            if intervale then
                Wait(500)
            end
        end
    end)
end


if Config.AudioRadio.enable or Config.AudioRadio.enable == 'full' then
    local blacklist = Config.AudioRadio.blacklist
    CreateThread(function()
        if Config.AudioRadio.enable == true then
            while true do
                Wait(1000)
                if blacklist[GetEntityModel(oncache.player.currentVehicle)] then
                    SetUserRadioControlEnabled(false)
                    SetVehRadioStation(oncache.player.currentVehicle, "OFF")
                end
            end
        elseif Config.AudioRadio.enable == 'full' then
            while true do
                Wait(1000)
                if oncache.player.currentVehicle then
                    SetUserRadioControlEnabled(false)
                    SetVehRadioStation(oncache.player.currentVehicle, "OFF")
                end
            end
        else return false
        end 
    end)
end

if Config.PauseMenu.enable then
    CreateThread(function()
        AddTextEntry('FE_THDR_GTAO', Config.PauseMenu.title)
        AddTextEntry('PM_SCR_MAP', Config.PauseMenu.map)
        AddTextEntry('PM_SCR_GAM', Config.PauseMenu.game)
        AddTextEntry('PM_PANE_LEAVE', Config.PauseMenu.disconnect)
        AddTextEntry('PM_PANE_QUIT', Config.PauseMenu.quit)
        AddTextEntry('PM_SCR_INF', Config.PauseMenu.information)
        AddTextEntry('PM_SCR_STA', Config.PauseMenu.stats)
        AddTextEntry('PM_SCR_SET', Config.PauseMenu.setting)
        AddTextEntry('PM_SCR_CFX', Config.PauseMenu.fivemKey)
        AddTextEntry('PM_SCR_GAL', Config.PauseMenu.gallery)
        AddTextEntry('PM_SCR_RPL', Config.PauseMenu.editor)
    end)
end

if Config.PlayerOptions.unlimitedStamina then
    CreateThread(function()
        while true do
            Wait(2000)
            ResetPlayerStamina(oncache.player.playerid)
        end
    end)
end


if Config.PlayerOptions.noRollingGunFight then
    local intervale
    CreateThread(function()
        while true do
            Wait(0)
            intervale = true

            if IsPlayerFreeAiming(oncache.player.playerid) and IsControlPressed(0, 22) then intervale = false
                ClearPedTasksImmediately(oncache.player.pedid)
            end   

            if intervale then
                Wait(500)
            end
        end
    end)
end

if Config.PlayerOptions.noPunchRunning then
    local intervale
    CreateThread(function()
        while true do
            Wait(0)
            intervale = true
            if IsPedRunningMeleeTask(oncache.player.pedid) then intervale = false
                ClearPedTasksImmediately(oncache.player.pedid)
            end

            if intervale then
                Wait(500)
            end
        end
    end)
end