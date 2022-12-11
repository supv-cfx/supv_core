-- Config.StageBag = { -- don't touch this not implemented yet
--     player = {
--         coords = true
--     }
-- }

Config.DevMod = false -- turn on true only if you want print ara visible
Config.SelectedLanguage = 'fr' -- or 'en'

Config.Translate = {
    ['fr'] = {
        version = {
            needUpate = "^3Veuillez mettre à jour la ressource %s\n^3votre version : ^1%s ^7->^3 nouvelle version : ^2%s\n^3liens : ^4%s",
            error = "^1Impossible de vérifier la version du script"
        }
    },
    ['en'] = {
        version = {
            needUpate = "^3Update this resource %s\n^3your version : ^1%s ^7->^4 new version : ^2%s\n^3link : ^4%s",
            error = "^1Impossible to check version of script"
        }
    }
}
