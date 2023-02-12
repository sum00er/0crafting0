Config = {}

Config.oldESX = false   --set true if you need esx getSharedObject

Config.oxinv = true --set true if using ox_inventory

Config.limitSystem = false  --set to true if using esx 1.1

Config.Locale = 'en'

Config.time = 5000  --time to craft 1 item, final time will be multiplied by the quantity

Config.locations = {    --multiple locations can be added here
    vec3(-343.35, -140.18, 39.01),
}

Config.cat = {--categories
    {
        catid = 'ambulance',    --id for items in Config.items to refrence to the category 
        label = 'medical stuff' --label shown on the nui
    },
    {
        catid = 'weapon',
        label = 'weapon'
    },
    {
        catid = 'general',
        label = 'general'
    },
}

Config.items = {
    ['armour'] = {  --itemname
        name = 'armour',    --itemname, must be the same as the key
        label = 'armour',   --label shown on the nui
        catid = 'general',  --catid should match one of the categories in Config.cat
        material = {
            {name = 'wool', label = 'wool', count = 20},
            {name = 'iron', label = 'iron', count = 20},
            {name = 'turtle', label = 'turtle', count = 1},
        }
    },
    ['armour50'] = {
        name = 'armour50',
        label = '50% armour',
        catid = 'general',
        material = {
            {name = 'wool', label = 'wool', count = 10},
            {name = 'iron', label = 'iron', count = 10},
            {name = 'pineapple', label = 'pineapple', count = 5},

        }
    },
    ['WEAPON_PISTOL'] = {   --if item is a weapon should all be in capital letters
        name = 'WEAPON_PISTOL',
        label = 'pistol',
        catid = 'weapon',
        material = {
            {name = 'copper', label = 'copper', count = 10},
            {name = 'iron', label = 'iron', count = 10},

        }
    },
    ['bandage'] = {
        name = 'bandage',
        label = 'bandage',
        catid = 'ambulance',
        material = {
            {name = 'wool', label = 'wool', count = 1},
            {name = 'pad', label = 'gauze pad', count = 1},
            {name = 'medikit', label = 'medical material', count = 1},
        }
    },
}

Progbar = function(time, sucess, cancel)    --put the progress bar function here, default using ox_lib progress bar
    if lib.progressBar({
        duration = time,
        label = 'carfting...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped'
        },
    }) then
        sucess()    --return scess function when progressbar is not cancelled
    else
        cancel()    --return cancel function when progressbar is not cancelled
    end
end
