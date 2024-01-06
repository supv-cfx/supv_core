---@param source integer
---@param select 'simple'
---@param data data
function supv.notify(source, select, data)
    emit.net('notify', source, select, data)
end