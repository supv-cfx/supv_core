-- suvp.playerHasAce('command.supv_core') example
---@param command string
---@return unknown
function supv.playerHasAce(command)
    return callback.sync('getPlayerAce', false, command)
end