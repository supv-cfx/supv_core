fx_version 'cerulean'
games { 'gta5', 'rdr3' }
lua54 'yes'
use_experimental_fxv2_oal 'yes'

version '2.0.0'
author 'SUP2Ak'
link 'https://github.com/SUP2Ak/supv_core'
github 'https://github.com/SUP2Ak'

shared_script 'init.lua'
server_script 'modules/init.lua'
client_script 'modules/init.lua'

files {
    'config/client/*.lua',
    'config/shared/*.lua',
    'modules/starter/modules.lua',
    'obj.lua',
    'modules/**/index.lua',
    -- 'modules/**/shared/**',
    'modules/**/client/**',
    -- 'locales/*.json', -- sans doute à ajouter plus tard (du moins refaire)
    'imports/**/client.lua',
    'imports/**/shared.lua',
}

dependencies {
    '/server:6551', -- requires at least server build 6551 (txAdmin v6.0.1 optional)
    '/onesync', -- requires onesync enabled
}