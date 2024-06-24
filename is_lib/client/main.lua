Lib = {}
cache = {}
blips = {}
interactions = {}

exports('GetLibObject', function()
    local calledBy = GetInvokingResource()

    while cfg.Framework and not Core do
        Wait(5)
    end

    cache[calledBy] = {}
    blips[calledBy] = {}
    interactions[calledBy] = interactions[calledBy] or {}

    return Lib
end)

AddEventHandler("onClientResourceStop", function(resource)
    if not resource then return end

    local resource = tostring(resource)

    if interactions[resource] then
        local deletedInteractions = false

        for _,v in pairs(interactions[resource]) do
            if v.type == "entity" then
                Lib.removeInteractionEntity(v.entity, nil, resource)
                deletedInteractions = true
            elseif v.type == "coords" then
                Lib.removeInteractionCoords(v.name, nil, resource)
            end
        end

        if deletedInteractions then
            print(("[%s] has been stopped, removing interactions."):format(resource))
        end
    end

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
