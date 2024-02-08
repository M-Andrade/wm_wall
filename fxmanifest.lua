fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'oandrade'
description 'WM-Wall'

lua54 'yes'
escrow_ignore {
    'client.lua',
    'server.lua',
}

client_scripts {
    'client.lua',
    '@vorp_core/client/dataview.lua'
 }

server_script 'server.lua'
