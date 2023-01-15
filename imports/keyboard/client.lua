local AddTextEntry <const> = AddTextEntry
local DisplayOnscreenKeyboard <const> = DisplayOnscreenKeyboard
local UpdateOnscreenKeyboard <const> = UpdateOnscreenKeyboard
local GetOnscreenKeyboardResult <const> = GetOnscreenKeyboardResult
local math <const> = math

--- keyboard.input
---
---@param textEntry string
---@param inputText string
---@param maxLength integer
---@return string
local function KI(textEntry, inputText, maxLength, key)
    local id_string = ('%s_%s'):format(textEntry, math.random(1,99))
    AddTextEntry(id_string, textEntry)
    DisplayOnscreenKeyboard(1, id_string, key or "" , inputText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end


return {
    input = KI
}