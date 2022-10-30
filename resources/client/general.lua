if not Config.Resource then return end

local Traffic <const>, Npc <const>, VehicleParked <const> = Config.Traffic.amount.traffic, Config.Traffic.amount.npc, Config.Traffic.amount.parked
local EnableBoats <const>, EnableTrain <const>, EnableGarbageTruck <const>, EnablePolice <const> = Config.Traffic.enable.boats, Config.Traffic.enable.trains, Config.Traffic.enable.garbageTruck, Config.Traffic.enable.polices

local GetEntityModel <const> = GetEntityModel
local RemoveAllPickupsOfType <const> = RemoveAllPickupsOfType
local GetGamePool <const> = GetGamePool
local DisplayRadar <const> = DisplayRadar
local DisableControlAction <const> = DisableControlAction
local IsControlPressed <const> = IsControlPressed
local SetRadarBigmapEnabled <const> = SetRadarBigmapEnabled
local RequestScaleformMovie <const> = RequestScaleformMovie
local BeginScaleformMovieMethod <const> = BeginScaleformMovieMethod
local ScaleformMovieMethodAddParamInt <const> = ScaleformMovieMethodAddParamInt
local EndScaleformMovieMethod <const> = EndScaleformMovieMethod
local GetEntityCoords <const> = GetEntityCoords
local PlayerPedId <const> = PlayerPedId
local IsPedArmed <const> = IsPedArmed

local function ClearPickupsFromRewards()
    CreateThread(function()
        while true do
            Wait((6*10000)*30) -- every 30min
            if Config.DevMod then
                print(json.encode(GetGamePool('CPickup')))
            end
            RemoveAllPickupsOfType(0xA9355DCD) -- shotgun
            RemoveAllPickupsOfType(0xDF711959) -- carbine-rifle
            RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
        end
    end)
end

CreateThread(function()

    while not next(oncache) do Wait(50) end

    SetRandomBoats(EnableBoats)
    SetRandomTrains(EnableTrain)
    SetGarbageTrucks(EnableGarbageTruck)

    SetCreateRandomCops(EnablePolice)
    SetCreateRandomCopsNotOnScenarios(EnablePolice)
    SetCreateRandomCopsOnScenarios(EnablePolice)
    SetDispatchCopsForPlayer(oncache.playerid, EnablePolice)

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
        DisablePlayerVehicleRewards(oncache.playerid)
    end

    if not Config.Rewards.npc then
        for i = 1, #Config.Pickups.Blacklisted do
            ToggleUsePickupsForPlayer(oncache.playerid, Config.Pickups.Blacklisted[i], false)
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
                    if Config.DevMod then
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
            SetPedConfigFlag(PlayerPedId(), list[i].flagId, list[i].value)
        end
    end

    if not Config.PlayerOptions.canRagdoll then
        SetPedCanRagdoll(PlayerPedId(), false) 
    end

    if Config.PlayerOptions.gotDamagedOnlyByPlayers then
        SetEntityOnlyDamagedByPlayer(PlayerPedId(), true)
    end

    if not Config.PlayerOptions.showRadar.visible then
        DisplayRadar(false)
    else
        DisplayRadar(true)
    end

    if Config.PlayerOptions.canDoDriveBy == false then
        SetPlayerCanDoDriveBy(oncache.playerid, false)
    elseif Config.PlayerOptions.canDoDriveBy == true then
        SetPlayerCanDoDriveBy(oncache.playerid, true)
    end

end)


if not Config.Traffic.enable.polices then

    local coords <const>, sleep = vec3(409.160736, -990.443726, 28.843187), 0

    CreateThread(function()
        while true do
            sleep = 2500
            if #(GetEntityCoords(PlayerPedId()) - coords) < 50 then sleep = 750
                ClearAreaOfCops(coords.x, coords.y, coords.z, 50.0)
            end
            Wait(sleep)
        end
    end)
end


if Config.PlayerOptions.showRadar.visible == 'vehicle' then

    local vehicleBlacklisted <const>, currentValue = Config.PlayerOptions.showRadar.blacklist, false

    local function ShowRadar(bool)
        if currentValue ~= bool then
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
                if not vehicleBlacklisted[GetEntityModel(oncache.currentvehicle)] then
                    if Config.PlayerOptions.showRadarArmourHealth then
                        SetRadarBigmapEnabled(false, false)
                    end
                    ShowRadar(true)
                end
                if oncache.currentvehicle == 0 then
                    ShowRadar(false)
                end
            end
        else
            while true do
                Wait(1000)
                if oncache.currentvehicle == 0 then
                    ShowRadar(false)
                else
                    if Config.PlayerOptions.showRadarArmourHealth then
                        SetRadarBigmapEnabled(false, false)
                    end
                    ShowRadar(true)
                end
            end
        end
    end)
end


if not Config.Rewards.vehicle then
    local listeVehicle <const> = Config.Rewards.listVehicle
    local DisablePlayerVehicleRewards <const> = DisablePlayerVehicleRewards

    local function RemoveRewardsFromPoliceVehicle() -- for more secure

        local time <const>, timer = 5000, 0
        CreateThread(function()
            timer = GetGameTimer()
            while true do
                Wait(1)
    
                DisablePlayerVehicleRewards(oncache.playerid)
                if (GetGameTimer() - time > timer) then
                    return false
                end
                
            end
        end)
    end

    CreateThread(function()
        while true do
            Wait(500)

            if listeVehicle[GetEntityModel(GetVehiclePedIsTryingToEnter(PlayerPedId()))] then
                RemoveRewardsFromPoliceVehicle()
                Wait(2500)
            end
        end
    end)
end

if Config.PlayerOptions.hideHudComponent.enable then
    local intervale
    local list <const> = Config.PlayerOptions.hideHudComponent.list
    local scopeList <const> = Config.PlayerOptions.hideHudComponent.scopeList
    local IsHudComponentActive <const> = IsHudComponentActive
    local HideHudComponentThisFrame <const> = HideHudComponentThisFrame
    local GetCurrentPedWeapon <const> = GetCurrentPedWeapon
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
                        if IsPedArmed(PlayerPedId(), 4) then intervale = false 
                            local _, hash = GetCurrentPedWeapon(PlayerPedId(), true)
                            if not scopeList[hash] then
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
    local InvalidateIdleCam <const>, InvalidateVehicleIdleCam <const> = InvalidateIdleCam, InvalidateVehicleIdleCam
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
            if IsPedArmed(PlayerPedId(), 4) then intervale = false
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
    local blacklist, SetUserRadioControlEnabled <const>, SetVehRadioStation <const> = Config.AudioRadio.blacklist, SetUserRadioControlEnabled, SetVehRadioStation
    CreateThread(function()
        if Config.AudioRadio.enable == true then
            while true do
                Wait(1000)
                if blacklist[GetEntityModel(oncache.currentvehicle)] then
                    SetUserRadioControlEnabled(false)
                    SetVehRadioStation(oncache.currentvehicle, "OFF")
                end
            end
        elseif Config.AudioRadio.enable == 'full' then
            while true do
                Wait(1000)
                if oncache.currentvehicle then
                    SetUserRadioControlEnabled(false)
                    SetVehRadioStation(oncache.currentvehicle, "OFF")
                end
            end
        else return false
        end 
    end)
end

if Config.PauseMenu.enable then
    local AddTextEntry <const> = AddTextEntry
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
    local ResetPlayerStamina <const> = ResetPlayerStamina
    CreateThread(function()
        while true do
            Wait(2000)
            ResetPlayerStamina(oncache.playerid)
        end
    end)
end


if Config.PlayerOptions.noRollingGunFight then
    local IsPlayerFreeAiming <const>, ClearPedTasksImmediately <const>, intervale = IsPlayerFreeAiming, ClearPedTasksImmediately
    CreateThread(function()
        while true do
            Wait(0)
            intervale = true

            if IsPlayerFreeAiming(oncache.playerid) and IsControlPressed(0, 22) then intervale = false
                ClearPedTasksImmediately(PlayerPedId())
            end   

            if intervale then
                Wait(500)
            end
        end
    end)
end

if Config.PlayerOptions.noPunchRunning then
    local IsPedRunningMeleeTask <const>, ClearPedTasksImmediately <const>, GetPlayerStamina <const>, ResetPlayerStamina <const>, sleep = IsPedRunningMeleeTask, ClearPedTasksImmediately, GetPlayerStamina, ResetPlayerStamina, 0
    CreateThread(function()
        while true do
            Wait(0)
            if GetPlayerStamina(oncache.playerid) < 100.0 then
                sleep = 100
                if IsPedRunningMeleeTask(PlayerPedId()) then sleep = 0
                    ClearPedTasksImmediately(PlayerPedId())
                    ResetPlayerStamina(oncache.playerid)
                end
            end

            Wait(sleep)
        end
    end)
end

if not Config.PlayerOptions.showRadarArmourHealth then
    local size = 1
    CreateThread(function()
        local minimap = RequestScaleformMovie("minimap")
        Wait(1000)
        SetRadarBigmapEnabled(true, false)       
        while size < 1000 do
            Wait(0)
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
            SetRadarBigmapEnabled(false, false)
            size += 1
        end
    end)
end