fx_version 'cerulean'
game 'gta5'
version '1.3'
author 'aiakoscodem'

shared_scripts {
	'config/config.lua',
	'config/GetCore.lua',
	'locales/*.lua',

}

client_scripts {
	'client/*.lua',
	'editable/editableclient.lua',
	'editable/interaction.lua'

}

server_scripts {

	-- '@mysql-async/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'mysql-async'.:warning:
	'@oxmysql/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'oxmysql'.:warning:
	'config/server_config.lua',
	'editable/servertaxes.lua',
	'server/*.lua',
	'editable/serverexport.lua',

}

ui_page "html/index.html"

files {
	'html/**/*'
}

escrow_ignore {
	'server/utility.lua',
	'server/functions.lua',
	'locales/*.lua',
	'config/*.lua',
	'client/utility.lua',
	'editable/*.lua',
}

dependencies {
	'/server:4752',
	'/onesync',
	'codem-billing-prop'
}

lua54 'yes'

dependency '/assetpacks'