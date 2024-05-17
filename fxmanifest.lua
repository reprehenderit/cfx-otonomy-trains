fx_version 'cerulean'
game 'gta5'

author 'otonomy'
description 'Train spawning system for FiveM.'
version '1.0.0'
lua54 'yes'

shared_script "config/config.lua"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}