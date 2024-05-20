if cfg.Framework then
    CreateThread(function()
        if cfg.Framework == "QBCore" then
            while GetResourceState("qb-core") ~= "started" do
                Wait(5)
            end

            Wait(1000)

            Core = exports["qb-core"]:GetCoreObject()
        elseif cfg.Framework == "ESX" then
            while GetResourceState("es_extended") ~= "started" do
                Wait(5)
            end

            Wait(1000)
            
            Core = exports["es_extended"]:getSharedObject()
        end

        while not Core do
            Wait(5)
        end

        Lib.getPlayer = function(id)
            if cfg.Framework == "QBCore" then
                return Core.Functions.GetPlayer(id)
            elseif cfg.Framework == "ESX" then
                return Core.GetPlayerFromId(id)
            end
        end

        Lib.getName = function(id)
            local player = Lib.getPlayer(id)

            if player then
                if cfg.Framework == "QBCore" then
                    return player.PlayerData.charinfo.firstname.." "..player.PlayerData.charinfo.lastname
                elseif cfg.Framework == "ESX" then
                    return player.variables.firstName.." "..player.variables.lastName
                end
            end
        end

        Lib.getCitizen = function(id)
            local player = Lib.getPlayer(id)

            if player then
                if cfg.Framework == "QBCore" then
                    return player.PlayerData.citizenid
                elseif cfg.Framework == "ESX" then
                    return player.identifier
                end
            end
        end

        Lib.checkMoney = function(id, account)
            local player = Lib.getPlayer(id)

            if player then
                if account == "cash" then
                    if cfg.Framework == "QBCore" then
                        return player.PlayerData.money.cash
                    elseif cfg.Framework == "ESX" then
                        return player.getAccount('money').money
                    end
                elseif account == "bank" then
                    if cfg.Framework == "QBCore" then
                        return player.PlayerData.money.bank
                    elseif cfg.Framework == "ESX" then
                        return player.getAccount('bank').money
                    end
                end
            end
        end 

        Lib.addMoney = function(id, account, amount)
            local player = Lib.getPlayer(id)

            if player then
                if account == "cash" then
                    if cfg.Framework == "QBCore" then
                        player.Functions.AddMoney('cash', amount)
                    elseif cfg.Framework == "ESX" then
                        player.addAccountMoney('money', amount)
                    end
                elseif account == "bank" then
                    if cfg.Framework == "QBCore" then
                        player.Functions.AddMoney('bank', amount)
                    elseif cfg.Framework == "ESX" then
                        player.addAccountMoney('bank', amount)
                    end
                end
            end
        end

        Lib.removeMoney = function(id, account, amount)
            local player = Lib.getPlayer(id)

            if player then
                if account == "cash" then
                    if cfg.Framework == "QBCore" then
                        player.Functions.RemoveMoney('cash', amount)
                    elseif cfg.Framework == "ESX" then
                        player.removeAccountMoney('money', amount)
                    end
                elseif account == "bank" then
                    if cfg.Framework == "QBCore" then
                        player.Functions.RemoveMoney('bank', amount)
                    elseif cfg.Framework == "ESX" then
                        player.removeAccountMoney('bank', amount)
                    end
                end
            end
        end
    end)
end
