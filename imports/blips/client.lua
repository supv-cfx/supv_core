local RemoveBlip <const> = RemoveBlip
local AddBlipForCoord <const> = AddBlipForCoord
local SetBlipSprite <const> = SetBlipSprite
local SetBlipColour <const> = SetBlipColour
local SetBlipScale <const> = SetBlipScale
local SetBlipAsShortRange <const> = SetBlipAsShortRange
local BeginTextCommandSetBlipName <const> = BeginTextCommandSetBlipName
local AddTextComponentSubstringPlayerName <const> = AddTextComponentSubstringPlayerName
local EndTextCommandSetBlipName <const> = EndTextCommandSetBlipName
local DoesBlipExist <const> = DoesBlipExist
local AddBlipForRadius <const> = AddBlipForRadius
local SetBlipAlpha <const> = SetBlipAlpha
local SetRadiusBlipEdge <const> = SetRadiusBlipEdge

local blips = {}

local function Delete(self)
    if table.type(self) == 'array' then
        for i = 1, #self do
            if DoesBlipExist(self[i].id) then
                RemoveBlip(self[i].id)
            end
            if self[i].circle then
                if DoesBlipExist(self[i].circle.id) then
                    RemoveBlip(self[i].circle.id)
                end
            end

            for j = 1, #blips do
                if blips[j] == self[i] then
                    table.remove(blips, j)
                    break
                end
            end

            supv.DeleteBlips(supv.env, self[i].id)
        end
    else
        if DoesBlipExist(self.id) then
            RemoveBlip(self.id)
        end
        if self.circle then
            if DoesBlipExist(self.circle.id) then
                RemoveBlip(self.circle.id)
            end
        end

        for i = 1, #blips do
            if blips[i] == self then
                table.remove(blips, i)
                break
            end
        end

        supv.DeleteBlips(supv.env, self.id)
    end

    return nil, collectgarbage()
end

local function Edit(self, data)
    if table.type(self) == 'array' then
        for i = 1, #self do
            if DoesBlipExist(self[i].id) then
                if data.sprite then
                    SetBlipSprite(self[i].id, data.sprite)
                end
                if data.color then
                    SetBlipColour(self[i].id, data.color)
                end
                if data.scale then
                    SetBlipScale(self[i].id, data.scale)
                end
                if data.range then
                    SetBlipAsShortRange(self[i].id, data.range)
                end
                if data.label then
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentSubstringPlayerName(data.label)
                    EndTextCommandSetBlipName(self[i].id)
                end
            end
            if self[i].circle then
                if DoesBlipExist(self[i].circle.id) then
                    if data.circle then
                        if data.circle.radius then
                            SetBlipSprite(self[i].circle.id, data.circle.radius)
                        end
                        if data.circle.color then
                            SetBlipColour(self[i].circle.id, data.circle.color)
                        end
                        if data.circle.alpha then
                            SetBlipAlpha(self[i].circle.id, data.circle.alpha)
                        end
                        if data.circle.edge then
                            SetRadiusBlipEdge(self[i].circle.id, data.circle.edge)
                        end
                    end
                end
            end
        end
    else
        if DoesBlipExist(self.id) then
            if data.sprite then
                SetBlipSprite(self.id, data.sprite)
            end
            if data.color then
                SetBlipColour(self.id, data.color)
            end
            if data.scale then
                SetBlipScale(self.id, data.scale)
            end
            if data.range then
                SetBlipAsShortRange(self.id, data.range)
            end
            if data.label then
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(data.label)
                EndTextCommandSetBlipName(self.id)
            end
        end
        if self.circle then
            if DoesBlipExist(self.circle.id) then
                if data.circle then
                    if data.circle.radius then
                        SetBlipSprite(self.circle.id, data.circle.radius)
                    end
                    if data.circle.color then
                        SetBlipColour(self.circle.id, data.circle.color)
                    end
                    if data.circle.alpha then
                        SetBlipAlpha(self.circle.id, data.circle.alpha)
                    end
                    if data.circle.edge then
                        SetRadiusBlipEdge(self.circle.id, data.circle.edge)
                    end
                end
            end
        end
    end    
end

local function Create(coords, data, circle)
    local p = promise.new()
    local self = {}

    CreateThread(function()
        if type(coords) ~= 'vector3' and type(coords) == 'table' and table.type(coords) == 'array' then
            for i = 1, #coords do
                local c = coords[i]
                self[i] = {}

                self[i].coords = c
                self[i].sprite = data.sprite
                self[i].color = data.color
                self[i].label = data.label
                self[i].scale = data?.scale or 1.0
                self[i].range = data?.range or true
                self[i].group = data?.group or nil
                self[i].type = data?.type or 'none'
                self[i].remove = Delete
                self[i].edit = Edit

                self[i].id = AddBlipForCoord(c.x, c.y, c.z)
                SetBlipSprite(self[i].id, self[i].sprite)
                SetBlipColour(self[i].id, self[i].color)
                SetBlipScale(self[i].id, self[i].scale)
                SetBlipAsShortRange(self[i].id, self[i].range)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(self[i].label)
                EndTextCommandSetBlipName(self[i].id)

                if circle then
                    if type(circle) ~= 'table' then return end
                    if type(circle.radius) ~= 'number' or math.type(circle.radius) ~= 'float' then return end
                    self[i].circle = {}
                    self[i].circle.radius = circle.radius
                    self[i].circle.color = circle.color or 1
                    self[i].circle.alpha = circle.alpha or circle.edge == true and 0 or 255
                    self[i].circle.edge = circle.edge or false

                    self[i].circle.id = AddBlipForRadius(self[i].coords, self[i].radius)
                    SetBlipColour(self[i].circle.id , self[i].circle.alpha)
                    SetBlipAlpha(self[i].circle.id , self[i].circle.color)
                    SetRadiusBlipEdge(self[i].circle.id, self[i].circle.edge)
                end

                blips[#blips+1] = self[i]
                supv.CreateBlips(supv.env, self[i].id, self[i].type)
            end
        elseif type(coords) == 'vector3' then
            self.coords = coords
            self.sprite = data.sprite
            self.color = data.color
            self.label = data.label
            self.scale = data?.scale or 1.0
            self.range = data?.range or true
            self.group = data?.group or nil
            self.type = data?.type or 'none'
            self.remove = Delete
            self.edit = Edit

            self.id = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(self.id, self.sprite)
            SetBlipColour(self.id, self.color)
            SetBlipScale(self.id, self.scale)
            SetBlipAsShortRange(self.id, self.range)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(self.label)
            EndTextCommandSetBlipName(self.id)

            if circle then
                if type(circle) ~= 'table' then return end
                if type(circle.radius) ~= 'number' or math.type(circle.radius) ~= 'float' then return end
                self.circle = {}
                self.circle.radius = circle.radius
                self.circle.color = circle.color or 1
                self.circle.alpha = circle.alpha or circle.edge == true and 0 or 255
                self.circle.edge = circle.edge or false

                self.circle.id = AddBlipForRadius(self.coords, self.radius)
                SetBlipColour(self.circle.id , self.circle.alpha)
                SetBlipAlpha(self.circle.id , self.circle.color)
                SetRadiusBlipEdge(self.circle.id, self.circle.edge)
            end

            blips[#blips+1] = self
            supv.CreateBlips(supv.env, self.id, self.type)
        end

        p:resolve(self)
    end)

    return supv.await(p)
end

local function GetAllBlips()
    return blips
end

return {
    new = Create,
    getAllBlips = GetAllBlips
}