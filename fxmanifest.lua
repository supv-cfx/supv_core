fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'SUP2Ak'


version '0.2b' -- b for beta

description 'a core standalone to manage your server and got useful function to develop it too'

shared_scripts {'resources/config/shared.lua', 'resources/config/translation.lua', 'resources/config/pickups.lua'}
server_script 'resources/config/server.lua'
client_script 'resources/config/client.lua'

shared_scripts {
    'resources/shared/*.lua', 'import.lua'
}

server_scripts {
    'resources/server/*.lua',
}

client_scripts {
    'resources/config/client.lua',
    'resources/client/*.lua',
}

files {
    'imports/**/shared.lua',
    'imports/**/client.lua',
}