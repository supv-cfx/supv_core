
local function Message(channel_id, text, bot_name)
    return TriggerEvent('supv_core:server:webhook:message', channel_id, text, bot_name)
end

local function Embed(channel_id, embed, bot_name, avatar)
    return TriggerEvent('supv_core:server:webhook:embed', channel_id, embed, bot_name, avatar)
end

return {
    message = Message,
    embed = Embed
}