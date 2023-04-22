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

local function Delete(self)
    if self[1] then
        for i = 1, #self do
            if self[i].blip and DoesBlipExist(self[i].blip) then RemoveBlip(self[i].blip) end
            if self[i].rblip and DoesBlipExist(self[i].rblip) then RemoveBlip(self[i].rblip) end
        end
    else
        if self.blip and DoesBlipExist(self.blip) then RemoveBlip(self.blip) end
        if self.rblip and DoesBlipExist(self.rblip) then RemoveBlip(self.rblip) end
    end
    return nil, collectgarbage()
end

local function Edit(self, data, r)
    if not data.sprite and not data.label and not data.color then return end
    if DoesBlipExist(self.blip) then RemoveBlip(self.blip) end
    if self.rblip and DoesBlipExist(self.rblip) then RemoveBlip(self.rblip) end

    self.coords = data.coords
    self.sprite = data.sprite
    self.label = data.label
    self.color = data.color
    self.scale = data?.scale or 1.0
    self.range = data?.range or true
    self.group = data?.group or nil

    self.blip = AddBlipForCoord(self.coords)
    SetBlipSprite(self.blip, self.sprite)
    SetBlipColour(self.blip, self.color)
    SetBlipScale(self.blip, self.scale)
    SetBlipAsShortRange(self.blip, self.range)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(self.label)
    EndTextCommandSetBlipName(self.blip)

    if r and type(r) == 'table' and type(r.radius) == 'number' and math.type(r.radius) == 'float' then
        self.radius = r.radius
        self.rcolor = r.rcolor or 1
        self.ralpha = r.ralpha or r.redge == true and 0 or 120
        self.rblip = AddBlipForRadius(self.coords, self.radius)
        SetBlipColour(self.rblip , self.ralpha)
        SetBlipAlpha(self.rblip , self.rcolor)
        SetRadiusBlipEdge(self.rblip, self.redge)
    elseif self.radius then
        self.rblip = AddBlipForRadius(self.coords, self.radius)
        SetBlipColour(self.rblip , self.ralpha)
        SetBlipAlpha(self.rblip , self.rcolor)
        SetRadiusBlipEdge(self.rblip, self.redge)
    elseif r == false then
        self.rblip, self.radius, self.ralpha, self.rcolor, self.redge = nil, nil, nil, nil, nil
    end

    return self
end

--- blips.new
---
---@param coords vector3 | table
---@param data table
---@param r? table
---@return table
local function Create(coords, data, r)
    if not data.sprite and not data.label and not data.color then return end

    local self, multiple = {}, false

    if type(coords) == 'table' and #coords > 1 then
        for i = 1, #coords do
            self[i] = {}
            self[i].coords = coords[i]
            self[i].sprite = data.sprite
            self[i].color = data.color
            self[i].label = data.label
            self[i].scale = data?.scale or 1.0
            self[i].range = data?.range or true
            self[i].group = data?.group or nil
            self[i].remove = Delete
            self[i].edit = Edit
            if r and type(r) == 'table' and type(r.radius) == 'number' and math.type(r.radius) == 'float' then
                self[i].radius = r.radius
                self[i].rcolor = r.rcolor or 1
                self[i].ralpha = r.ralpha or 120
            end
        end
        multiple = true
    elseif type(coords) == 'vector3' then
        self.coords = coords
        self.sprite = data.sprite
        self.label = data.label
        self.color = data.color
        self.scale = data?.scale or 1.0
        self.range = data?.range or true
        self.group = data?.group or nil
        self.remove = Delete
        self.edit = Edit
        if r and type(r) == 'table' and type(r.radius) == 'number' and math.type(r.radius) == 'float' then
            self.radius = r.radius
            self.rcolor = r.rcolor or 1
            self.ralpha = r.ralpha or r.redge == true and 0 or 120
            self.redge = r.redge or false
        end
    else return end

    CreateThread(function()
        if multiple then
            for i = 1, #self do
                self[i].blip = AddBlipForCoord(self[i].coords)
                SetBlipSprite(self[i].blip, self[i].sprite)
                SetBlipColour(self[i].blip, self[i].color)
                SetBlipScale(self[i].blip, self[i].scale)
                SetBlipAsShortRange(self[i].blip, self[i].range)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(self[i].label)
                EndTextCommandSetBlipName(self[i].blip)
                if self[i].radius then
                    self[i].rblip = AddBlipForRadius(self[i].coords, self[i].radius)
                    SetBlipColour(self[i].rblip , self[i].ralpha)
                    SetBlipAlpha(self[i].rblip , self[i].rcolor)
                    SetRadiusBlipEdge(self[i].rblip, self[i].redge)
                end
            end
        else
            self.blip = AddBlipForCoord(self.coords)
            SetBlipSprite(self.blip, self.sprite)
            SetBlipColour(self.blip, self.color)
            SetBlipScale(self.blip, self.scale)
            SetBlipAsShortRange(self.blip, self.range)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(self.label)
            EndTextCommandSetBlipName(self.blip)
            if self.radius then
                self.rblip = AddBlipForRadius(self.coords, self.radius)
                SetBlipColour(self.rblip , self.ralpha)
                SetBlipAlpha(self.rblip , self.rcolor)
                SetRadiusBlipEdge(self.rblip, self.redge)
            end
        end
    end)

    return self
end

return {
    new = Create
}