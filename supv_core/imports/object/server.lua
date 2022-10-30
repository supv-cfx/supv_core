

local function Created(model, coords, cb, mission, doors)
    local obj = CreateObject(model, coords.x, coords.y, coords.z, true, mission or false, doors or false)
    --if DoesEntityExist(obj) then
        cb(obj)
    --end
end

return {
    create = Created
}