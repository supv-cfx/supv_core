---@alias CursorPositionProps 'top-right' | 'bottom-right'

---@class SendReactValue
---@field action string
---@field data? any
---@type table

---@class SendReactOptions
---@field focus? boolean | {[1]: boolean, [2]: boolean}
---@field locations? CursorPositionProps | {x: float, y: float}
---@field keepInput? boolean

local SetCursorLocation <const>, SetNuiFocusKeepInput<const>, SendNUIMessage <const>, type <const>, SetNuiFocus <const>, table <const>, RegisterNUICallback <const>, IsNuiFocused <const> = SetCursorLocation, SetNuiFocusKeepInput, SendNUIMessage, type, SetNuiFocus, table, RegisterNUICallback, IsNuiFocused

---@type table<string, {x: float, y: float}>
local cusorPosition <const> = {
    ['top-right'] = {x = 0.90, y = 0.10},
    ['bottom-right'] = {x = 0.90, y = 0.90},
    ['center'] = {x = 0.50, y = 0.50}
}

--- supv.sendReactMessage
---@param visible? boolean
---@param value? SendReactValue
---@param options? SendReactOptions
local function SendReactMessage(visible, value, options)
    if type(value) == 'table' and type(value.action) == 'string' then
        SendNUIMessage({
            action = value.action,
            data = value.data,
        })
    end

    if options then
        if type(options.focus) == 'boolean'  then
            SetNuiFocus(options.focus, options.focus)
        elseif type(options.focus) == 'table' and table.type(options.focus) == 'array' then
            SetNuiFocus(options.focus[1], options.focus[2])
        elseif type(options.focus) == 'string' and options.focus == 'ignore' then
           goto ignore
        end

        if type(options.locations) == 'string' then
            SetCursorLocation(cusorPosition[options.locations].x, cusorPosition[options.locations].y)
        elseif type(options.locations) == 'table' then
            SetCursorLocation(options.locations[1] or options.locations.x, options.locations[2] or options.locations.y)
        end

        if type(options.keepInput) == 'boolean' then
            SetNuiFocusKeepInput(options.keepInput)
        end

        ---@todo Need more options about focus options?
        ::ignore::
    end
end

--- supv.registerReactCallback
---@param name string
---@param cb fun(data: any, cb: fun(...: any))
---@param visible? boolean
local function RegisterReactCallback(name, cb, visible)
    RegisterNUICallback(name, function(...)
        if visible then
            SendReactMessage(false)
        end
        cb(...)
    end)
end

local function ResetFocus()
    SetNuiFocus(false, false)
end

-- RegisterNUICallback('supv:react:getConfig', function(data, cb)
--     --print(json.encode(data, {indent = true}), 'data')
--     cb(1)
-- end)

return {
    sendReactMessage = SendReactMessage,
    registerReactCallback = RegisterReactCallback,
    resetFocus = ResetFocus
}

--[[
    SetCursorLocation(0.90, 0.90) bottom-right
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
--]]