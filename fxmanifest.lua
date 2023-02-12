fx_version 'cerulean'
game 'gta5'

author 'sum00er'
lua54 'yes'

shared_scripts {'@es_extended/imports.lua', '@es_extended/locale.lua', 'locales/*.lua', '@ox_lib/init.lua', 'config.lua'}

server_script 'server/main.lua'

client_script 'client/main.lua'

ui_page 'html/index.html'

files {'html/index.html', 'html/listener.js', 'html/style.css', 'html/img/*.png'}