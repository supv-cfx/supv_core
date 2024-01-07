if supv.game == 'redm' then return end
local on <const> = require 'imports.on.client'

function supv.getBuild()
    return supv.build
end

on.net('supv_core:setVehiclesProperties', function(netId, properties)
    local timeout = 100
    while not NetworkDoesEntityExistWithNetworkId(netId) and timeout > 0 do
        Wait(0)
        timeout -= 1
    end
    if timeout > 0 then
        supv.setVehicleProperties(NetToVeh(netId), properties)
    end
end)

callback.register('supv_core:getVehiclesProperties', function(netId, filter)
    local timeout = 100
    while not NetworkDoesEntityExistWithNetworkId(netId) and timeout > 0 do
        Wait(0)
        timeout -= 1
    end
    if timeout > 0 then
        return supv.getVehicleProperties(NetToVeh(netId), filter)
    end
end)

function supv.getVehicleProperties(vehicle, filter)
    if DoesEntityExist(vehicle) then
        if filter then
            local data = {}
            for k in pairs(filter) do
                if  k == 'model' then
                    data[k] = GetEntityModel(vehicle)
                elseif k == 'plate' then
                    data[k] = GetVehicleNumberPlateText(vehicle)
                elseif k == 'plateIndex' then
                    data[k] = GetVehicleNumberPlateTextIndex(vehicle)
                elseif k == 'bodyHealth' then
                    data[k] = math.floor(GetVehicleBodyHealth(vehicle) + 0.5)
                elseif k == 'engineHealth' then
                    data[k] = math.floor(GetVehicleEngineHealth(vehicle) + 0.5)
                elseif k == 'tankHealth' then
                    data[k] = math.floor(GetVehiclePetrolTankHealth(vehicle) + 0.5)
                elseif k == 'fuelLevel' then
                    data[k] = math.floor(GetVehicleFuelLevel(vehicle) + 0.5)
                elseif k == 'oilLevel' then
                    data[k] = math.floor(GetVehicleOilLevel(vehicle) + 0.5)
                elseif k == 'dirtLevel' then
                    data[k] = math.floor(GetVehicleDirtLevel(vehicle) + 0.5)
                elseif k == 'paintType1' then
                    data[k] = GetVehicleModColor_1(vehicle)
                elseif k == 'paintType2' then
                    data[k] = GetVehicleModColor_2(vehicle)
                elseif k == 'color1' then
                    data[k] = GetIsVehiclePrimaryColourCustom(vehicle) and { GetVehicleColours(vehicle) }
                elseif k == 'color2' then
                    data[k] = GetIsVehicleSecondaryColourCustom(vehicle) and { GetVehicleExtraColours(vehicle) }
                elseif k == 'pearlescentColor' then
                    data[k] = GetVehicleExtraColours(vehicle)
                elseif k == 'interiorColor' then
                    data[k] = GetVehicleInteriorColor(vehicle)
                elseif k == 'dashboardColor' then
                    data[k] = GetVehicleDashboardColour(vehicle)
                elseif k == 'wheelColor' then
                    data[k] = GetVehicleExtraColours(vehicle)
                elseif k == 'wheelWidth' then
                    data[k] = GetVehicleWheelWidth(vehicle)
                elseif k == 'wheelSize' then
                    data[k] = GetVehicleWheelSize(vehicle)
                elseif k == 'wheels' then
                    data[k] = GetVehicleWheelType(vehicle)
                elseif k == 'windowTint' then
                    data[k] = GetVehicleWindowTint(vehicle)
                elseif k == 'xenonColor' then
                    data[k] = GetVehicleXenonLightsColor(vehicle)
                elseif k == 'neonEnabled' then
                    data[k] = {}
                    for i = 0, 3 do
                        data[k][i + 1] = IsVehicleNeonLightEnabled(vehicle, i)
                    end
                elseif k == 'neonColor' then
                    data[k] = { GetVehicleNeonLightsColour(vehicle) }
                elseif k == 'extras' then
                    data[k] = {}
                    for i = 1, 15 do
                        if DoesExtraExist(vehicle, i) then
                            data[k][i] = IsVehicleExtraTurnedOn(vehicle, i) and 0 or 1
                        end
                    end
                elseif k == 'tyreSmokeColor' then
                    data[k] = { GetVehicleTyreSmokeColor(vehicle) }
                elseif k == 'modSpoilers' then
                    data[k] = GetVehicleMod(vehicle, 0)
                elseif k == 'modFrontBumper' then
                    data[k] = GetVehicleMod(vehicle, 1)
                elseif k == 'modRearBumper' then
                    data[k] = GetVehicleMod(vehicle, 2)
                elseif k == 'modSideSkirt' then
                    data[k] = GetVehicleMod(vehicle, 3)
                elseif k == 'modExhaust' then
                    data[k] = GetVehicleMod(vehicle, 4)
                elseif k == 'modFrame' then
                    data[k] = GetVehicleMod(vehicle, 5)
                elseif k == 'modGrille' then
                    data[k] = GetVehicleMod(vehicle, 6)
                elseif k == 'modHood' then
                    data[k] = GetVehicleMod(vehicle, 7)
                elseif k == 'modFender' then
                    data[k] = GetVehicleMod(vehicle, 8)
                elseif k == 'modRightFender' then
                    data[k] = GetVehicleMod(vehicle, 9)
                elseif k == 'modRoof' then
                    data[k] = GetVehicleMod(vehicle, 10)
                elseif k == 'modEngine' then
                    data[k] = GetVehicleMod(vehicle, 11)
                elseif k == 'modBrakes' then
                    data[k] = GetVehicleMod(vehicle, 12)
                elseif k == 'modTransmission' then
                    data[k] = GetVehicleMod(vehicle, 13)
                elseif k == 'modHorns' then
                    data[k] = GetVehicleMod(vehicle, 14)
                elseif k == 'modSuspension' then
                    data[k] = GetVehicleMod(vehicle, 15)
                elseif k == 'modArmor' then
                    data[k] = GetVehicleMod(vehicle, 16)
                elseif k == 'modNitrous' then
                    data[k] = GetVehicleMod(vehicle, 17)
                elseif k == 'modTurbo' then
                    data[k] = IsToggleModOn(vehicle, 18)
                elseif k == 'modSubwoofer' then
                    data[k] = GetVehicleMod(vehicle, 19)
                elseif k == 'modSmokeEnabled' then
                    data[k] = IsToggleModOn(vehicle, 20)
                elseif k == 'modHydraulics' then
                    data[k] = IsToggleModOn(vehicle, 21)
                elseif k == 'modXenon' then
                    data[k] = IsToggleModOn(vehicle, 22)
                elseif k == 'modFrontWheels' then
                    data[k] = GetVehicleMod(vehicle, 23)
                elseif k == 'modBackWheels' then
                    data[k] = GetVehicleMod(vehicle, 24)
                elseif k == 'modCustomTiresF' then
                    data[k] = GetVehicleModVariation(vehicle, 23)
                elseif k == 'modCustomTiresR' then
                    data[k] = GetVehicleModVariation(vehicle, 24)
                elseif k == 'modPlateHolder' then
                    data[k] = GetVehicleMod(vehicle, 25)
                elseif k == 'modVanityPlate' then
                    data[k] = GetVehicleMod(vehicle, 26)
                elseif k == 'modTrimA' then
                    data[k] = GetVehicleMod(vehicle, 27)
                elseif k == 'modOrnaments' then
                    data[k] = GetVehicleMod(vehicle, 28)
                elseif k == 'modDashboard' then
                    data[k] = GetVehicleMod(vehicle, 29)
                elseif k == 'modDial' then
                    data[k] = GetVehicleMod(vehicle, 30)
                elseif k == 'modDoorSpeaker' then
                    data[k] = GetVehicleMod(vehicle, 31)
                elseif k == 'modSeats' then
                    data[k] = GetVehicleMod(vehicle, 32)
                elseif k == 'modSteeringWheel' then
                    data[k] = GetVehicleMod(vehicle, 33)
                elseif k == 'modShifterLeavers' then
                    data[k] = GetVehicleMod(vehicle, 34)
                elseif k == 'modAPlate' then
                    data[k] = GetVehicleMod(vehicle, 35)
                elseif k == 'modSpeakers' then
                    data[k] = GetVehicleMod(vehicle, 36)
                elseif k == 'modTrunk' then
                    data[k] = GetVehicleMod(vehicle, 37)
                elseif k == 'modHydrolic' then
                    data[k] = GetVehicleMod(vehicle, 38)
                elseif k == 'modEngineBlock' then
                    data[k] = GetVehicleMod(vehicle, 39)
                elseif k == 'modAirFilter' then
                    data[k] = GetVehicleMod(vehicle, 40)
                elseif k == 'modStruts' then
                    data[k] = GetVehicleMod(vehicle, 41)
                elseif k == 'modArchCover' then
                    data[k] = GetVehicleMod(vehicle, 42)
                elseif k == 'modAerials' then
                    data[k] = GetVehicleMod(vehicle, 43)
                elseif k == 'modTrimB' then
                    data[k] = GetVehicleMod(vehicle, 44)
                elseif k == 'modTank' then
                    data[k] = GetVehicleMod(vehicle, 45)
                elseif k == 'modWindows' then
                    data[k] = GetVehicleMod(vehicle, 46)
                elseif k == 'modDoorR' then
                    data[k] = GetVehicleMod(vehicle, 47)
                elseif k == 'modLivery' then
                    data[k] = GetVehicleMod(vehicle, 48)
                elseif k == 'modRoofLivery' then
                    data[k] = GetVehicleRoofLivery(vehicle)
                elseif k == 'modLightbar' then
                    data[k] = GetVehicleMod(vehicle, 49)
                elseif k == 'windows' then
                    data[k] = {}
                    local windows = 0
                    for i = 0, 7 do
                        RollUpWindow(vehicle, i)

                        if not IsVehicleWindowIntact(vehicle, i) then
                            windows += 1
                            data[k][windows] = i
                        end
                    end
                elseif k == 'doors' then
                    data[k] = {}
                    local doors = 0
                    for i = 0, 5 do
                        if IsVehicleDoorDamaged(vehicle, i) then
                            doors += 1
                            data[k][doors] = i
                        end
                    end
                elseif k == 'tyres' then
                    data[k] = {}
                    for i = 0, 7 do
                        if IsVehicleTyreBurst(vehicle, i, false) then
                            data[k][i] = IsVehicleTyreBurst(vehicle, i, true) and 2 or 1
                        end
                    end
                elseif k == 'bulletProofTyres' then
                    data[k] = GetVehicleTyresCanBurst(vehicle)
                elseif k == 'driftTyres' and supv.build >= 2372 then
                    data[k] = GetDriftTyresEnabled(vehicle)
                elseif k == 'leftHeadlight' then
                    data[k] = GetIsLeftVehicleHeadlightDamaged(vehicle)
                elseif k == 'rightHeadlight' then
                    data[k] = GetIsRightVehicleHeadlightDamaged(vehicle)
                elseif k == 'frontBumper' then
                    data[k] = IsVehicleBumperBrokenOff(vehicle, true)
                elseif k == 'rearBumper' then
                    data[k] = IsVehicleBumperBrokenOff(vehicle, false)
                end
            end
            return next(data) and data or false
        else
            ---@type number | number[], number | number[]
            local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
            local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
            local paintType1 = GetVehicleModColor_1(vehicle)
            local paintType2 = GetVehicleModColor_2(vehicle)

            if GetIsVehiclePrimaryColourCustom(vehicle) then
                colorPrimary = { GetVehicleCustomPrimaryColour(vehicle) }
            end

            if GetIsVehicleSecondaryColourCustom(vehicle) then
                colorSecondary = { GetVehicleCustomSecondaryColour(vehicle) }
            end

            local extras = {}

            for i = 1, 15 do
                if DoesExtraExist(vehicle, i) then
                    extras[i] = IsVehicleExtraTurnedOn(vehicle, i) and 0 or 1
                end
            end

            local modLiveryCount = GetVehicleLiveryCount(vehicle)
            local modLivery = GetVehicleLivery(vehicle)

            if modLiveryCount == -1 or modLivery == -1 then
                modLivery = GetVehicleMod(vehicle, 48)
            end

            local damage = {
                windows = {},
                doors = {},
                tyres = {},
            }

            local windows = 0

            for i = 0, 7 do
                RollUpWindow(vehicle, i)

                if not IsVehicleWindowIntact(vehicle, i) then
                    windows += 1
                    damage.windows[windows] = i
                end
            end

            local doors = 0

            for i = 0, 5 do
                if IsVehicleDoorDamaged(vehicle, i) then
                    doors += 1
                    damage.doors[doors] = i
                end
            end

            for i = 0, 7 do
                if IsVehicleTyreBurst(vehicle, i, false) then
                    damage.tyres[i] = IsVehicleTyreBurst(vehicle, i, true) and 2 or 1
                end
            end

            local neons = {}

            for i = 0, 3 do
                neons[i + 1] = IsVehicleNeonLightEnabled(vehicle, i)
            end

            return {
                model = GetEntityModel(vehicle),
                plate = GetVehicleNumberPlateText(vehicle),
                plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
                bodyHealth = math.floor(GetVehicleBodyHealth(vehicle) + 0.5),
                engineHealth = math.floor(GetVehicleEngineHealth(vehicle) + 0.5),
                tankHealth = math.floor(GetVehiclePetrolTankHealth(vehicle) + 0.5),
                fuelLevel = math.floor(GetVehicleFuelLevel(vehicle) + 0.5),
                oilLevel = math.floor(GetVehicleOilLevel(vehicle) + 0.5),
                dirtLevel = math.floor(GetVehicleDirtLevel(vehicle) + 0.5),
                paintType1 = paintType1,
                paintType2 = paintType2,
                color1 = colorPrimary,
                color2 = colorSecondary,
                pearlescentColor = pearlescentColor,
                interiorColor = GetVehicleInteriorColor(vehicle),
                dashboardColor = GetVehicleDashboardColour(vehicle),
                wheelColor = wheelColor,
                wheelWidth = GetVehicleWheelWidth(vehicle),
                wheelSize = GetVehicleWheelSize(vehicle),
                wheels = GetVehicleWheelType(vehicle),
                windowTint = GetVehicleWindowTint(vehicle),
                xenonColor = GetVehicleXenonLightsColor(vehicle),
                neonEnabled = neons,
                neonColor = { GetVehicleNeonLightsColour(vehicle) },
                extras = extras,
                tyreSmokeColor = { GetVehicleTyreSmokeColor(vehicle) },
                modSpoilers = GetVehicleMod(vehicle, 0),
                modFrontBumper = GetVehicleMod(vehicle, 1),
                modRearBumper = GetVehicleMod(vehicle, 2),
                modSideSkirt = GetVehicleMod(vehicle, 3),
                modExhaust = GetVehicleMod(vehicle, 4),
                modFrame = GetVehicleMod(vehicle, 5),
                modGrille = GetVehicleMod(vehicle, 6),
                modHood = GetVehicleMod(vehicle, 7),
                modFender = GetVehicleMod(vehicle, 8),
                modRightFender = GetVehicleMod(vehicle, 9),
                modRoof = GetVehicleMod(vehicle, 10),
                modEngine = GetVehicleMod(vehicle, 11),
                modBrakes = GetVehicleMod(vehicle, 12),
                modTransmission = GetVehicleMod(vehicle, 13),
                modHorns = GetVehicleMod(vehicle, 14),
                modSuspension = GetVehicleMod(vehicle, 15),
                modArmor = GetVehicleMod(vehicle, 16),
                modNitrous = GetVehicleMod(vehicle, 17),
                modTurbo = IsToggleModOn(vehicle, 18),
                modSubwoofer = GetVehicleMod(vehicle, 19),
                modSmokeEnabled = IsToggleModOn(vehicle, 20),
                modHydraulics = IsToggleModOn(vehicle, 21),
                modXenon = IsToggleModOn(vehicle, 22),
                modFrontWheels = GetVehicleMod(vehicle, 23),
                modBackWheels = GetVehicleMod(vehicle, 24),
                modCustomTiresF = GetVehicleModVariation(vehicle, 23),
                modCustomTiresR = GetVehicleModVariation(vehicle, 24),
                modPlateHolder = GetVehicleMod(vehicle, 25),
                modVanityPlate = GetVehicleMod(vehicle, 26),
                modTrimA = GetVehicleMod(vehicle, 27),
                modOrnaments = GetVehicleMod(vehicle, 28),
                modDashboard = GetVehicleMod(vehicle, 29),
                modDial = GetVehicleMod(vehicle, 30),
                modDoorSpeaker = GetVehicleMod(vehicle, 31),
                modSeats = GetVehicleMod(vehicle, 32),
                modSteeringWheel = GetVehicleMod(vehicle, 33),
                modShifterLeavers = GetVehicleMod(vehicle, 34),
                modAPlate = GetVehicleMod(vehicle, 35),
                modSpeakers = GetVehicleMod(vehicle, 36),
                modTrunk = GetVehicleMod(vehicle, 37),
                modHydrolic = GetVehicleMod(vehicle, 38),
                modEngineBlock = GetVehicleMod(vehicle, 39),
                modAirFilter = GetVehicleMod(vehicle, 40),
                modStruts = GetVehicleMod(vehicle, 41),
                modArchCover = GetVehicleMod(vehicle, 42),
                modAerials = GetVehicleMod(vehicle, 43),
                modTrimB = GetVehicleMod(vehicle, 44),
                modTank = GetVehicleMod(vehicle, 45),
                modWindows = GetVehicleMod(vehicle, 46),
                modDoorR = GetVehicleMod(vehicle, 47),
                modLivery = modLivery,
                modRoofLivery = GetVehicleRoofLivery(vehicle),
                modLightbar = GetVehicleMod(vehicle, 49),
                windows = damage.windows,
                doors = damage.doors,
                tyres = damage.tyres,
                bulletProofTyres = GetVehicleTyresCanBurst(vehicle),
                driftTyres = supv.build >= 2372 and GetDriftTyresEnabled(vehicle),
                -- no setters?
                -- leftHeadlight = GetIsLeftVehicleHeadlightDamaged(vehicle),
                -- rightHeadlight = GetIsRightVehicleHeadlightDamaged(vehicle),
                -- frontBumper = IsVehicleBumperBrokenOff(vehicle, true),
                -- rearBumper = IsVehicleBumperBrokenOff(vehicle, false),
            }
        end
    end
end

function supv.setVehicleProperties(vehicle, props, fixe)
    if not DoesEntityExist(vehicle) then
        error(("Unable to set vehicle properties for '%s' (entity does not exist)"):
        format(vehicle))
    end

    if NetworkGetEntityIsNetworked(vehicle) and NetworkGetEntityOwner(vehicle) ~= cache.playerid then
        error(("Unable to set vehicle properties for '%s' (client is not entity owner)"):format(vehicle))
    end

    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

    SetVehicleModKit(vehicle, 0)
    -- SetVehicleAutoRepairDisabled(vehicle, true)

    if props.extras then
        for id, disable in pairs(props.extras) do
            SetVehicleExtra(vehicle, tonumber(id) --[[@as number]], disable == 1)
        end
    end

    if props.plate then
        SetVehicleNumberPlateText(vehicle, props.plate)
    end

    if props.plateIndex then
        SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
    end

    if props.bodyHealth then
        SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
    end

    if props.engineHealth then
        SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
    end

    if props.tankHealth then
        SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0)
    end

    if props.fuelLevel then
        SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
    end

    if props.oilLevel then
        SetVehicleOilLevel(vehicle, props.oilLevel + 0.0)
    end

    if props.dirtLevel then
        SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
    end

    if props.color1 then
        if type(props.color1) == 'number' then
            ClearVehicleCustomPrimaryColour(vehicle)
            SetVehicleColours(vehicle, props.color1 --[[@as number]], colorSecondary --[[@as number]])
        else
            if props.paintType1 then SetVehicleModColor_1(vehicle, props.paintType1, colorPrimary, pearlescentColor) end

            SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
        end
    end

    if props.color2 then
        if type(props.color2) == 'number' then
            ClearVehicleCustomSecondaryColour(vehicle)
            SetVehicleColours(vehicle, props.color1 or colorPrimary --[[@as number]], props.color2 --[[@as number]])
        else
            if props.paintType2 then SetVehicleModColor_2(vehicle, props.paintType2, colorSecondary) end

            SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
        end
    end

    if props.pearlescentColor or props.wheelColor then
        SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor or wheelColor)
    end

    if props.interiorColor then
        SetVehicleInteriorColor(vehicle, props.interiorColor)
    end

    if props.dashboardColor then
        SetVehicleDashboardColor(vehicle, props.dashboardColor)
    end

    if props.wheels then
        SetVehicleWheelType(vehicle, props.wheels)
    end

    if props.wheelSize then
        SetVehicleWheelSize(vehicle, props.wheelSize)
    end

    if props.wheelWidth then
        SetVehicleWheelWidth(vehicle, props.wheelWidth)
    end

    if props.windowTint then
        SetVehicleWindowTint(vehicle, props.windowTint)
    end

    if props.neonEnabled then
        for i = 1, #props.neonEnabled do
            SetVehicleNeonLightEnabled(vehicle, i - 1, props.neonEnabled[i])
        end
    end

    if props.windows then
        for i = 1, #props.windows do
            RemoveVehicleWindow(vehicle, props.windows[i])
        end
    end

    if props.doors then
        for i = 1, #props.doors do
            SetVehicleDoorBroken(vehicle, props.doors[i], true)
        end
    end

    if props.tyres then
        for tyre, state in pairs(props.tyres) do
            SetVehicleTyreBurst(vehicle, tonumber(tyre) --[[@as number]], state == 2, 1000.0)
        end
    end

    if props.neonColor then
        SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
    end

    if props.modSmokeEnabled ~= nil then
        ToggleVehicleMod(vehicle, 20, props.modSmokeEnabled)
    end

    if props.tyreSmokeColor then
        SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
    end

    if props.modSpoilers then
        SetVehicleMod(vehicle, 0, props.modSpoilers, false)
    end

    if props.modFrontBumper then
        SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
    end

    if props.modRearBumper then
        SetVehicleMod(vehicle, 2, props.modRearBumper, false)
    end

    if props.modSideSkirt then
        SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
    end

    if props.modExhaust then
        SetVehicleMod(vehicle, 4, props.modExhaust, false)
    end

    if props.modFrame then
        SetVehicleMod(vehicle, 5, props.modFrame, false)
    end

    if props.modGrille then
        SetVehicleMod(vehicle, 6, props.modGrille, false)
    end

    if props.modHood then
        SetVehicleMod(vehicle, 7, props.modHood, false)
    end

    if props.modFender then
        SetVehicleMod(vehicle, 8, props.modFender, false)
    end

    if props.modRightFender then
        SetVehicleMod(vehicle, 9, props.modRightFender, false)
    end

    if props.modRoof then
        SetVehicleMod(vehicle, 10, props.modRoof, false)
    end

    if props.modEngine then
        SetVehicleMod(vehicle, 11, props.modEngine, false)
    end

    if props.modBrakes then
        SetVehicleMod(vehicle, 12, props.modBrakes, false)
    end

    if props.modTransmission then
        SetVehicleMod(vehicle, 13, props.modTransmission, false)
    end

    if props.modHorns then
        SetVehicleMod(vehicle, 14, props.modHorns, false)
    end

    if props.modSuspension then
        SetVehicleMod(vehicle, 15, props.modSuspension, false)
    end

    if props.modArmor then
        SetVehicleMod(vehicle, 16, props.modArmor, false)
    end

    if props.modNitrous then
        SetVehicleMod(vehicle, 17, props.modNitrous, false)
    end

    if props.modTurbo ~= nil then
        ToggleVehicleMod(vehicle, 18, props.modTurbo)
    end

    if props.modSubwoofer ~= nil then
        ToggleVehicleMod(vehicle, 19, props.modSubwoofer)
    end

    if props.modHydraulics ~= nil then
        ToggleVehicleMod(vehicle, 21, props.modHydraulics)
    end

    if props.modXenon ~= nil then
        ToggleVehicleMod(vehicle, 22, props.modXenon)
    end

    if props.xenonColor then
        SetVehicleXenonLightsColor(vehicle, props.xenonColor)
    end

    if props.modFrontWheels then
        SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
    end

    if props.modBackWheels then
        SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
    end

    if props.modPlateHolder then
        SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
    end

    if props.modVanityPlate then
        SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
    end

    if props.modTrimA then
        SetVehicleMod(vehicle, 27, props.modTrimA, false)
    end

    if props.modOrnaments then
        SetVehicleMod(vehicle, 28, props.modOrnaments, false)
    end

    if props.modDashboard then
        SetVehicleMod(vehicle, 29, props.modDashboard, false)
    end

    if props.modDial then
        SetVehicleMod(vehicle, 30, props.modDial, false)
    end

    if props.modDoorSpeaker then
        SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
    end

    if props.modSeats then
        SetVehicleMod(vehicle, 32, props.modSeats, false)
    end

    if props.modSteeringWheel then
        SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
    end

    if props.modShifterLeavers then
        SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
    end

    if props.modAPlate then
        SetVehicleMod(vehicle, 35, props.modAPlate, false)
    end

    if props.modSpeakers then
        SetVehicleMod(vehicle, 36, props.modSpeakers, false)
    end

    if props.modTrunk then
        SetVehicleMod(vehicle, 37, props.modTrunk, false)
    end

    if props.modHydrolic then
        SetVehicleMod(vehicle, 38, props.modHydrolic, false)
    end

    if props.modEngineBlock then
        SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
    end

    if props.modAirFilter then
        SetVehicleMod(vehicle, 40, props.modAirFilter, false)
    end

    if props.modStruts then
        SetVehicleMod(vehicle, 41, props.modStruts, false)
    end

    if props.modArchCover then
        SetVehicleMod(vehicle, 42, props.modArchCover, false)
    end

    if props.modAerials then
        SetVehicleMod(vehicle, 43, props.modAerials, false)
    end

    if props.modTrimB then
        SetVehicleMod(vehicle, 44, props.modTrimB, false)
    end

    if props.modTank then
        SetVehicleMod(vehicle, 45, props.modTank, false)
    end

    if props.modWindows then
        SetVehicleMod(vehicle, 46, props.modWindows, false)
    end

    if props.modDoorR then
        SetVehicleMod(vehicle, 47, props.modDoorR, false)
    end

    if props.modLivery then
        SetVehicleMod(vehicle, 48, props.modLivery, false)
        SetVehicleLivery(vehicle, props.modLivery)
    end

    if props.modRoofLivery then
        SetVehicleRoofLivery(vehicle, props.modRoofLivery)
    end

    if props.modLightbar then
        SetVehicleMod(vehicle, 49, props.modLightbar, false)
    end

    if props.bulletProofTyres ~= nil then
        SetVehicleTyresCanBurst(vehicle, props.bulletProofTyres)
    end

    if supv.build >= 2372 and props.driftTyres then
        SetDriftTyresEnabled(vehicle, true)
    end

    if fixe then
        SetVehicleFixed(vehicle)
    end

    return true
end