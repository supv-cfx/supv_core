---@deprecated 
--- supv.createDialog is deprecated, supv.createModals should be used instead but not implemented yet


local p, nui <const> = nil, require 'client.modules.nui'

---@param data boolean
nui.RegisterReactCallback('supv:dialog:closed', function(data, cb)
    if p then p:resolve(data) end p = nil
    cb(1)
end, true)


---@class DialogDataProps
---@field title? string
---@field subtitle? string
---@field description? string

--- supv.createDialog
---@param data DialogDataProps
---@return boolean
function supv.createDialog(data)
    if type(data) ~= 'table' then return end
    if not data.title and not data.description and not data.subtitle then return end
    if p then return end

    nui.SendReactMessage(true, {
        action = 'supv:dialog:opened',
        data = data
    }, {
        focus = true
    })

    p = promise.new()
    return supv.await(p)
end