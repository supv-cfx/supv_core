local tr <const> = Config.SelectedLanguage

local message <const> = {
	['fr'] = {
		needUpate = "^3Veuillez mettre à jour la ressource %s\n^3votre version : ^1%s ^7->^3 nouvelle version : ^2%s\n^3liens : ^4%s",
		error = "^1Impossible de vérifier la version du script"
	},

	['en'] = {
		needUpate = "^3Update this resource %s\n^3your version : ^1%s ^7->^4 new version : ^2%s\n^3link : ^4%s",
		error = "^1Impossible to check version of script"
	}
}

supv.version.check("https://raw.githubusercontent.com/SUP2Ak/supv_core/main/fxmanifest.lua", message[tr].needUpate, message[tr].error, 'lua', "https://github.com/SUP2Ak/supv_core")
