fx_version 'cerulean'
games {'gta5', 'rdr3'}
lua54 'yes'
use_experimental_fxv2_oal 'yes'

version 'work in progress'
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

--server_script 'package/dist/server/server.js'
shared_script 'init.lua'
server_script 'modules/init.lua'
client_script 'modules/init.lua'

files {
    'obj.lua',
    'data/client/**.json',
    'config/modules.lua',
    'config/client/*.lua',
    'config/shared/*.lua',
    'modules/**/index.lua',
    'modules/**/shared/**',
    'modules/**/client/**',
    'locales/*.json',
    'imports/**/client.lua',
    'imports/**/shared.lua',
    'web/build/index.html',
    'web/build/**/*'
}

dependencies {
    '/server:6551', -- requires at least server build 6551 (txAdmin v6.0.1)
    '/onesync', -- requires onesync enabled
}