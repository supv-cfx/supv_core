string.to_utf8 = require ('server.modules.utf8').to_utf8
local cfg <const> = require 'server.config.webhook'

assert(os.setlocale(cfg.localization))

local PerformHttpRequest <const> = PerformHttpRequest

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

--- supv.webhook('embed')
---@param url string
---@param embeds WebhookEmbedProps
---@param data WebhookDataProps
local function embed(url, embeds, data)
    local date = {
        letter = ("\n%s %s"):format(supv.string.firstToUpper(os.date("%A %d")), supv.string.firstToUpper(os.date("%B %Y : [%H:%M:%S]"))):to_utf8(),
        numeric = ("\n%s"):format(os.date("[%d/%m/%Y] - [%H:%M:%S]"))
    }

    url = cfg.channel[url] or url

    local _embed = {
        {
			["color"] = data.color or cfg.default.color,
			["title"] = embeds.title or '',
			["description"] = embeds.description or '',
			["footer"] = {
				["text"] = data.date_format and date[data.date_format] or cfg.default.date_format and date[cfg.default.date_format],
				["icon_url"] = data.footer_icon or cfg.default.foot_icon,
			},
            ['image'] = {
                ['url'] = embeds.image or nil
            }
		},
    }

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({
        username = data.bot_name or cfg.default.bot_name,
        embeds = _embed,
        avatar_url = data.avatar or cfg.default.avatar,
    }), {['Content-Type'] = 'application/json'})
end

--- supv.webhook('message')
---@param url string
---@param text string
---@param data WebhookDataProps.bot_name
local function message(url, text, data)
    url = cfg.channel[url] or url

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({
        username = data.bot_name or cfg.default.bot_name,
        content = text
    }), {['Content-Type'] = 'application/json', ['charset'] = 'utf-8'})
end

---@param types string
---@param ... any
---@return void
function supv.webhook(types, ...)
    if types == 'embed' then
        return embed(...)
    elseif types == 'message' then
        return message(...)
    end
    return error("Invalid types of webhook", 1)
end

if cfg.played_from ~= 'shared' then return end

RegisterNetEvent('supv_core:server:webhook:send', function (types, ...)
    local _source = source
    print(_source, 'play webhook from client')
    supv.webhook(types, ...)
end)
