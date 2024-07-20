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
dependencies { 'ox_lib', 'nazu-bridge' }

-----------
-- STREAM
------
data_file 'DLC_ITYP_REQUEST' 'stream/nz_prop_arm_wrestle_01.ytyp'