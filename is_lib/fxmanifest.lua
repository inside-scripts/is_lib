-- FX Information

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- Resource Information

name 'is_lib'
author 'inside-scripts'
version '1.0.6'
repository 'https://github.com/inside-scripts/is-lib'
description 'A Library that facilitates the use of multiple frameworks, inventories and various systems in one. It also includes many features that enhance functionality.'

-- Manifest

client_scripts {
    'config.lua',
    'client/main.lua',
    'shared/functions.lua',
    'client/framework.lua',
    'client/callbacks.lua',
    'client/fuel.lua',
    'client/vehiclekeys.lua',
    'client/entity.lua',
    'client/blip.lua',
    -- 'client/interactions.lua'
}

server_scripts {
    'config.lua',
    'server/main.lua',
    'shared/functions.lua',
    'server/framework.lua',
    'server/timezone.lua',
    'server/webhook.lua',
    'server/commands.lua',
    'server/callbacks.lua',
    'server/inventory.lua',
    'server/entity.lua',
}
