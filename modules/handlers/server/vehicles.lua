---@param source integer
---@param netId integer
---@param properties table
function supv.SetVehicleProperties(source, netId, properties)
    require('imports.emit.server').net('supv_core:SetVehiclesProperties', source, netId, properties)
end

---@param source integer
---@param netId integer
---@param filter? table
function supv.GetVehicleProperties(source, netId, filter)
    require('imports.callback.server').sync('supv_core:GetVehiclesProperties', source, netId, filter)
end