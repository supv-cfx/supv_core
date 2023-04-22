
local tr <const>, cfg <const> = Config.SelectedLanguage, Config
local message <const> = cfg.Translate[tr].version

supv.version.check("https://raw.githubusercontent.com/SUP2Ak/supv_core/main/version.json", message.needUpate, message.error, 'json', "https://github.com/SUP2Ak/supv_core", nil, 2000, #cfg.Webhook.channel['supv_core'] > 0 and {
    {
        link = cfg.Webhook.channel.supv_core,
    }
} or nil)