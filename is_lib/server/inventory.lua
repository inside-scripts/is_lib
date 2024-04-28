Lib.createUsableItem = function(itemName, action)
    if cfg.Framework == "QBCore" then
        Core.Functions.CreateUseableItem(itemName, action)
    elseif cfg.Framework == "ESX" then
        Core.RegisterUsableItem(itemName, action)
    end
end 

Lib.hasItem = function(source, itemName)
    local hasItem = {}

    if cfg.Inventory == "qb-inventory" or cfg.Inventory == "ps-inventory" or cfg.Inventory == "lj-inventory" or cfg.Inventory == "origen_inventory" then
        local item = exports[cfg.Inventory]:GetItemByName(source, itemName)

        if item and item.amount and item.amount > 0 then
            hasItem = {label = item.label, count = item.amount}
        end
    elseif cfg.Inventory == "ox_inventory" then
        local item = exports["qb-inventory"]:GetItem(source, itemName)

        if item and item.count and item.count > 0 then
            hasItem = {label = item.label, count = item.count}
        end
    elseif cfg.Inventory == "qs-inventory" then
        local itemCount = exports['qs-inventory']:GetItemTotalAmount(source, itemName)

        if itemCount ~= nil or itemCount > 0 then
            local itemLabel = exports['qs-inventory']:GetItemLabel(itemName)
            hasItem = {label = itemLabel, count = itemCount}
        end
    elseif cfg.Inventory == "codem-inventory" then 
        local itemCount = exports['codem-inventory']:GetItemsTotalAmount(source, itemName)

        if itemCount ~= nil or itemCount > 0 then
            local itemLabel = exports['codem-inventory']:GetItemLabel(itemName)
            hasItem = {label = itemLabel, count = itemCount}
        end
    elseif cfg.Inventory == "ESX" and cfg.Framework == "ESX" then
        local player = Core.GetPlayerFromId(source)

        if player then
            local item = player.getInventoryItem(itemName)
    
            if item ~= nil and item.count > 0 then
                hasItem = {label = item.label, count = item.count}
            end
        end
    end

    if next(hasItem) ~= nil then
        return hasItem
    else
        return nil
    end
end

Lib.addItem = function(source, itemName, count)
    local count = count or 1

    if cfg.Inventory ~= "ESX" and cfg.Framework ~= "ESX" then
        exports[cfg.Inventory]:AddItem(source, itemName, count)
    else
        local player = Core.GetPlayerFromId(source)
    
        if player then
            player.addInventoryItem(itemName, count)
        end
    end
end

Lib.removeItem = function(source, itemName, count)
    local count = count or 1

    if cfg.Inventory ~= "ESX" and cfg.Framework ~= "ESX" then
        exports[cfg.Inventory]:RemoveItem(source, itemName, count)
    else
        local player = Core.GetPlayerFromId(source)
    
        if player then
            player.removeInventoryItem(itemName, count)
        end
    end
end