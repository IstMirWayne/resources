fx_version 'cerulean'
game 'gta5'

author 'InZidiuZ'
description 'https://github.com/InZidiuZ/LegacyFuel'

version '1.0.0'

server_scripts {
    'config.lua',
    'source/fuel_server.lua'
}

client_scripts {
    'config.lua',
    'source/fuel_client.lua'
}

exports {
    'GetFuel',
    'SetFuel'
}
