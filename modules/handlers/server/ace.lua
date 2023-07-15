local ExecuteCommand <const>, IsPlayerAceAllowed <const> = ExecuteCommand, IsPlayerAceAllowed

-- supv.addAce('identifier.license:2188', 'command.supv_core', true) example
---@param parent string 
---@param ace string
---@param allow boolean
function supv.addAce(parent, ace, allow)
    if type(allow) ~= 'boolean' or type(parent) ~= 'string' or type(ace) ~= 'string' then return end
    ExecuteCommand(('add_ace %s %s %s'):format(parent, ace, allow and 'allow' or 'deny'))
end

-- supv.removeAce('identifier.license:2188', 'command.supv_core', true) example
---@param parent string
---@param ace string
---@param allow boolean
function supv.removeAce(parent, ace, allow)
    if type(allow) ~= 'boolean' or type(parent) ~= 'string' or type(ace) ~= 'string' then return end
    ExecuteCommand(('remove_ace %s %s %s'):format(parent, ace, allow and 'allow' or 'deny'))
end

callback.register('getPlayerAce', function(source, command)
    return IsPlayerAceAllowed(source, command) ---@return boolean
end)