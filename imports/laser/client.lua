local SetTextScale <const> = SetTextScale
local SetTextFont <const> = SetTextFont
local SetTextProportional <const> = SetTextProportional
local SetTextColour <const> = SetTextColour
local SetTextEntry <const> = SetTextEntry
local SetTextCentre <const> = SetTextCentre
local AddTextComponentString <const> = AddTextComponentString
local SetDrawOrigin <const> = SetDrawOrigin
local DrawText <const> = DrawText
local DrawSprite <const> = DrawSprite
local DrawLine <const> = DrawLine
local ClearDrawOrigin <const> = ClearDrawOrigin
local GetEntityModel <const> = GetEntityModel
local GetModelDimensions <const> = GetModelDimensions
local GetEntityMatrix <const> = GetEntityMatrix
local GetGroundZFor_3dCoord <const> = GetGroundZFor_3dCoord
local GetGameplayCamRot <const> = GetGameplayCamRot
local GetGameplayCamCoord <const> = GetGameplayCamCoord
local GetShapeTestResult <const> = GetShapeTestResult
local StartShapeTestRay <const> = StartShapeTestRay
local math <const> = math
local string <const> = string


local function Draw3dText(coords, text, lines)
    if not lines then lines = 1 end
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawSprite("commonmenu", "gradient_bgd", 0.0, 0.0+0.0125 * lines, 0.017+ factor, 0.03 * lines, 0.1, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function DrawEntityBoundingBox(entity, color)
    local model = GetEntityModel(entity)
    local min, max = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)
    local dim = { 
		x = 0.5*(max.x - min.x), 
		y = 0.5*(max.y - min.y), 
		z = 0.5*(max.z - min.z)
	}

    local FUR = {
		x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x, 
		y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y, 
		z = 0
    }

    local _, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z
    FUR.z = FUR.z + 2 * dim.z

    local BLL = {
        x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
        y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
        z = 0
    }

    local _, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = BLL_z
    local edge1 = BLL
    local edge5 = FUR

    local edge2 = {
        x = edge1.x + 2 * dim.y*rightVector.x,
        y = edge1.y + 2 * dim.y*rightVector.y,
        z = edge1.z + 2 * dim.y*rightVector.z
    }

    local edge3 = {
        x = edge2.x + 2 * dim.z*upVector.x,
        y = edge2.y + 2 * dim.z*upVector.y,
        z = edge2.z + 2 * dim.z*upVector.z
    }

    local edge4 = {
        x = edge1.x + 2 * dim.z*upVector.x,
        y = edge1.y + 2 * dim.z*upVector.y,
        z = edge1.z + 2 * dim.z*upVector.z
    }

    local edge6 = {
        x = edge5.x - 2 * dim.y*rightVector.x,
        y = edge5.y - 2 * dim.y*rightVector.y,
        z = edge5.z - 2 * dim.y*rightVector.z
    }

    local edge7 = {
        x = edge6.x - 2 * dim.z*upVector.x,
        y = edge6.y - 2 * dim.z*upVector.y,
        z = edge6.z - 2 * dim.z*upVector.z
    }

    local edge8 = {
        x = edge5.x - 2 * dim.z*upVector.x,
        y = edge5.y - 2 * dim.z*upVector.y,
        z = edge5.z - 2 * dim.z*upVector.z
    }

    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end

local function RotationToDirection(rotation)
    local adjustedRotation = { 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = { 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local _, b, c, _, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, supv.oncache.pedid, 0))
	return b, c, e
end

local GetEntityCoords <const> = GetEntityCoords
local IsEntityAPed <const> = IsEntityAPed
local IsEntityAnObject <const> = IsEntityAnObject
local IsEntityAVehicle <const> = IsEntityAVehicle
local DrawMarker <const> = DrawMarker
local IsControlJustReleased <const> = IsControlJustReleased
local vec3 <const> = vec3
local GetEntityArchetypeName <const> = GetEntityArchetypeName
local PlayerPedId <const> = PlayerPedId

local function Show(cb)
    local color = {r = 255, g = 0, b = 0, a = 200}
    local position = GetEntityCoords(PlayerPedId())
    local hit, coords, entity = RayCastCamera(1000.0)
    if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
        local entityCoord = GetEntityCoords(entity)
        DrawEntityBoundingBox(entity, color)
        DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
        Draw3dText(vec3(entityCoord.x, entityCoord.y, entityCoord.z), ("model : %s | name : %s\nPress [~c~E~s~] to ~g~validate~s~ ~p~entity~s~"):format(GetEntityModel(entity), GetEntityArchetypeName(entity)), 2)
        if IsControlJustReleased(0, 38) then
            cb(entity, GetEntityModel(entity), GetEntityArchetypeName(entity))
        end
    elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
        DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
        DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
    end
end

return {
    show = Show
}