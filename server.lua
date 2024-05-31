local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('disi-cicekci:server:getConfig', function(source, cb)
    cb(Config)
end)

QBCore.Functions.CreateCallback('disi-cicekci:server:getLicense', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata["licences"]
    
    cb(licenseTable)
end)

RegisterNetEvent('disi-cicekci:server:SellItems', function(itemName, itemAmount, itemPrice)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData 

    if PlayerData.job.name == "flower1" then 
        local totalPrice = tonumber(itemAmount) * itemPrice

        if Player.Functions.RemoveItem(itemName, tonumber(itemAmount)) then
            Player.Functions.AddItem('blackmoney', totalPrice)
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.sold', {value = tonumber(itemAmount), value2 = QBCore.Shared.Items[itemName].label, value3 = totalPrice}), 'success')
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_items'), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Çiçekçi Değilsin Be Kardeşim Bi Sal.", 'error') 
    end
end)

QBCore.Functions.CreateCallback('disi-cicekci:server:getInv', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local inventory = Player.PlayerData.items

    cb(inventory)
end)
