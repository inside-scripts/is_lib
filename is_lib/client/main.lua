Lib = {}
cache = {}
blips = {}

exports('GetLibObject', function()
    local calledBy = GetInvokingResource()

    while cfg.Framework and not Core do
        Wait(5)
    end

    cache[calledBy] = {}
    blips[calledBy] = {}

    return Lib
end)

AddEventHandler("onClientResourceStop", function(resource)
    if cache[resource] then
        local deleteEntity = false

        for entity, _ in pairs(cache[resource]) do
            Lib.deleteEntity(entity, resource)
            deleteEntity = true
        end

        if deleteEntity then
            print(("[%s] has been stopped, removing objects."):format(resource))
        end
    end

    if blips[resource] then
        local deleteBlip = false
        
        for blip, _ in pairs(blips[resource]) do
            Lib.removeBlip(blip, resource)
            deleteBlip = true
        end

        if deleteBlip then
            print(("[%s] has been stopped, removing blips."):format(resource))
        end
    end
end)
