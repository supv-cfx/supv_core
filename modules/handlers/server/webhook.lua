local PerformHttpRequest <const>, config <const> = PerformHttpRequest, require 'config.server.webhook'
local toUpper <const> = require('imports.string.shared').firstToUpper

string.to_utf8 = require('imports.utf8.shared').to_utf8
assert(os.setlocale(config.localization))

---@class WebhookDataProps
---@field bot_name? string
---@field avatar? string
---@field date_format? string
---@field footer_icon? string

---@class WebhookEmbedProps
---@field title? string
---@field description? string
---@field image? string
---@field color? integer

---@class WebhookMessageProps
---@field text string
---@field data WebhookDataProps

--- supv:webhook('embed')
---@param url string
---@param embeds WebhookEmbedProps
---@param data WebhookDataProps
local function embed(url, embeds, data)
    local date <const> = {
        letter = ("\n%s %s"):format(toUpper(os.date("%A %d")), toUpper(os.date("%B %Y : [%H:%M:%S]"))):to_utf8(),
        numeric = ("\n%s"):format(os.date("[%d/%m/%Y] - [%H:%M:%S]"))
    }

    url = config.channel[url] or url

    local _embed = {
        {
			["color"] = data?.color or config.default.color,
			["title"] = embeds.title or '',
			["description"] = embeds.description or '',
			["footer"] = {
				["text"] = data?.date_format and date[data?.date_format] or config.default.date_format and date[config.default.date_format],
				["icon_url"] = data?.footer_icon or config.default.foot_icon,
			},
            ['image'] = {
                ['url'] = embeds.image or nil
            }
		},
    }

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({
        username = data?.bot_name or config.default.bot_name,
        embeds = _embed,
        avatar_url = data?.avatar or config.default.avatar,
    }), {['Content-Type'] = 'application/json'})
end

--- supv:webhook('message')
---@param url string
---@param text string
---@param data WebhookDataProps.bot_name
local function message(url, text, data)
    local c <const> = config
    url = config.channel[url] or url

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({
        username = data.bot_name or config.default.bot_name,
        content = text
    }), {['Content-Type'] = 'application/json', ['charset'] = 'utf-8'})
end

---@param types string
---@param ... any
---@return void
local function SendWebhookDiscord(types, ...)
    if types == 'embed' then
        return embed(...)
    elseif types == 'message' then
        return message(...)
    end
    return error("Invalid types of webhook", 1)
end

supv.webhook = SendWebhookDiscord

if config.playing_from ~= 'shared' then return end

---@todo need more implementation about webhook send from client
supv:onNet('webhook:received', function (source, types, ...)
    warn(("%s trying to playing webhook from client"):format(source))
    supv.webhook(types, ...)
end)