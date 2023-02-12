if Config.oldESX then
	ESX = nil
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

local crafting = {}

ESX.RegisterServerCallback('0crafting0:checkItem', function(source, cb, item, count)
	local mat = Config.items[item].material
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(mat) do
		local xItem
		if not Config.oxinv then
			xItem = xPlayer.getInventoryItem(v.name)
		else
			xItem = exports.ox_inventory:GetItem(source, v.name, nil, false)
		end
		if xItem.count < v.count * count then
			xPlayer.showNotification(_U('not_enough', xItem.label))
			cb(false)
			return
		end
	end
	if not Config.oxinv then
		if string.sub(item, 1, string.len('WEAPON_')) == 'WEAPON_' then
			if xPlayer.hasWeapon(item) then
				local loadoutNum, weapon = xPlayer.getWeapon(item)
				xPlayer.showNotification(_U('cannot_hold', count, xPlayer.loadout[loadoutNum].label))
				cb(false)
				return
			end
		elseif Config.limitSystem then
			local xItem = xPlayer.getInventoryItem(item)
			if xItem.count + count > xItem.limit then
				xPlayer.showNotification(_U('cannot_hold', count, xItem.label))
				cb(false)
				return
			end
		else
			local canCarry = xPlayer.canCarryItem(item, count)
			local xItem = xPlayer.getInventoryItem(item)
			if not canCarry then
				xPlayer.showNotification(_U('cannot_hold', count, xItem.label))
				cb(false)
				return
			end
		end
	else
		local canCarry = exports.ox_inventory:CanCarryItem(source, item, count)
		if not canCarry then
			local xItem = exports.ox_inventory:GetItem(source, item, nil, false)
			xPlayer.showNotification(_U('cannot_hold', count, xItem.label))
			cb(false)
			return
		end
	end
	crafting[source] = true
	cb(true)
end)

RegisterNetEvent('0crafting0:craftItem')
AddEventHandler('0crafting0:craftItem', function(item, count)
	local source = source
	if not crafting[source] then
		return
	end
	local mat = Config.items[item].material
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(mat) do
		local xItem
		if not Config.oxinv then
			xItem = xPlayer.getInventoryItem(v.name)
		else
			xItem = exports.ox_inventory:GetItem(source, v.name, nil, false)
		end
		if xItem.count < v.count * count then
			xPlayer.showNotification(_U('material_disappear', (v.count * count), xItem.label))
			cb(false)
			return
		else
			if not Config.oxinv then
				xPlayer.removeInventoryItem(v.name, v.count * count)
			else
				exports.ox_inventory:RemoveItem(source, v.name, v.count * count)
			end
		end
	end
	if not Config.oxinv then
		local xPlayer = ESX.GetPlayerFromId(source)
		if string.sub(item, 1, string.len('WEAPON_')) == 'WEAPON_' then
			if xPlayer.hasWeapon(item) then
				xPlayer.showNotification(_U('backpack_full'))
			else
				xPlayer.addWeapon(item, 0)
			end
		elseif Config.limitSystem then
			local xItem = xPlayer.getInventoryItem(item)
			if xItem.count + count > xItem.limit then
				xPlayer.showNotification(_U('backpack_full'))
			else
				xPlayer.addInventoryItem(item, count)
			end
		else
			local canCarry = xPlayer.canCarryItem(item, count)
			if not canCarry then
				xPlayer.showNotification(_U('backpack_full'))
			else
				xPlayer.addInventoryItem(item, count)
			end
		end
	else
		local canCarry = exports.ox_inventory:CanCarryItem(source, item, count)
		if not canCarry then
			xPlayer.showNotification(_U('backpack_full'))
		else
			exports.ox_inventory:AddItem(source, item, count)
		end
	end
	crafting[source] = nil
end)