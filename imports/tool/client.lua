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

--- Methode

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
	local _, b, c, _, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
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

-- function Laser

local function Show(cb)
    local color = {r = 255, g = 0, b = 0, a = 200}
    local position = GetEntityCoords(PlayerPedId())
    local hit, coords, entity = RayCastCamera(1000.0)
    if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
        local entityCoord = GetEntityCoords(entity)
        DrawEntityBoundingBox(entity, color)
        DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
        Draw3dText(vec3(entityCoord.x, entityCoord.y, entityCoord.z), ("model : %s | name : %s\nPress [~c~E~s~] to ~g~validate~s~ ~p~entity~s~"):format(GetEntityModel(entity),GetEntityArchetypeName(entity)), 2)
        if IsControlJustReleased(0, 38) then
            cb(entity, GetEntityModel(entity), GetEntityArchetypeName(entity))
        end
    elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
        DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
        DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
    end
end

-- Mehtode Object Tool

local BoneList = {
    [1] = {
        {label = "SKEL_L_Hand", index =	18905},
        {label = "SKEL_ROOT", index =	0},
        {label = "FB_R_Brow_Out_000", index =	1356},
        {label = "SKEL_L_Toe0", index =	2108},
        {label = "MH_R_Elbow", index =	2992},
        {label = "SKEL_L_Finger01", index =	4089},
        {label = "SKEL_L_Finger02", index =	4090},
        {label = "SKEL_L_Finger31", index =	4137},
        {label = "SKEL_L_Finger32", index =	4138},
        {label = "SKEL_L_Finger41", index =	4153},
        {label = "SKEL_L_Finger42", index =	4154},
        {label = "SKEL_L_Finger11", index =	4169},
        {label = "SKEL_L_Finger12", index =	4170},
        {label = "SKEL_L_Finger21", index =	4185},
        {label = "SKEL_L_Finger22", index =	4186},
        {label = "RB_L_ArmRoll", index =	5232},
        {label = "IK_R_Hand", index =	6286},
        {label = "RB_R_ThighRoll", index =	6442},
        {label = "SKEL_R_Clavicle", index =	10706},
        {label = "FB_R_Lip_Corner_000", index =	11174},
        {label = "SKEL_Pelvis", index =	11816},
        {label = "IK_Head", index =	12844},
        {label = "SKEL_L_Foot", index =	14201},
        {label = "MH_R_Knee", index =	16335},
        {label = "FB_LowerLipRoot_000", index =	17188},
        {label = "FB_R_Lip_Top_000", index =	17719},
        {label = "FB_R_CheekBone_000", index =	19336},
        {label = "FB_UpperLipRoot_000", index =	20178},
        {label = "FB_L_Lip_Top_000", index =	20279},
        {label = "FB_LowerLip_000", index =	20623},
        {label = "SKEL_R_Toe0", index =	20781},
        {label = "FB_L_CheekBone_000", index =	21550},
        {label = "MH_L_Elbow", index =	22711},
        {label = "SKEL_Spine0", index =	23553},
        {label = "RB_L_ThighRoll", index =	23639},
        {label = "PH_R_Foot", index =	24806},
        {label = "SKEL_Spine1", index =	24816},
        {label = "SKEL_Spine2", index =	24817},
        {label = "SKEL_Spine3", index =	24818},
        {label = "FB_L_Eye_000", index =	25260},
        {label = "SKEL_L_Finger00", index =	26610},
        {label = "SKEL_L_Finger10", index =	26611},
        {label = "SKEL_L_Finger20", index =	26612},
        {label = "SKEL_L_Finger30", index =	26613},
        {label = "SKEL_L_Finger40", index =	26614},
        {label = "FB_R_Eye_000", index =	27474},
        {label = "SKEL_R_Forearm", index =	28252},
        {label = "PH_R_Hand", index =	28422},
        {label = "FB_L_Lip_Corner_000", index =	29868},
        {label = "SKEL_Head", index =	31086},
        {label = "IK_R_Foot", index =	35502},
        {label = "RB_Neck_1", index =	35731},
        {label = "IK_L_Hand", index =	36029},
        {label = "SKEL_R_Calf", index =	36864},
        {label = "RB_R_ArmRoll", index =	37119},
        {label = "FB_Brow_Centre_000", index =	37193},
        {label = "SKEL_Neck_1", index =	39317},
        {label = "SKEL_R_UpperArm", index =	40269},
        {label = "FB_R_Lid_Upper_000", index =	43536},
        {label = "RB_R_ForeArmRoll", index =	43810},
        {label = "SKEL_L_UpperArm", index =	45509},
        {label = "FB_L_Lid_Upper_000", index =	45750},
        {label = "MH_L_Knee", index =	46078},
        {label = "FB_Jaw_000", index =	46240},
        {label = "FB_L_Lip_Bot_000", index =	47419},
        {label = "FB_Tongue_000", index =	47495},
        {label = "FB_R_Lip_Bot_000", index =	49979},
        {label = "SKEL_R_Thigh", index =	51826},
        {label = "SKEL_R_Foot", index =	52301},
        {label = "IK_Root", index =	56604},
        {label = "SKEL_R_Hand", index =	57005},
        {label = "SKEL_Spine_Root", index =	57597},
        {label = "PH_L_Foot", index =	57717},
        {label = "SKEL_L_Thigh", index =	58271},
        {label = "FB_L_Brow_Out_000", index =	58331},
        {label = "SKEL_R_Finger00", index =	58866},
        {label = "SKEL_R_Finger10", index =	58867},
        {label = "SKEL_R_Finger20", index =	58868},
        {label = "SKEL_R_Finger30", index =	58869},
        {label = "SKEL_R_Finger40", index =	58870},
        {label = "PH_L_Hand", index =	60309},
        {label = "RB_L_ForeArmRoll", index =	61007},
        {label = "SKEL_L_Forearm", index =	61163},
        {label = "FB_UpperLip_000", index =	61839},
        {label = "SKEL_L_Calf", index =	63931},
        {label = "SKEL_R_Finger01", index =	64016},
        {label = "SKEL_R_Finger02", index =	64017},
        {label = "SKEL_R_Finger31", index =	64064},
        {label = "SKEL_R_Finger32", index =	64065},
        {label = "SKEL_R_Finger41", index =	64080},
        {label = "SKEL_R_Finger42", index =	64081},
        {label = "SKEL_R_Finger11", index =	64096},
        {label = "SKEL_R_Finger12", index =	64097},
        {label = "SKEL_R_Finger21", index =	64112},
        {label = "SKEL_R_Finger22", index =	64113},
        {label = "SKEL_L_Clavicle", index =	64729},
        {label = "FACIAL_facialRoot", index =	65068},
        {label = "IK_L_Foot", index =	65245},
    },
    [2] = {
        {label = "chassis", index = "chassis" },  
        {label = "windscreen", index = "windscreen" },  
        {label = "seat_pside_r", index = "seat_pside_r" },  
        {label = "seat_dside_r", index = "seat_dside_r" },  
        {label = "bodyshell", index = "bodyshell" },  
        {label = "suspension_lm", index = "suspension_lm" },  
        {label = "suspension_lr", index = "suspension_lr" },  
        {label = "platelight", index = "platelight" },  
        {label = "attach_female", index = "attach_female" },  
        {label = "attach_male", index = "attach_male" },  
        {label = "bonnet", index = "bonnet" },  
        {label = "boot", index = "boot" },  
        {label = "chassis_dummy", index = "chassis_dummy" },	
        {label = "chassis_Control", index = "chassis_Control" },
        {label = "door_dside_f", index = "door_dside_f" },	
        {label = "door_dside_r", index = "door_dside_r" },	
        {label = "door_pside_f", index = "door_pside_f" },	
        {label = "door_pside_r", index = "door_pside_r" },	
        {label = "Gun_GripR", index = "Gun_GripR" },  
        {label = "windscreen_f", index = "windscreen_f" },  
        {label = "platelight", index = "platelight" },	    
        {label = "VFX_Emitter", index = "VFX_Emitter" },  
        {label = "window_lf", index = "window_lf" },	    
        {label = "window_lr", index = "window_lr" },	    
        {label = "window_rf", index = "window_rf" },	    
        {label = "window_rr", index = "window_rr" },	    
        {label = "engine", index = "engine" },	        
        {label = "gun_ammo", index = "gun_ammo" },  
        {label = "ROPE_ATTATCH", index = "ROPE_ATTATCH" },	
        {label = "wheel_lf", index = "wheel_lf" },	    
        {label = "wheel_lr", index = "wheel_lr" },	    
        {label = "wheel_rf", index = "wheel_rf" },	    
        {label = "wheel_rr", index = "wheel_rr" },	    
        {label = "exhaust", index = "exhaust" },	    
        {label = "overheat", index = "overheat" },	    
        {label = "misc_e", index = "misc_e" },	        
        {label = "seat_dside_f", index = "seat_dside_f" },	
        {label = "seat_pside_f", index = "seat_pside_f" },	
        {label = "Gun_Nuzzle", index = "Gun_Nuzzle" },  
        {label = "seat_r",  index = "seat_r" }, 
    },
    [3] = {
        {label = "root",  index = 0 }
    }
}

local DetachEntity <const> = DetachEntity
local AttachEntityToEntity <const> = AttachEntityToEntity
local GetPedBoneIndex <const> = GetPedBoneIndex
local DeleteEntity <const> = DeleteEntity
local GetOffsetFromEntityInWorldCoords <const> = GetOffsetFromEntityInWorldCoords
local CreateObject <const> = CreateObject
local GetEntityType <const> = GetEntityType
local GetEntityBoneIndexByName <const> = GetEntityBoneIndexByName
local PlaceObjectOnGroundProperly <const> = PlaceObjectOnGroundProperly
local SetEntityVisible <const> = SetEntityAlpha
local SetEntityAlpha <const> = SetEntityAlpha
local SetEntityCollision <const> = SetEntityCollision

local function editTools(self, data)
    if not self.object then return end
    if data.coords then self.coords = data.coords end
    if data.rot then self.rot = data.rot end
    if data.heading then self.heading = data.heading end
    if data.zground then 
        self.zground = true
        PlaceObjectOnGroundProperly(self.object)
    else
        self.zground = false
    end
    if self.entity then
        DetachEntity(self.object, 1, 1)
        if data.bone then self.bone = data.bone end
        if self.entity_type == 1 then
            AttachEntityToEntity(self.object, self.entity, GetPedBoneIndex(self.entity, self.bone), self.coords[1], self.coords[2], self.coords[3], self.rot[1], self.rot[2], self.rot[3], true, true, false, true, 1, true)
            return
        elseif self.entity_type == 2 then -- vehicle
            AttachEntityToEntity(self.object, self.entity, GetEntityBoneIndexByName(self.entity, self.bone), self.coords[1], self.coords[2], self.coords[3], self.rot[1], self.rot[2], self.rot[3], true, true, false, true, 1, true)
        else
            AttachEntityToEntity(self.object, self.entity, 0, self.coords[1], self.coords[2], self.coords[3], self.rot[1], self.rot[2], self.rot[3], true, true, false, true, 1, true)
        end
    end
    return
end

local function removeTools(self)
    if not self.object then return print('error') end
    DeleteEntity(self.object)
    if self.entity then
        DetachEntity(self.object, 1, 1)
    end
    return nil, collectgarbage()
end

local function CreateProps(model, setting)
    local self = {}
    
    CreateThread(function()

        self.model = model
        self.coords = setting.coords or {0.0, 0.0, 0.0}
        self.rot = setting.rot or {0.0, 0.0, 0.0}
        self.heading = setting.heading or 0.0

        if setting then
            if setting.entity then
                self.entity = setting.entity
                self.entity_type = GetEntityType(self.entity)
                self.bone = setting.bone or nil
                self.entity_coords = GetOffsetFromEntityInWorldCoords(self.entity, 0.0, 0.0, 0.0)
                self.object = CreateObject(self.model, self.entity_coords[1], self.entity_coords[2], self.entity_coords[3], false, false, true)
            else
                self.object = CreateObject(self.model, self.coords.xyz, false, false, true)
                if self.heading ~= 0.0 then
                    SetEntityHeading(self.object, self.heading)
                end
            end
        end

        if self.entity_coords then
            if self.entity_type == 1 then -- ped
                AttachEntityToEntity(self.object, self.entity, GetPedBoneIndex(self.entity, self.bone), self.coords[1], self.coords[2], self.coords[3], self.rot[1], self.rot[2], self.rot[3], true, true, false, true, 1, true)
            elseif self.entity_type == 2 then -- vehicle
                AttachEntityToEntity(self.object, self.entity, GetEntityBoneIndexByName(self.entity, self.bone), self.coords[1], self.coords[2], self.coords[3], self.rot[1], self.rot[2], self.rot[3], true, true, false, true, 1, true)
            elseif self.entity_type == 3 then -- object (3)
                AttachEntityToEntity(self.object, self.entity, 0, self.coords[1], self.coords[2], self.coords[3], self.rot[1], self.rot[2], self.rot[3], true, true, false, true, 1, true)
            else -- == 0
                return print("error entity type = 0")
            end
        end
        
        self.visible = setting.visible == false and SetEntityVisible(self.object, false, 0) or nil
        self.alpha = type(setting.alpha) == 'number' and SetEntityAlpha(self.object, setting.alpha, 0) or nil
        self.zground = setting.zground == true and PlaceObjectOnGroundProperly(self.object) or nil
        self.collision = setting.collision == false and SetEntityCollision(self.object, false, false) or nil
    end)

    self.edit = editTools
    self.remove = removeTools
    return self
end

-- Get Entity Obj

local function SelectedRemove(self)
    if self.entity and DoesEntityExist(self.entity) then
        DeleteEntity(self.entity)
    end
    return nil, collectgarbage()
end

local function SelectedSetter(self, key, value, value2, value3)
    if key == 'freeze' then
        FreezeEntityPosition(self.entity, value)
    elseif key == 'collision' then
        SetEntityCollision(self.entity, value, value2 or true)
    elseif key == 'alpha' then
        SetEntityAlpha(self.entity, value, value2 or 0)
    elseif key == 'visible' then
        SetEntityVisible(self.entity, value, value2 or 0)
    elseif key == 'coords' then
        SetEntityCoords(self.entity, value, value2, value3)
    elseif key == 'heading' then
        SetEntityHeading(self.entity, value)
    end
end

local function SelectedGetter(self, key)
    if key == 'freeze' then
        self.entity_isFrozen = IsEntityPositionFrozen(self.entity)
        return self.entity_isFrozen
    elseif key == 'collision' then
        self.entity_collision = GetEntityCollisionDisabled(self.entity)
        return self.entity_collision
    elseif key == 'vec3' then
        self.coords = GetEntityCoords(self.entity)
        return self.coords
    elseif key == 'heading' then
        self.heading = GetEntityHeading(self.entity)
        return self.heading
    elseif key == 'vec4' then
        local coords, heading = GetEntityCoords(self.entity), GetEntityHeading(self.entity)
        self.vec4 = vec4(coords.x, coords.y, coords.z, heading)
        return self.vec4
    elseif key == 'alpha' then
        self.entity_alpha = GetEntityAlpha(self.entity)
        return self.entity_alpha
    end
    self.entity_isFrozen, self.entity_collision, self.coords, self.heading, self.entity_alpha = IsEntityPositionFrozen(self.entity), GetEntityCollisionDisabled(self.entity), GetEntityCoords(self.entity), GetEntityHeading(self.entity), GetEntityAlpha(self.entity)
    local coords, heading = GetEntityCoords(self.entity), GetEntityHeading(self.entity)
    self.vec4 = vec4(coords.x, coords.y, coords.z, heading)
    return {isFrozen = self.entity_isFrozen, collisionDisable = self.entity_collision, coords = self.coords, heading = self.heading, vec4 = self.vec4, alpha = self.entity_alpha}
end

local function SelectedAttach(self, target, data)
    if not DoesEntityExist(target) and not DoesEntityExist(self.entity) then return end
    if data.coords then self._coords = data.coords end
    if data.rot then self._rot = data.rot end
    if data.bone then self._bone = data.bone end
    if IsEntityAttached(self.entity) then DetachEntity(self.entity, 1, 1) end
    if IsEntityAttached(target) then DetachEntity(target, 1, 1) end
    if self.entity_type == 1 then
        if not self._bone then self._bone = BoneList[1][1].index end
        AttachEntityToEntity(target, self.entity, GetPedBoneIndex(self.entity, self._bone), self._coords[1], self._coords[2], self._coords[3], self._rot[1], self._rot[2], self._rot[3], true, true, false, true, 1, true)
        self.native = ("AttachEntityToEntity(%s:entity, %s:entity, GetPedBoneIndex(%s:entity, %s), %s, %s, %s, %s, %s, %s, true, true, false, true, 1, true)"):format(GetEntityArchetypeName(target), GetEntityArchetypeName(self.entity), GetEntityArchetypeName(self.entity), self._bone, self._coords[1], self._coords[2], self._coords[3], self._rot[1], self._rot[2], self._rot[3])
        return
    elseif self.entity_type == 2 then -- vehicle
        if not self._bone then self._bone = BoneList[2][1].index end
        AttachEntityToEntity(target, self.entity, GetEntityBoneIndexByName(self.entity, self._bone), self._coords[1], self._coords[2], self._coords[3], self._rot[1], self._rot[2], self._rot[3], true, true, false, true, 1, true)
        self.native = ("AttachEntityToEntity(%s:entity, %s:entity, GetEntityBoneIndexByName(%s:entity, %s), %s, %s, %s, %s, %s, %s, true, true, false, true, 1, true)"):format(GetEntityArchetypeName(target), GetEntityArchetypeName(self.entity), GetEntityArchetypeName(self.entity), self._bone, self._coords[1], self._coords[2], self._coords[3], self._rot[1], self._rot[2], self._rot[3])
    else
        AttachEntityToEntity(target, self.entity, 0, self._coords[1], self._coords[2], self._coords[3], self._rot[1], self._rot[2], self._rot[3], true, true, false, true, 1, true)
        self.native = ("AttachEntityToEntity(%s:entity, %s:entity, 0, %s, %s, %s, %s, %s, %s, true, true, false, true, 1, true)"):format(GetEntityArchetypeName(target), GetEntityArchetypeName(self.entity), self._coords[1], self._coords[2], self._coords[3], self._rot[1], self._rot[2], self._rot[3])
    end
    return 
end

local function SelectedDetach(self)
    if not DoesEntityExist(self.entity) then return end
    if IsEntityAttached(self.entity) or IsEntityAttachedToAnyObject(self.entity) then
        DetachEntity(self.entity,1,1)
    end
end

local function UnSelected(self)
    return nil, collectgarbage()
end

local function SelectedReset(self)
    ResetEntityAlpha(self.entity)
    SetEntityCollision(self.entity, true, true)
    --SetEntityVisible(self.entity, false, 0)
    SetEntityCoords(self.entity, self.firstCoord.x, self.firstCoord.y, self.firstCoord.z)
    SetEntityHeading(self.entity, self.firstHeading)
    --SetEntityVisible(self.entity, true, 0)
end

local function SelectEntity(entity)
    local self = {}
    
    self.entity = entity
    self.model = GetEntityModel(self.entity) ---@return hash
    self.coords = GetEntityCoords(self.entity) ---@return vector3
    self.heading = GetEntityHeading(self.entity) ---@return float
    self.entity_type = GetEntityType(self.entity) ---@return int
    self.entity_alpha = GetEntityAlpha(self.entity) ---@return int
    self.entity_isFrozen = IsEntityPositionFrozen(self.entity) ---@return boolean
    self.entity_collision = GetEntityCollisionDisabled(self.entity) ---@return boolean
    self.vec4 = vec4(self.coords.x, self.coords.y, self.coords.z, self.heading) ---@return vector4
    self.firstCoord = self.coords
    self.firstHeading = self.heading

    self.boneList = BoneList[self.entity_type] ---@return table
    
    self.set = SelectedSetter
    self.get = SelectedGetter
    self.remove = SelectedRemove
    self.attach = SelectedAttach
    self.detach = SelectedDetach
    self.unSelect = UnSelected
    self.reset = SelectedReset
    --self.edit = SelectedEdit

    return self
end


return {
    laser = Show,
    draw3d = Draw3dText,
    boneList = BoneList,
    createProps = CreateProps,
    selectEntity = SelectEntity
}