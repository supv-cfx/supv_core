---@type fun(index: number, value: any): void | nil
local onCallback
local p

---@class DataConfirmProps
---@field title? string
---@field description? string
---@field transition? { name: string, duration: number, timingFunction: string } ref: https://mantine.dev/core/transition/

---@class ModalConfirm
---@field data? DataConfirmProps

---@class DataCustomProps
---@field title string
---@field options { type: 'checkbox' | 'input' | 'select' | 'date' | 'password' | 'number', label: string }
---@field canCancel? boolean
---@field transition? { name: string, duration: number, timingFunction: string } ref: https://mantine.dev/core/transition/

---@class ModalCustom
---@field data DataCustomProps
---@field callback fun(index: number, value: any): void

---@param title string
---@param data DataCustomProps
---@param callback fun(index: number, value: any): void
---@return table|nil
---@type ModalCustom
local function Custom(data, callback) 
    if type(data) ~= 'table' then return end
    if type(data.title) ~= 'string' then return end
    onCallback = callback

    supv.sendReactMessage(true, {
        action = 'supv:modal:opened-custom',
        data = {
            title = data.title,
            canCancel = data.canCancel,
            transition = data.transition,
            options = data.options,
            useCallback = callback and true or false
        }
    }, {
        focus = true,
        locations = 'center'
    })

    p = promise.new()
    return supv.await(p)
end

---@param data DataConfirmProps
---@return boolean
---@type ModalConfirm
local function Confirm(data)
    if type(data) ~= 'table' then return end

    supv.sendReactMessage(true, {
        action = 'supv:modal:opened-confirm',
        data = data
    }, {
        focus = true,
        locations = 'center'
    })

    p = promise.new()
    return supv.await(p)
end

---@param types custom | confirm as string
---@param data table
---@param callback fun(index: number, value: any)
---@return table|boolean|nil
function supv.openModal(types, data, callback)
    if p or type(types) ~= 'string' then return end

    if types == 'custom' then
        return Custom(data, callback)
    elseif types == 'confirm' then
        return Confirm(data)
    end
end

---@param data boolean
supv.registerReactCallback('supv:modal:confirm', function(data, cb)
    if p then p:resolve(data) end p = nil
    cb(1)
end, true)

---@param data { index: number, value: any }
supv.registerReactCallback('supv:modal:submit', function(data, cb)
    cb(1)
    if p then p:resolve(data) end p, onCallback = nil, nil
end, true)

---@param data { index: number, value: any }
supv.registerReactCallback('supv:modal:callback', function(data, cb)
    cb(1)
    onCallback(data.index, data.value)
end)