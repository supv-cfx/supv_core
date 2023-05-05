local p, nui <const> = nil, require 'client.modules.nui'

---@param data boolean
nui.RegisterReactCallback('supv:modal:closed', function(data, cb)
    if p then p:resolve(data) end p = nil
    cb(1)
end, true)

---@class ModalConfrim
---@field type 'confirm'
---@field title? string
---@field subtitle? string
---@field description? string

--- supv.openModal
---@param data ModalConfrim|...
---@return boolean
function supv.openModal(data)
    if type(data) ~= 'table' then return end
    if type(data.type) ~= 'string' then return end
    if p then return end

    nui.SendReactMessage(true, {
        action = 'supv:modal:opened',
        data = data
    }, {
        focus = true
    })

    p = promise.new()
    return supv.await(p)
end