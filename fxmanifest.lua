fx_version 'cerulean'
games { 'gta5', 'rdr3' }
lua54 'yes'
use_experimental_fxv2_oal 'yes'

version '2.0.0'
author 'SUP2Ak'
link 'https://github.com/SUP2Ak/supv_core'
github 'https://github.com/SUP2Ak'

--ui_page 'web/build/index.html'

shared_script 'init.lua'
server_script 'modules/init.lua'
client_script 'modules/init.lua'

files {
    'obj.lua',
    'data/client/**.json',
    'data/shared/**.json',
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
    '/server:6551', -- requires at least server build 6551 (txAdmin v6.0.1 optional)
    '/onesync', -- requires onesync enabled
}