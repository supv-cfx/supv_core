---@class SendReactValue
---@field action string
---@field data? any
 
---@class SendReactOptions
---@field focus? boolean|table
---@field locations? string|table
---@field keepInput? boolean

local SetCursorLocation <const>, SetNuiFocusKeepInput<const>, SendNUIMessage <const>, type <const>, SetNuiFocus <const>, table <const>, RegisterNUICallback <const>, IsNuiFocused <const> = SetCursorLocation, SetNuiFocusKeepInput, SendNUIMessage, type, SetNuiFocus, table, RegisterNUICallback, IsNuiFocused 

local Locations <const> = {
    ['top-right'] = {},
    ['bottom-right'] = {0.90, 0.90}
}

--- supv.sendReactMessage
---@param visible? boolean
---@param value? SendReactValue
---@param options? SendReactOptions
local function SendReactMessage(visible, value, options)
    if type(visible) == 'boolean' then
        --SendNUIMessage({
        --    action = 'setVisible',
        --    data = visible
        --})
        
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
            SetCursorLocation(Locations[options.locations][1], Locations[options.locations][2])
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

return {
    SendReactMessage = SendReactMessage,
    RegisterReactCallback = RegisterReactCallback
}

--[[
    SetCursorLocation(0.90, 0.90) bottom-right
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
--]]