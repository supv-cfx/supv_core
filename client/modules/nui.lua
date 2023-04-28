---@class SendReactValue
---@field action string
---@field data? any
 
---@class SendReactOptions
---@field focus? boolean|table

local SendNUIMessage <const>, type <const>, SetNuiFocus <const>, table <const>, RegisterNUICallback <const> = SendNUIMessage, type, SetNuiFocus, table, RegisterNUICallback

--- supv.sendReactMessage
---@param visible? boolean
---@param value? SendReactValue
---@param options? SendReactOptions
local function SendReactMessage(visible, value, options)
    if type(visible) == 'boolean' then
        SendNUIMessage({
            action = 'setVisible',
            data = visible
        })
        
        ---@todo reset focus options when visible is false and focus active = true
        if not visible and IsNuiFocused() then
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

        ---@todo add more options about focus
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