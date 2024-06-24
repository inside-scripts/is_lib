if cfg.Framework then
    CreateThread(function()
        if cfg.Framework == "QBCore" then
            while not Lib.isExportAvailable("qb-core", "GetCoreObject") do
                Wait(5)
            end

            Core = exports["qb-core"]:GetCoreObject()
        
            RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
                TriggerEvent('is_lib:Client:OnJobUpdate', {name = job.name})
            end)
        elseif cfg.Framework == "ESX" then
            while not Lib.isExportAvailable("es_extended", "getSharedObject") do
                Wait(5)
            end

            Core = exports["es_extended"]:getSharedObject()

            RegisterNetEvent('esx:setJob', function(job) 
                TriggerEvent('is_lib:Client:OnJobUpdate', {name = job.name})
            end)
        end

        while not Core do
            Wait(5)
        end

        Lib.isPlayerLoaded = function()
            PlayerData = Lib.getPlayerData()

            if cfg.Framework == "QBCore" then
                while not PlayerData.citizenid do
                    PlayerData = Lib.getPlayerData()
                    Wait(5)
                end

                return true
            elseif cfg.Framework == "ESX" then
                while not PlayerData.identifier do
                    PlayerData = Lib.getPlayerData()
                    Wait(5)
                end

                return true
            end
        end

        Lib.getPlayerData = function()
            local PlayerData

            if cfg.Framework == "QBCore" then
                PlayerData = Core.Functions.GetPlayerData()
            elseif cfg.Framework == "ESX" then
                PlayerData = Core.GetPlayerData()
            end

            return PlayerData
        end
    end)
end
