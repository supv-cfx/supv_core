local webhook = {}
webhook.channel = Config.Webhook.channel
webhook.default = Config.Webhook.default

local function firstToUpper(str)
    return str:gsub("^%l", string.upper)
end

local DateFormat = {
    letter = ("\n%s %s"):format(firstToUpper(os.date("%A %d")), firstToUpper(os.date("%B %Y à [%H:%M:%S]"))),
    numeric = ("\n%s"):format(os.date("[%d/%m/%Y] - [%H:%M:%S]"))
}

function webhook.get()
    return webhook.channel
end

function webhook.embed(channel_id, embed, bot_name, avatar)
    local found, link = false

    assert(os.setlocale(webhook.default.localisation))
    assert(type(channel_id) == 'string', 'Le channel_id doit être un string (liens ou la clé)')
    assert(type(embed) == 'table', "L'embed doit etre constitué avec une table")

    for k,v in pairs(webhook.channel) do
        if channel_id == k then
            found = true
            link = v
        end
    end

    if not found then
        link = channel_id
    end

    local message = {
		{
			["color"] = embed.color or webhook.default.color,
			["title"] = embed.title or '',
			["description"] = embed.description or '',
			["footer"] = {
				["text"] = (embed.footer_text or '') and DateFormat[webhook.default.dof],
				["icon_url"] = embed.footer_icon or webhook.default.foot_icon,
			},
		}
	}

   PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = bot_name or webhook.default.bot_name, embeds = message, avatar_url = avatar or webhook.default.avatar}), {['Content-Type'] = 'application/json'})
    
end

function webhook.message(channel_id, text, bot_name)

    local found, link = false

    assert(type(channel_id) == 'string', 'Le channel_id doit être un string (liens ou la clé)')

    for k,v in pairs(webhook.channel) do
        if channel_id == k then
            found = true
            link = v
        end
    end

    if not found then
        link = channel_id
    end

    PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = bot_name or webhook.default.bot_name, content = text}), {['Content-Type'] = 'application/json'})
end

RegisterNetEvent('supv_core:server:webhook:embed', function (channel_id, embed, bot_name, avatar)
    return webhook.embed(channel_id, embed, bot_name, avatar)
end)

RegisterNetEvent('supv_core:server:webhook:message', function(channel_id, text, bot_name)
    return webhook.message(channel_id, text, bot_name)
end)
