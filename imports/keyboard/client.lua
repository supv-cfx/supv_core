local AddTextEntry <const> = AddTextEntry
local DisplayOnscreenKeyboard <const> = DisplayOnscreenKeyboard
local UpdateOnscreenKeyboard <const> = UpdateOnscreenKeyboard
local GetOnscreenKeyboardResult <const> = GetOnscreenKeyboardResult

--- keyboard.input
---
---@param textEntry string
---@param inputText string
---@param maxLength integer
---@return string
local function KI(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(1.0)
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