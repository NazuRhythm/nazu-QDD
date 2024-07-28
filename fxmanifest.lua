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
dependencies { 'PolyZone' , 'ox_lib', 'nazu-bridge' }

-----------
-- STREAM
------

files{
	'**/weaponcomponents.meta',
	'**/weaponarchetypes.meta',
	'**/weaponanimations.meta',
	'**/pedpersonality.meta',
	'**/weapons.meta',
}

data_file 'DLC_ITYP_REQUEST' 'stream/nz_prop_arm_wrestle_01.ytyp'
data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/weapons.meta'