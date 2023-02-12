
local tr <const>, cfg <const> = Config.SelectedLanguage, Config
local message <const> = cfg.Translate[tr].version

supv.version.check("https://raw.githubusercontent.com/SUP2Ak/supv_core/main/version.json", message.needUpate, message.error, 'json', "https://github.com/SUP2Ak/supv_core")