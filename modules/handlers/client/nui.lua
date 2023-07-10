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
    ['top-right'] = {},
    ['bottom-right'] = {x = 0.90, y = 0.90}
}

--- supv.sendReactMessage
---@param visible? boolean
---@param value? SendReactValue
---@param options? SendReactOptions
local function SendReactMessage(visible, value, options)
    print(json.encode(value, {indent = true}))
    if type(visible) == 'boolean' then
        
        ---@todo reset focus options when visible is false and focus active = true
        if visible == false and IsNuiFocused() then
            SetNuiFocus(false, false)
        end
    end

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
        end

        if type(options.locations) == 'string' then
            SetCursorLocation(cusorPosition[options.locations][1], cusorPosition[options.locations][2])
        elseif type(options.locations) == 'table' then
            SetCursorLocation(options.locations[1] or options.locations.x, options.locations[2] or options.locations.y)
        end

        if type(options.keepInput) == 'boolean' then
            SetNuiFocusKeepInput(options.keepInput)  
        end

        ---@todo Need more options about focus options?
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

supv.sendReactMessage = SendReactMessage
supv.registerReactCallback = RegisterReactCallback
supv.resetFocus = ResetFocus

--[[
    SetCursorLocation(0.90, 0.90) bottom-right
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
--]]