local object, call = {}, false
local timer, time = 501, 500
---self:edit
--- WORK IN PROGRESS
---@param
local function Edit(self)
    return self
end

--- self:remove
---
---@return nil
---@return collectgarbarge
local function Destroy(self)
    if self.entity then
        DetachEntity(self.toObj, 1, 1)
    end
    DeleteEntity(self.toObj)
    object[self.id] = nil
    return nil, collectgarbage()
end

--- object.new
---
---@param modelHash string
---@param setting table
---@return table
local function New(modelHash, setting)

    local id = #object + 1
    
    if (GetGameTimer() - time < timer) then
        DeleteEntity(object[id-1])
    end

    time = GetGameTimer()

    local self = {}
    

    self.id = id
    self.model = modelHash
    self.coords = setting.coords or {x = 0.0, y = 0.0, z = 0.0}
    self.rot = setting.rot or {x = 0.0, y = 0.0, z = 0.0}

    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        self.loaded = true
        Wait(0)
    end
    
    if setting then
        if setting.entity then
            self.entity = setting.entity
            self.bone = setting.bone
            self.entity_coords = GetOffsetFromEntityInWorldCoords(self.entity, 0.0, 0.0, 0.0)
            self.object = CreateObject(self.model, self.entity_coords[1], self.entity_coords[2], self.entity_coords[3], true, true, true)
            print('here')
        else
            self.object = CreateObject(self.model, self.coords[1], self.coords[2], self.coords[3], true, true, true)
            print('here2')
        end
    end
    
    self.netId = ObjToNet(self.object)

    SetNetworkIdExistsOnAllMachines(self.netId, true)
    NetworkSetNetworkIdDynamic(self.netId, true)
    SetNetworkIdCanMigrate(self.netId, false)

    self.toObj = NetToObj(self.netId)

    if self.entity then
        AttachEntityToEntity(self.object, self.entity, GetPedBoneIndex(self.entity, self.bone), self.coords[1], self.coords[2], self.coords[3], self.rot[1], self.rot[2], self.rot[3], true, true, false, true, 1, true)
    end

    -- func ref
    self.edit = Edit
    self.remove = Destroy

    print(self.id, self.object)

    object[self.id] = self.object
    call = false
    return self
end

local function Created(model, coords, cb)
    CreateThread(function()
        supv.stream.request(model)

        local obj = CreateObject(model, coords.xyz, true, false, true)
        if cb then
            cb(obj)
        end
    end)
end

--- For tools
local function editTools(self, data)
    if not self.object then return end
    DetachEntity(self.object, 1, 1)
    if self.entity then
        if data.coords then self.coords = data.coords end
        if data.rot then self.rot = data.rot end
        if data.bone then self.bone = data.bone end
        AttachEntityToEntity(self.object, self.entity, GetPedBoneIndex(self.entity, self.bone), self.coords[1], self.coords[2], self.coords[3], self.rot[1], self.rot[2], self.rot[3], true, true, false, true, 1, true)
        return
    end
    return
end

local function removeTools(self)
    if not self.object then return end
    if self.entity then
        DetachEntity(self.object, 1, 1)
    end
    DeleteEntity(self.object)
    return nil, collectgarbage()
end

local function tools(model, setting)
    local self = {}
    
    CreateThread(function()

        self.model = model
        self.coords = setting.coords or {0.0, 0.0, 0.0}
        self.rot = setting.rot or {0.0, 0.0, 0.0}

        if setting then
            if setting.entity then
                self.entity = setting.entity
                self.bone = setting.bone
                self.entity_coords = GetOffsetFromEntityInWorldCoords(self.entity, 0.0, 0.0, 0.0)
                self.object = CreateObject(self.model, self.entity_coords[1], self.entity_coords[2], self.entity_coords[3], false, false, true)
            else
                self.object = CreateObject(self.model, self.coords[1], self.coords[2], self.coords[3], false, false, true)
            end
        end

        if self.entity then
            AttachEntityToEntity(self.object, self.entity, GetPedBoneIndex(self.entity, self.bone), self.coords[1], self.coords[2], self.coords[3], self.rot[1], self.rot[2], self.rot[3], true, true, false, true, 1, true)
        end        
    end)
    self.edit = editTools
    self.remove = removeTools
    return self
end

return {
    new = New,
    create = Created,
    tool = tools
}