if cfg.Framework then
    CreateThread(function()
        if cfg.Framework == "QBCore" then
            while GetResourceState("qb-core") ~= "started" do
                Wait(5)
            end

            Wait(1000)

            Core = exports["qb-core"]:GetCoreObject()
        
            RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
                TriggerEvent('is_lib:Client:OnJobUpdate', {name = job.name})
            end)
        elseif cfg.Framework == "ESX" then
            while GetResourceState("es_extended") ~= "started" do
                Wait(5)
            end

            Wait(1000)

            Core = exports["es_extended"]:getSharedObject()

            RegisterNetEvent('esx:setJob', function(job) 
                TriggerEvent('is_lib:Client:OnJobUpdate', {name = job.name})
            end)
        end

        while not Core do
            Wait(5)
        end

        Lib.getPlayerData = function()
            local PlayerData

            if cfg.Framework == "QBCore" then
                PlayerData = Core.Functions.GetPlayerData()
            elseif cfg.Framework == "ESX" then
                PlayerData = Core.GetPlayerData()
            end

            while not PlayerData do
                Wait(5)
            end

            return PlayerData
        end
    end)
end
