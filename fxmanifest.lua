fx_version 'cerulean'
games {"gta5"}

author 'NazuMod | Script'
version '1.0.0'
lua54 'yes'

-----------
-- SHARED
------
shared_script {
    'config.lua',
    'locales/*.lua',
    'shared/**/*.lua',
    '@ox_lib/init.lua',
}

------------
-- CLIENT 
-------
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    'client/**/*.lua',
}

------
-- SERVER 
------
server_scripts {
    'server/**/*.lua',
}

-----------------
-- Dependencies 
---------
dependencies { 'PolyZone' , 'ox_lib', 'nazu-bridge', 'nazu-QDD-Objects', }