fx_version 'cerulean'
games {"gta5"}

author 'Nazu'
version '1.0.0'

-----------
-- SHARED
------
shared_script {
    'config.lua',
    'shared/**/*.lua',
}

------------
-- CLIENT 
-------
client_scripts {
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