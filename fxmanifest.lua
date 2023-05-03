fx_version 'cerulean'
games {'gta5', 'rdr3'}

lua54 'yes'
use_experimental_fxv2_oal 'yes'

version '1.0'

author 'SUP2Ak#3755'
link 'https://github.com/SUP2Ak/supv_core'
github 'https://github.com/SUP2Ak'

--[[
descriptions {
    fr 'Un core utils pour developper des scripts sur FiveM & RedM',
    en 'A core utility for developing scripts on FiveM & RedM'
}

how_to_use {
    fr "Dans votre ressource, mettez ceci : shared_script '@supv_core/obj.lua' ",
    en "In your resource, add this : shared_script '@supv_core/obj.lua' "
}
--]]

ui_page 'web/build/index.html'

files {
    'obj.lua',
    'shared/config/*.lua',
    'client/config/*.lua',
    'client/modules/*.lua',
    'locales/*.json',
    'imports/**/client.lua',
    'imports/**/shared.lua',
    'web/build/index.html',
    'web/build/**/*'
}

shared_scripts {
    'init.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua',
    'client/nui/*.lua'
}

server_script {
    'package/dist/server/server.js',
    'server/*.lua',
}