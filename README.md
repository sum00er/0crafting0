# 0crafting0
crafting script with NUI for ESX FiveM servers

preview: https://youtu.be/VTRzMWBhUT8

requirement: ESX(any version), ox_lib(optional, for the progbar)

support: https://discord.gg/pjuPHPrHnx

### Installation
1. Download .zip and unzip it into your resource folder
2. Name the folder as **0crafting0**
3. Configure config.lua.
    * Remember to configure oldesx, oxinv and limitSystem according to your server setup.
    * If you are not using ox_lib, you should put your progbar function under Progbar in config.lua. Return sucess() if the progbar is finished, and return cancel() if the progbar is cancelled.