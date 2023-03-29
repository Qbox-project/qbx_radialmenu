fx_version 'cerulean'
game 'gta5'

description 'Qbx-radialmenu'
version '1.0.0'


shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

provide 'qb-radialmenu'
lua54 'yes'
