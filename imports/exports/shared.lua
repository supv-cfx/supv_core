---@param export string 'resourceName.methodName'
---@param ... any
---@return void | any
function supv.exports(export, ...)
    local resourceName <const> = export:match('(.+)%..+')
    local methodName <const> = export:match('.+%.(.+)')
    return exports[resourceName][methodName](nil, ...)
end

return supv.exports