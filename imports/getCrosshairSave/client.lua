function supv.getCrosshairSave(cb)
    if type(cb) ~= 'function' then return end
    AddEventHandler('supv_core:crosshair:save', cb)
end

return supv.getCrosshairSave