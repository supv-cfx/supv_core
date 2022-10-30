local BeginTextCommandBusyspinnerOn <const> = BeginTextCommandBusyspinnerOn
local AddTextComponentString <const> = AddTextComponentString
local EndTextCommandBusyspinnerOn <const> = EndTextCommandBusyspinnerOn
local BusyspinnerOff <const> = BusyspinnerOff
local HasScaleformMovieLoaded <const> = HasScaleformMovieLoaded
local DrawScaleformMovieFullscreen <const> = DrawScaleformMovieFullscreen
local RequestScaleformMovie <const> = RequestScaleformMovie
local PushScaleformMovieFunction <const> = PushScaleformMovieFunction
local PushScaleformMovieFunctionParameterBool <const> = PushScaleformMovieFunctionParameterBool
local PopScaleformMovieFunctionVoid <const> = PopScaleformMovieFunctionVoid
local PushScaleformMovieFunctionParameterInt <const> = PushScaleformMovieFunctionParameterInt
local PushScaleformMovieMethodParameterButtonName <const> = PushScaleformMovieMethodParameterButtonName
local PushScaleformMovieFunctionParameterString <const> = PushScaleformMovieFunctionParameterString

--- promt.loading
---
---@param msg string
---@param time number
---@param type integer
local function LoadingPromt(msg, time, type)
    local type = type or 3
    CreateThread(function()
        while true do
            BeginTextCommandBusyspinnerOn('STRING')
            AddTextComponentString(msg)
            EndTextCommandBusyspinnerOn(type)
            Wait(time)
            BusyspinnerOff()
            return false
        end
    end)
end

local instructionScaleform = nil

local function InstructionPromtDraw()
    if HasScaleformMovieLoaded(instructionScaleform) then
        DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255)
    end
end

local function InstructionPromtSet(buttons)
    assert(type(buttons) == 'table', 'Le premier paramètre doit être une table voir documentation!')

    CreateThread(function()
        instructionScaleform = RequestScaleformMovie("instructional_buttons")

        while not HasScaleformMovieLoaded(instructionScaleform) do
            Wait(0)
        end

        PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
        PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
        PushScaleformMovieFunctionParameterBool(0)
        PopScaleformMovieFunctionVoid()

        for i = 1, #buttons do
            PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(i - 1)

            PushScaleformMovieMethodParameterButtonName(buttons[i].button)
            PushScaleformMovieFunctionParameterString(buttons[i].label)
            PopScaleformMovieFunctionVoid()
        end

        PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        PushScaleformMovieFunctionParameterInt(-1)
        PopScaleformMovieFunctionVoid()
    end)
end



return {
    loading = LoadingPromt,
    instructions = {
        set = InstructionPromtSet,
        draw = InstructionPromtDraw,
    }
}