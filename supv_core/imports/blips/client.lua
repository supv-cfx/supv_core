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

local function Delete(self)
    if self[1] then
        for i = 1, #self do
            if self[i].blip and DoesBlipExist(self[i].blip) then RemoveBlip(self[i].blip) end
        end
    else
        if self.blip and DoesBlipExist(self.blip) then RemoveBlip(self.blip) end
    end
    return nil, collectgarbage()
end

local function Create(coords, data)
    if not data.sprite and not data.label and not data.color then return end

    local self, multiple = {}, false

    if type(coords) == 'table' then
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
        end
    end)

    return self
end

return {
    new = Create
}