local BeginTextCommandWidth <const> = BeginTextCommandWidth
local AddTextComponentSubstringPlayerName <const> = AddTextComponentSubstringPlayerName
local SetTextFont <const> = SetTextFont
local SetTextScale <const> = SetTextScale
local EndTextCommandGetWidth <const> = EndTextCommandGetWidth
local SetTextColour <const> = SetTextColour
local SetTextDropShadow <const> = SetTextDropShadow
local SetTextOutline <const> = SetTextOutline
local SetTextCentre <const> = SetTextCentre
local SetTextRightJustify <const> = SetTextRightJustify
local SetTextWrap <const> = SetTextWrap
local BeginTextCommandLineCount <const> = BeginTextCommandLineCount
local World3dToScreen2d <const> = World3dToScreen2d
local EndTextCommandLineCount <const> = EndTextCommandLineCount
local SetTextProportional <const> = SetTextProportional
local SetTextEntry <const> = SetTextEntry
local DrawRect <const> = DrawRect
local AddTextComponentString <const> = AddTextComponentString
local DrawSprite <const> = DrawSprite
local DrawText <const> = DrawText
local BeginTextCommandDisplayText <const> = BeginTextCommandDisplayText
local EndTextCommandDisplayText <const> = EndTextCommandDisplayText
local HasStreamedTextureDictLoaded <const> = HasStreamedTextureDictLoaded
local RequestStreamedTextureDict <const> = RequestStreamedTextureDict
local FreezeEntityPosition <const> = FreezeEntityPosition
local IsControlJustPressed <const> = IsControlJustPressed


local function StringToArray(str)
    local charCount = #str
    local strCount = math.ceil(charCount / 99)
    local strings = {}

    for i = 1, strCount do
        local start = (i - 1) * 99 + 1
        local clamp = math.clamp(#string.sub(str, start), 0, 99)
        local finish = ((i ~= 1) and (start - 1) or 0) + clamp

        strings[i] = string.sub(str, start, finish)
    end
    
    return strings
end

local function MeasureStringWidth(str, font, scale)
    BeginTextCommandWidth("CELL_EMAIL_BCON")
    AddTextComponentSubstringPlayerName(str)
    SetTextFont(font or 0)
    SetTextScale(1.0, scale or 0)
    return EndTextCommandGetWidth(true) * supv.oncache.screen[1]
end

local function AddText(str)
    local str = tostring(str)
    local charCount = #str

    if charCount < 100 then
        AddTextComponentSubstringPlayerName(str)
    else
        local strings = StringToArray(str)
        for s = 1, #strings do
            AddTextComponentSubstringPlayerName(strings[s])
        end
    end
end

local function GetLineCount(Text, X, Y, Font, Scale, Color, Alignment, DropShadow, Outline, WordWrap)
    local Text, X, Y = tostring(Text), (tonumber(X) or 0) / supv.oncache.screen[1], (tonumber(Y) or 0) / supv.oncache.screen[2]
    SetTextFont(Font or 0)
    SetTextScale(1.0, Scale or 0)
    SetTextColour(tonumber(Color[1]) or 255, tonumber(Color[2]) or 255, tonumber(Color[3]) or 255, tonumber(Color[4]) or 255)
    if DropShadow then
        SetTextDropShadow()
    end
    if Outline then
        SetTextOutline()
    end
    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextCentre(true)
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextRightJustify(true)
        end
    end
    if tonumber(WordWrap) and tonumber(WordWrap) ~= 0 then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextWrap(X - ((WordWrap / supv.oncache.screen[1]) / 2), X + ((WordWrap / supv.oncache.screen[2]) / 2))
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextWrap(0, X)
        else
            SetTextWrap(X, X + (WordWrap / supv.oncache.screen[1]))
        end
    else
        if Alignment == 2 or Alignment == "Right" then
            SetTextWrap(0, X)
        end
    end

    BeginTextCommandLineCount("CELL_EMAIL_BCON")
    AddText(Text)
    return EndTextCommandLineCount(X, Y)
end

--- DrawText3D
---
---@param x float coords.x
---@param y float coords.y
---@param z float coords.z
---@param text string string
---@param data table {color_rect1 = {0,0,0,150}, color_rect2 = {255,0,0,100}, scale = {0.35,0.35}, police = 1}
local function Text3D(coords, text, data)

    if data.z then 
        coords = vec3(coords.x, coords.y, coords.z + data.z) 
    end

    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local color, scale, police = {}, data.scale or {0.25,0.25}, data.police or 0
    color.text = data.color_text or {255,255,255,255}
    color.rect1 = data.color_rect1 or nil
    color.rect2 = data.color_rect2 or nil

    SetTextScale(scale[1], scale[2])
    SetTextFont(police)
    SetTextProportional(1)
    SetTextColour(color.text[1], color.text[2], color.text[3], color.text[4])
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)

    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    if color.rect1 then
        DrawRect(_x,_y+0.0125, 0.015+ factor + (scale[1]/4), 0.03, color.rect1[1], color.rect1[2], color.rect1[3], color.rect1[4])
    end
    if color.rect2 then
        DrawRect(_x,_y+0.0300, 0.015+ factor + (scale[1]/4), 0.005, color.rect2[1], color.rect2[2], color.rect2[3], color.rect2[4])
    end
end

--- DrawSprite
---
---@param TextureDictionary string string
---@param TextureName string string
---@param x number number
---@param y number number
---@param w number number
---@param h number number
---@param color table {int, int, int, int}
---@param heading float 0.0
local function Sprite(TextureDictionary, TextureName, x, y, width, heigth, color, heading)--drawSprite(TextureDictionary, TextureName, x, y, w, h, heading, color)
    local screenX, screenY = supv.oncache.screen[1], supv.oncache.screen[2] 
    local x, y = (tonumber(x or 0) / tonumber(screenX)), (tonumber(y or 0) / tonumber(screenY))
    local w, h = (tonumber(width or 0) / tonumber(screenX)), (tonumber(heigth or 0) / tonumber(screenY))

    if not HasStreamedTextureDictLoaded(TextureDictionary) then
        RequestStreamedTextureDict(TextureDictionary, true)
    end

    DrawSprite(TextureDictionary, TextureName, x + w * 0.5 ,y + h * 0.5 , w, h, heading or 0.0, color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 150)
end

--- DrawRect
---
---@param x number
---@param y number
---@param w number
---@param h number
---@param color table
local function Rect(x, y, w, h, color)
    local x, y, w, h = (tonumber(x) or 0) / supv.oncache.screen[1], (tonumber(y) or 0) / supv.oncache.screen[2], (tonumber(w) or 0) / supv.oncache.screen[1], (tonumber(h) or 0) / supv.oncache.screen[2]
    DrawRect(x + w * 0.5, y + h * 0.5, w, h, color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 100)
end

--- DrawText2D
---
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param Color table {int,int,int,int}
---@param Alignment nil|string|number Center or Centre or Right | 1 or 2 | nil
---@param DropShadow nil|boolean true or false or nil 
---@param Outline boolean true or false or nil 
---@param WordWrap nil|number int or nil
local function Text2D(Text, X, Y, Font, Scale, Color, Alignment, DropShadow, Outline, WordWrap)
    local Text, X, Y = tostring(Text), (tonumber(X) or 0) / supv.oncache.screen[1], (tonumber(Y) or 0) / supv.oncache.screen[2]
    SetTextFont(Font or 0)
    SetTextScale(1.0, Scale or 0)
    SetTextColour(tonumber(Color[1]) or 255, tonumber(Color[2]) or 255, tonumber(Color[3]) or 255, tonumber(Color[4]) or 255)
    if DropShadow then
        SetTextDropShadow()
    end
    if Outline then
        SetTextOutline()
    end
    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextCentre(true)
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextRightJustify(true)
        end
    end
    if tonumber(WordWrap) and tonumber(WordWrap) ~= 0 then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextWrap(X - ((WordWrap / supv.oncache.screen[1]) / 2), X + ((WordWrap / supv.oncache.screen[2]) / 2))
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextWrap(0, X)
        else
            SetTextWrap(X, X + (WordWrap / supv.oncache.screen[1]))
        end
    else
        if Alignment == 2 or Alignment == "Right" then
            SetTextWrap(0, X)
        end
    end
    BeginTextCommandDisplayText("CELL_EMAIL_BCON")
    AddText(Text)
    EndTextCommandDisplayText(X, Y)
end

local ProgressBarActive = false
local defaultProgressBar = supv.config.client.import.draw.progressbar

--- progressbar
---
---@param text string
---@param time number
---@param setting table
---@param data table
---@param action table
---@return boolean
local function ProgressBar(text, time, setting, data, action)
    if not ProgressBarActive then
        
        ProgressBarActive = true
        local progressbar = {}
        progressbar.data = data
        progressbar.setting = {}
        progressbar.setting.canCancel = setting.canCancel or nil
        progressbar.setting.textCancel = setting.textCancel or defaultProgressBar.textCancel
        progressbar.setting.showCancelStatus = setting.showCancelStatus or defaultProgressBar.showCancelStatus
        progressbar.setting.freeze = setting.freeze or nil
        progressbar.setting.timeCancel = setting.timeCancel or 0
        progressbar.setting.animation = setting.animation or defaultProgressBar.animation
        progressbar.setting.prop = setting.prop or defaultProgressBar.prop
        progressbar.data.x = data.x or  (supv.oncache.screen[1] * 0.35)
        progressbar.data.y = data.y or  defaultProgressBar.y
        progressbar.data.w = data.w or  defaultProgressBar.w
        progressbar.data.h = data.h or  defaultProgressBar.h
        progressbar.data.color1 = data.color1 or defaultProgressBar.color1
        progressbar.data.color2 = data.color2 or defaultProgressBar.color2
        progressbar.data.cancelColor = data.cancelColor or defaultProgressBar.colorCancel
        progressbar.data.police = data.police or defaultProgressBar.police
        progressbar.data.progressAnim = data.progressAnim or defaultProgressBar.progressAnim
        progressbar.data.progressType = data.progressType or defaultProgressBar.progressType
        progressbar.data.badgeleft = data.badgeleft or defaultProgressBar.badgeleft
        progressbar.data.badgecancel0 = data.cancelBadge0 or defaultProgressBar.cancelStatus0
        progressbar.data.badgecancel1 = data.cancelBadge1 or defaultProgressBar.cancelStatus1
        progressbar.action = {}

        if progressbar.data.progressType == 'sprite' then
            progressbar.data.textureDict1 = defaultProgressBar.textureDict1
            progressbar.data.textureDict2 = defaultProgressBar.textureDict2
            progressbar.data.textureAnim1 = defaultProgressBar.textureAnim1
            progressbar.data.textureAnim2 = defaultProgressBar.textureAnim2
            progressbar.data.heading = defaultProgressBar.heading
        end
        
        local function Finished(isCaneled)
            CreateThread(function()
                local color2, text
                if isCaneled then
                    color2 = progressbar.data.cancelColor
                    text = progressbar.setting.textCancel
                else
                    color2 = progressbar.data.color2
                    text = ''
                end

                if progressbar.setting.freeze then
                    FreezeEntityPosition(PlayerPedId(), false)
                end
                    
                if (progressbar.data.progressAnim == 'simple') then
                    local _y = progressbar.data.y
                    local _ymax = supv.oncache.screen[2] + 100
                    while _y < _ymax do
                        Wait(0)

                        SetTextProportional(1)
                        SetTextCentre(1)
                        supv.draw.text2d(text, 
                            progressbar.data.x + 220, 
                            _y, 
                            0, 0.30, {255,255,255,255}, nil, false, false, 
                            0
                        )

                        if progressbar.data.progressType == 'sprite' then
                            supv.draw.sprite(progressbar.data.textureDict2, progressbar.data.textureAnim2,
                                progressbar.data.x,
                                _y,
                                progressbar.data.w,
                                progressbar.data.h,
                                color2,
                                progressbar.data.heading
                            )
                        elseif progressbar.data.progressType == 'rect' then
                            supv.draw.rect(
                                progressbar.data.x,
                                _y,
                                progressbar.data.w,
                                progressbar.data.h,
                                color2
                            )
                        end

                        _y += 5
                    end
                elseif (progressbar.data.progressAnim == 'fondu') then
                    local _sfmin, _tfmin = 0, 0
                    local _sf, _tf = color2[4], 255
                    local finishAnim
                    while not finishAnim do
                        Wait(0)

                        SetTextProportional(1)
                        SetTextCentre(1)
                        supv.draw.text2d(text, 
                            progressbar.data.x + 220, 
                            progressbar.data.y, 
                            0, 0.30, {255,255,255,_tf}, nil, false, false, 
                            0
                        )

                        if progressbar.data.progressType == 'sprite' then
                            supv.draw.sprite(progressbar.data.textureDict2, progressbar.data.textureAnim2,
                                progressbar.data.x,
                                progressbar.data.y,
                                progressbar.data.w,
                                progressbar.data.h,
                                {color2[1], color2[2], color2[3], _sf},
                                progressbar.data.heading
                            )
                        elseif progressbar.data.progressType == 'rect' then
                            supv.draw.rect(
                                progressbar.data.x,
                                progressbar.data.y,
                                progressbar.data.w,
                                progressbar.data.h,
                                {color2[1], color2[2], color2[3], _sf}
                            )
                        end

                        if _sf > _sfmin then _sf -= 1 end
                        if _tf > _tfmin then _tf -= 1 end
                        finishAnim = (_sf <= _sfmin and _tf <= _tfmin)
                    end
                end
            end)
        end

        local function Started()
            local _w = progressbar.data.w
            local ProgressInitTimer = GetGameTimer()
            local endTime = (ProgressInitTimer + time)
            local anim = nil
            local inTimeToCancel, stateCancel
            CreateThread(function()
                if progressbar.setting.freeze then
                    FreezeEntityPosition(PlayerPedId(), true)
                end
                inTimeToCancel = progressbar.setting.canCancel
                while true do
                    Wait(1)
                    local percent = 1 - ((endTime - GetGameTimer()) / time)
                    if progressbar.data.progressType then
                        if GetGameTimer() <=  endTime then
                            _w = progressbar.data.w * percent
                        end
                        if progressbar.data.progressType == 'rect' then
                            supv.draw.rect(
                                progressbar.data.x,
                                progressbar.data.y,
                                progressbar.data.w,
                                progressbar.data.h,
                                progressbar.data.color1
                            )
                            supv.draw.rect(
                                progressbar.data.x,
                                progressbar.data.y,
                                _w,
                                progressbar.data.h,
                                progressbar.data.color2
                            )
                        elseif progressbar.data.progressType == 'sprite' then
                            supv.draw.sprite(progressbar.data.textureDict1, progressbar.data.textureAnim1,
                                progressbar.data.x,
                                progressbar.data.y,
                                progressbar.data.w,
                                progressbar.data.h,
                                progressbar.data.color1,
                                progressbar.data.heading
                            )
                            supv.draw.sprite(progressbar.data.textureDict2, progressbar.data.textureAnim2,
                                progressbar.data.x,
                                progressbar.data.y,
                                _w,
                                progressbar.data.h,
                                progressbar.data.color2,
                                progressbar.data.heading
                            )
                        end
                    end
                    if text then
                        SetTextProportional(1)
                        SetTextCentre(1)
                        supv.draw.text2d(text, 
                            progressbar.data.x + 220, 
                            progressbar.data.y + 3.5, 
                            0, 0.30, {255,255,255,255}, nil, false, false, 
                            0
                        )
                    end
                    if progressbar.data.badgeleft then
                        assert(type(progressbar.data.badgeleft) == 'table', "[ERROR] : progressbar valeur badgeleft doit être une table [1] = dict / [2] = name")
                        supv.draw.sprite(progressbar.data.badgeleft[1], progressbar.data.badgeleft[2], 
                        progressbar.data.x + 4,
                        progressbar.data.y,
                        32,
                        32,
                        {255,255,255,255},
                        0.0                   
                    )
                    end
                    if progressbar.setting.canCancel then                        
                        if progressbar.setting.timeCancel > 0 then
                            if (progressbar.setting.timeCancel + ProgressInitTimer < GetGameTimer()) then
                                inTimeToCancel = false
                            end
                        end
                        if inTimeToCancel then
                            if IsControlJustPressed(1, 202) then
                                ProgressBarActive = false
                                if anim then
                                    anim = anim:stop()
                                end
                                if action.cancel then
                                    action.cancel()
                                end
                                Finished(true)
                                return false
                            end
                            if progressbar.setting.showCancelStatus then--progressbar.data.badgecancel1[1] progressbar.data.badgecancel1[2
                                supv.draw.sprite(progressbar.data.badgecancel1[1], progressbar.data.badgecancel1[2], 
                                    progressbar.data.x + 400,
                                    progressbar.data.y,
                                    32,
                                    32,
                                    {255,255,255,255},
                                    0.0                   
                                )
                            end
                        else --leaderboard_votetick_icon
                            if progressbar.setting.showCancelStatus then --progressbar.data.badgecancel0[1] progressbar.data.badgecancel0[2]
                                supv.draw.sprite(progressbar.data.badgecancel0[1], progressbar.data.badgecancel0[2], 
                                    progressbar.data.x + 400,
                                    progressbar.data.y,
                                    32,
                                    32,
                                    {255,255,255,255},
                                    0.0                   
                                )
                            end
                        end
                    end
                    if progressbar.setting.animation then
                        if anim == nil then anim = supv.animation.strict(progressbar.setting.animation, progressbar.setting.prop ~= nil and progressbar.setting.prop) end
                        anim:play()
                    end
                    
                    if (GetGameTimer() - ProgressInitTimer > time) then
                        Finished(false)
                        if anim then anim = anim:stop() end
                        if action.success then action.success() end
                        ProgressBarActive = false
                        return false
                    end
                end
            end)
        end
            
        CreateThread(function()
            if progressbar.data.progressAnim == 'simple' then
                local _y = supv.oncache.screen[2] + 100
                while _y > progressbar.data.y do
                    Wait(0)
                    if progressbar.data.progressType == 'sprite' then
                        supv.draw.sprite(progressbar.data.textureDict2, progressbar.data.textureAnim2,
                            progressbar.data.x,
                            _y,
                            progressbar.data.w,
                            progressbar.data.h,
                            progressbar.data.color1,
                            0.0 
                        )
                    elseif progressbar.data.progressType == 'rect' then
                        supv.draw.rect(
                            progressbar.data.x,
                            _y,
                            progressbar.data.w,
                            progressbar.data.h,
                            progressbar.data.color2
                        )
                    end
                    _y -= 5
                end
            elseif progressbar.data.progressAnim == 'fondu' then
                local color2 = progressbar.data.color1
                local _sfmax, _tfmax = color2[4] - 30, 255
                local _sf, _tf = 0, 0
                local finishAnim
                while not finishAnim do
                    Wait(0)

                    SetTextProportional(1)
                    SetTextCentre(1)
                    supv.draw.text2d(text, 
                        progressbar.data.x + 220, 
                        progressbar.data.y + 3.5, 
                        0, 0.30, {255,255,255,_tf}, nil, false, false, 
                        0
                    )

                    if progressbar.data.progressType == 'sprite' then
                        supv.draw.sprite(progressbar.data.textureDict2, progressbar.data.textureAnim2,
                            progressbar.data.x,
                            progressbar.data.y,
                            progressbar.data.w,
                            progressbar.data.h,
                            {color2[1], color2[2], color2[3], _sf},
                            progressbar.data.heading
                        )
                    elseif progressbar.data.progressType == 'rect' then
                        supv.draw.rect(
                            progressbar.data.x,
                            progressbar.data.y,
                            progressbar.data.w,
                            progressbar.data.h,
                            {color2[1], color2[2], color2[3], _sf}
                        )
                    end

                    if _sf < _sfmax then _sf += 6 end
                    if _tf < _tfmax then _tf += 6 end
                    finishAnim = (_sf >= _sfmax and _tf >= _tfmax)
                end
            end
            Started()
        end)
    end
end


return {
    text3d = Text3D,
    text2d = Text2D,
    sprite = Sprite,
    rect = Rect,
    progressbar = ProgressBar
}