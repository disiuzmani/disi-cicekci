local QBCore = exports['qb-core']:GetCoreObject()
local ped
local traderBuyGoods, traderSellGoods = {}, {}
local sellItems, buyItems = false, false

-- Functions
local function _CreatePed(hash, coords, scenario)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end

    ped = CreatePed(4, hash, coords, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    TaskStartScenarioInPlace(ped, scenario, 0, true)
    SetEntityInvincible(ped, true)
    SetEntityCanBeDamaged(ped, false) 
    SetEntityProofs(ped, true, true, true, true, true, true, 1, true)
    FreezeEntityPosition(ped, true)
end

-- Threads
CreateThread(function()
    QBCore.Functions.TriggerCallback('disi-cicekci:server:getConfig', function(Config)
        if Config and Config.Traders then
            for k, v in pairs(Config.Traders) do
                for i = 1, #v.coords do
                    _CreatePed(GetHashKey(v.model), vector4(v.coords[i].x, v.coords[i].y, v.coords[i].z -1, v.coords[i].w), v.scenario)

                    local blipcoord = vector2(v.coords[i].x, v.coords[i].y)
                    local blipInfo = v.blip

                    if blipInfo.Show then
                        local traderBlip = AddBlipForCoord(blipcoord)
                        SetBlipSprite(traderBlip, blipInfo.Type)
                        SetBlipScale(traderBlip, blipInfo.Scale)
                        SetBlipColour(traderBlip, blipInfo.Color)
                        SetBlipAsShortRange(traderBlip, true)
                        BeginTextCommandSetBlipName('STRING')
                        AddTextComponentSubstringPlayerName(blipInfo.Name)
                        EndTextCommandSetBlipName(traderBlip)
                    end

                    exports['qb-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                type = 'client',
                                action = function(entity)
                                    traderBuyGoods, traderSellGoods = {}, {}
                                    sellItems, buyItems = false, false
                                    local traderBuy = v.items.buy
                                    local traderSell = v.items.sell
                                    local license = v.license[1]
                                    local lisenseLabel = v.license.label
                                    
                                    if license then
                                        QBCore.Functions.TriggerCallback('disi-cicekci:server:getLicense', function(licenseTable)
                                            if licenseTable[license] then

                                                if v.buyItems == true then
                                                    buyItems = true
                                                    for i = 1, #traderBuy do
                                                        traderBuyGoods[#traderBuyGoods+1] = traderBuy[i]
                                                    end
                                                end
            
                                                if v.sellItems == true then
                                                    sellItems = true
                                                    local index = 0
                                                    for i = 1, #traderSell do
                                                        index = index + 1
                                                        
                                                        local data = {}
                                                        if traderSell[i].info then
                                                            data = {
                                                                name = traderSell[i].name,
                                                                price = traderSell[i].price,
                                                                amount = 9999,
                                                                info = traderSell[i].info,
                                                                type = 'item',
                                                                slot = index
                                                            }
                                                        else
                                                            data = {
                                                                name = traderSell[i].name,
                                                                price = traderSell[i].price,
                                                                amount = 9999,
                                                                info = {},
                                                                type = 'item',
                                                                slot = index
                                                            }
                                                        end
            
                                                        traderSellGoods[#traderSellGoods+1] = data
                                                    end
                                                end
        
                                                TriggerEvent('disi-cicekci:client:OpenMenu')
                                            else
                                                QBCore.Functions.Notify(Lang:t('error.no_license', {value = lisenseLabel}), 'error')
                                            end
                                        end)
                                    else
                                        if v.buyItems == true then
                                            buyItems = true
                                            for i = 1, #traderBuy do
                                                traderBuyGoods[#traderBuyGoods+1] = traderBuy[i]
                                            end
                                        end

                                        if v.sellItems == true then
                                            sellItems = true
                                            local index = 0
                                            for i = 1, #traderSell do
                                                index = index + 1
                                                
                                                local data = {}
                                                if traderSell[i].info then
                                                    data = {
                                                        name = traderSell[i].name,
                                                        price = traderSell[i].price,
                                                        amount = 9999,
                                                        info = traderSell[i].info,
                                                        type = 'item',
                                                        slot = index
                                                    }
                                                else
                                                    data = {
                                                        name = traderSell[i].name,
                                                        price = traderSell[i].price,
                                                        amount = 9999,
                                                        info = {},
                                                        type = 'item',
                                                        slot = index
                                                    }
                                                end

                                                traderSellGoods[#traderSellGoods+1] = data
                                            end
                                        end

                                        TriggerEvent('disi-cicekci:client:OpenMenu')
                                    end
                                end,
                                icon = 'fas fa-sign-in-alt',
                                label = Lang:t('info.title'),
                            },
                        },
                        distance = 2.0
                    })
                end
            end
        end
    end)
end)

-- Events
RegisterNetEvent('disi-cicekci:client:OpenMenu', function()

    local openShop = {
        {
            header = Lang:t('info.title'),
            isMenuHeader = true,
        }
    }

    if buyItems then
        openShop[#openShop +1] = {
            header = Lang:t('info.sell'),
            txt = Lang:t('info.sell_to'),
            params = {
                event = 'disi-cicekci:client:OpenSellMenu',
                args = {
                    items = traderBuyGoods,
                }
            }
        }
    end

    if sellItems then
        openShop[#openShop +1] = {
            header = Lang:t('info.buy'),
            txt = Lang:t('info.buy_from'),
            params = {
                event = 'disi_cicekci:client:OpenShop',
            }
        }
    end

    openShop[#openShop +1] = {
        header = Lang:t('info.close'),

        params = {
            event = 'qb-menu:closeMenu' 
        }
    }

    exports['qb-menu']:openMenu(openShop)
    
end)

RegisterNetEvent('disi-cicekci:client:OpenSellMenu', function(data)
    QBCore.Functions.TriggerCallback('disi-cicekci:server:getInv', function(inventory)

        local sellMenu = {
            {
				header = Lang:t('info.sell'),
				isMenuHeader = true,
			}
        }

        for k,v in pairs(inventory) do
			for i = 1, #data.items do
				if v.name == data.items[i].item then
				sellMenu[#sellMenu +1] = {
				 	header = QBCore.Shared.Items[v.name].label,
				    txt = Lang:t('info.sell_items', {value = data.items[i].price}),
				    params = {
				        event = 'disi-cicekci:client:SellItems',
							args = {
								label = QBCore.Shared.Items[v.name].label,
								price = data.items[i].price,
								name = v.name,
								amount = v.amount
							}
				    }
				}
				end
			end
		end

        sellMenu[#sellMenu+1] = {
			header = Lang:t('info.back'),
			params = {
				event = 'disi-cicekci:client:OpenMenu'
			}
		}

        exports['qb-menu']:openMenu(sellMenu)
    end)
end)

RegisterNetEvent('disi-cicekci:client:SellItems', function(item)
	local sellingItem = exports['qb-input']:ShowInput({
		header = Lang:t('info.title'),
		submitText = Lang:t('info.sell'),
		inputs = {
			{
				type = 'number',
				isRequired = false,
				name = 'amount',
				text = Lang:t('info.max', {value = item.amount})
			}
		}
	})

	if sellingItem then
		if not sellingItem.amount then
			return
		end

		if tonumber(sellingItem.amount) > 0 then
			TriggerServerEvent('disi-cicekci:server:SellItems', item.name, sellingItem.amount, item.price)
		else
			QBCore.Functions.Notify(Lang:t('error.negative'), 'error')
		end
	end
end)

RegisterNetEvent('disi_cicekci:client:OpenShop', function()
    local ShopItems = {}

    ShopItems.label = Lang:t('info.title')
    ShopItems.items = traderSellGoods
    ShopItems.slots = #traderSellGoods

    TriggerServerEvent('inventory:server:OpenInventory', 'shop', 'Trader', ShopItems)

end)
