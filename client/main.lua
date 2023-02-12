print("^20crafting0 by sum00er. https://discord.gg/pjuPHPrHnx")
if Config.oldESX then 
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false)
    inMenu = false
end)

RegisterNUICallback('craft', function(data, cb)
    data.Count = tonumber(data.Count)
    SetNuiFocus(false)
    if not Config.oxinv and string.sub(data.Item, 1, string.len('WEAPON_')) == 'WEAPON_' and data.Count > 1 then
        data.Count = 1
        ESX.ShowNotification(_U('weapon_only_one'))
    end
    ESX.TriggerServerCallback('0crafting0:checkItem', function(cb)
        if cb then
            local time = data.Count * Config.time
            Progbar(time, function()
                TriggerServerEvent("0crafting0:craftItem", data.Item, data.Count)
                inMenu = false
            end, function()
                inMenu = false
            end)
        else
            inMenu = false
        end
    end, data.Item, data.Count)
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.locations) do
        local blip = AddBlipForCoord(v)

        SetBlipSprite (blip, 544)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.9)
        SetBlipColour (blip, 11)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U('crafting_table'))
        EndTextCommandSetBlipName(blip)
    end
    local sleep = true
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for k, v in pairs(Config.locations) do
            local dist = Vdist(coords, v)
            if dist < 2.0 and not inMenu then
                sleep = false
                if Config.oldESX then
                    ESX.ShowHelpNotification(_U('helptext', '~INPUT_PICKUP~'))
                elseif not textui then
                    ESX.TextUI(_U('helptext', '[E] -'))
                    textui = k
                end
                if IsControlJustReleased(0, 38) then
                    local items = {}
                    for _, i in pairs(Config.items) do
                        local data = {}
                        data.name = i.name
                        data.label = i.label
                        data.material = {json.encode(i.material)}
                        data.catid = i.catid
                        table.insert(items, data)
                    end
                    inMenu = true
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        toggle = true,
                        items = json.encode(items),
                        cat = json.encode(Config.cat),
                    })
                end
            else
                if textui == k then
                    ESX.HideUI()
                    textui = nil
                end
                sleep = true
            end
        end
        if sleep then
            Citizen.Wait(500)
        end
    end
end)

