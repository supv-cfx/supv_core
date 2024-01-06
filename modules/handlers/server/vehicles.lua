---@param source integer
---@param netId integer
---@param properties table
function supv.setVehicleProperties(source, netId, properties)
    emit.net('supv_core:setVehiclesProperties', source, netId, properties)
end

---@param source integer
---@param netId integer
---@param filter? table
function supv.getVehicleProperties(source, netId, filter)
    return callback.sync('supv_core:getVehiclesProperties', source, netId, filter)
end