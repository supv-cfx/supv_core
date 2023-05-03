local config <const> = require 'shared.config.chat'
if not config.chat_supv then return end

local SetTextChatEnabled <const> = SetTextChatEnabled

CreateThread(function()
    SetTextChatEnabled(false) -- disable chat default
end)

---@todo chat react command + suggestion interface