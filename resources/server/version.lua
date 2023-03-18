
local tr <const>, cfg <const> = Config.SelectedLanguage, Config
local message <const> = cfg.Translate[tr].version

supv.version.check("https://raw.githubusercontent.com/SUP2Ak/supv_core/main/version.json", message.needUpate, message.error, 'json', "https://github.com/SUP2Ak/supv_core", nil, 2000, #cfg.Webhook.channel['supv_core'] > 0 and {
    {
        link = cfg.Webhook.channel.supv_core,
        message = [[
```md
- __Modules__
    - edit: promt (add function oop instructions)
    - edit: version (add webhook embed info)
- __Resources__
    - edit: `resources/config/server/server` add your webhook link `supv_core` 
```           
]]
    }
})