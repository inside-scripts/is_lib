Lib.playAnim = function(entity, args)
    local isNetwork = args.isNetwork or false

    if isNetwork then
        if NetworkDoesNetworkIdExist(entity) and NetworkDoesEntityExistWithNetworkId(entity) then
            local localEntity = NetworkGetEntityFromNetworkId(entity)
            local coords

            if localEntity ~= 0 then
                coords = GetEntityCoords(localEntity)
            end

            TriggerServerEvent("is_lib:playAnim", entity, args, coords)
        end

        return
    end

    local duration = args.duration or -1
    local flag = args.flag or 49
    local blendIn = args.blendIn or 3.0
    local blendOut = args.blendOut or 3.0
    local playbackRate = args.playbackRate or 0
    local lockX = args.lockX or false
    local lockY = args.lockY or false
    local lockZ = args.lockZ or false

    RequestAnimDict(args.dict)
    while not HasAnimDictLoaded(args.dict) do
        Wait(5)
    end
    TaskPlayAnim(entity, args.dict, args.anim, blendIn, blendOut, duration, flag, playbackRate, lockX, lockY, lockZ)
end

RegisterNetEvent("is_lib:playAnim", function(entity, args, coords)
    local player_coords = GetEntityCoords(PlayerPedId())

    if coords and #(player_coords - coords) < 100.0 or not coords then
        if NetworkDoesNetworkIdExist(entity) and NetworkDoesEntityExistWithNetworkId(entity) then
            local localEntity = NetworkGetEntityFromNetworkId(entity)

            if localEntity ~= 0 then
                args.isNetwork = false
                Lib.playAnim(localEntity, args)
            end
        end
    end
end)

Lib.playScenario = function(entity, args)
    local enterAnim = args.enterAnim or true

    TaskStartScenarioInPlace(entity, args.scenario, 0, enterAnim)
end

Lib.playSpeech = function(entity, args)
    local isNetwork = args.isNetwork or false

    if isNetwork then
        if NetworkDoesNetworkIdExist(entity) and NetworkDoesEntityExistWithNetworkId(entity) then
            local localEntity = NetworkGetEntityFromNetworkId(entity)
            local coords

            if localEntity ~= 0 then
                coords = GetEntityCoords(localEntity)
            end

            TriggerServerEvent("is_lib:playSpeech", entity, args, coords)
        end

        return
    end

    PlayPedAmbientSpeechNative(entity, args.name, args.param)
end

RegisterNetEvent("is_lib:playSpeech", function(entity, args, coords)
    local player_coords = GetEntityCoords(PlayerPedId())

    if coords and #(player_coords - coords) < 100.0 or not coords then
        if NetworkDoesNetworkIdExist(entity) and NetworkDoesEntityExistWithNetworkId(entity) then
            local localEntity = NetworkGetEntityFromNetworkId(entity)

            if localEntity ~= 0 then
                args.isNetwork = false
                Lib.playSpeech(localEntity, args)
            end
        end
    end
end)

Lib.FaceToCoordsSmooth = function(ped, targetHeading)
    local function normalizeHeadingDifference(heading1, heading2)
        local diff = (heading2 - heading1 + 180) % 360 - 180
        return diff < -180 and diff + 360 or diff
    end

    local currentHeading = GetEntityHeading(ped)
    local headingDifference = normalizeHeadingDifference(currentHeading, targetHeading)

    while math.abs(headingDifference) > 5.0 do
        SetPedDesiredHeading(ped, targetHeading)
        Wait(100)

        currentHeading = GetEntityHeading(ped)
        headingDifference = normalizeHeadingDifference(currentHeading, targetHeading)
    end
end

Lib.FaceToCoords = function(entity, handler)
    local entity = GetEntityCoords(entity)

    if type(handler) ~= "vector3" then
        handler = GetEntityCoords(handler)
    end

    local dx = handler.x - entity.x
    local dy = handler.y - entity.y

    local heading = GetHeadingFromVector_2d(dx, dy)

    return heading
end

Lib.createObj = function(hash, coords, isNetwork, options)
    local calledBy = GetInvokingResource()

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(5)
        end
    end

    local obj = CreateObject(hash, coords.x, coords.y, coords.z, isNetwork, true, false)

    while not DoesEntityExist(obj) do
        Wait(5)
    end

    SetModelAsNoLongerNeeded(hash)

    if options then
        if options.rotation and options.rotation.p and options.rotation.r and options.rotation.y then
            SetEntityRotation(obj, options.rotation.p, options.rotation.r, options.rotation.y)
        end

        if options.placeOnGround then
            PlaceObjectOnGroundProperly(obj)
        end

        if options.freeze then
            FreezeEntityPosition(obj, true)
        end

        if options.invincible then
            SetEntityInvincible(obj, true)
        end

        if options.disableCollision then
            SetEntityCollision(obj, false, true)
        end

        if options.alpha and tonumber(options.alpha) then
            SetEntityAlpha(obj, options.alpha, false)
        end
    end

    if not isNetwork then
        if calledBy and cache[calledBy] then
            cache[calledBy][obj] = true
        end

        return {id = obj}
    else
        local netId = NetworkGetNetworkIdFromEntity(obj)
        SetNetworkIdCanMigrate(netId, true)

        if calledBy and cache[calledBy] then
            cache[calledBy][obj] = netId
        end

        return {id = obj, netId = netId}
    end
end

Lib.createPed = function(hash, coords, isNetwork, options)
    local calledBy = GetInvokingResource()
    
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(5)
        end
    end

    local ped = CreatePed(0, hash, coords.x, coords.y, coords.z, coords.w, isNetwork, true)

    while not DoesEntityExist(ped) do
        Wait(5)
    end

    SetModelAsNoLongerNeeded(hash)

    if options then
        if options.placeOnGround then
            local found, ground = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)

            if found then
                SetEntityCoords(ped, coords.x, coords.y, ground)
            end
        end

        if options.defaultVariation then
            SetPedDefaultComponentVariation(ped)
        end

        if options.freeze then
            FreezeEntityPosition(ped, true)
        end

        if options.god then
            SetEntityInvincible(ped, true)
            SetPedDiesWhenInjured(ped, false)
        end

        if options.disableRagdoll then
            SetPedCanRagdollFromPlayerImpact(ped, false)
            SetPedCanRagdoll(ped, false)
        end

        if options.cannotTarget then
            SetPedCanBeTargetted(ped, false)
        end
    end

    if not isNetwork then
        if calledBy and cache[calledBy] then
            cache[calledBy][ped] = true
        end

        return {id = ped}
    else
        local netId = NetworkGetNetworkIdFromEntity(ped)
        SetNetworkIdCanMigrate(netId, true)

        if calledBy and cache[calledBy] then
            cache[calledBy][ped] = netId
        end

        return {id = ped, netId = netId}
    end
end

Lib.createVeh = function(hash, coords, isNetwork, options)
    local calledBy = GetInvokingResource()

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(5)
        end
    end

    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w, isNetwork, true)

    while not DoesEntityExist(veh) do
        Wait(5)
    end

    SetModelAsNoLongerNeeded(hash)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, "OFF")
    Lib.setFuel(veh, 100)

    if options then
        if options.addKeys then
            Lib.addKeys(veh)
        end

        if options.freeze then
            FreezeEntityPosition(veh, true)
        end

        local paintType = {
            ["normal"] = 0,
            ["metallic"] = 1,
            ["pearl"] = 2,
            ["matte"] = 3,
            ["metal"] = 4,
            ["chrome"] = 5
        }

        if options.livery and tonumber(options.livery) then
            local availableLiveries = GetVehicleLiveryCount(veh)

            if options.livery <= availableLiveries then
                SetVehicleLivery(veh, options.livery)
            end
        elseif not options.livery then
            SetVehicleLivery(veh, 0)
        end

        if options.primaryColor and options.primaryColor.r and options.primaryColor.g and options.primaryColor.b then
            SetVehicleCustomPrimaryColour(veh, options.primaryColor.r, options.primaryColor.g, options.primaryColor.b)

            local paint = paintType[options.secondaryColor.type] or paintType["normal"]

            SetVehicleModColor_1(veh, paint)
        end

        if options.secondaryColor and options.secondaryColor.r and options.secondaryColor.g and options.secondaryColor.b then
            SetVehicleCustomSecondaryColour(veh, options.secondaryColor.r, options.secondaryColor.g, options.secondaryColor.b)

            local paint = paintType[options.secondaryColor.type] or paintType["normal"]

            SetVehicleModColor_2(veh, paint)
        end

        if options.dirtLevel and tonumber(options.dirtLevel) then
            SetVehicleDirtLevel(veh, options.dirtLevel)
        end

        local modsType = {
            ["engine"] = 11,
            ["brakes"] = 12,
            ["gearbox"] = 13,
            ["suspension"] = 15,
            ["armour"] = 16,
            ["turbo"] = 18
        }

        if options.mechanicalMods then
            SetVehicleModKit(veh, 0)

            for k, v in pairs(options.mechanicalMods) do
                local modPart = modsType[k]

                if k ~= "turbo" then
                    local availableMods = GetNumVehicleMods(veh, modPart)

                    if type(v) == "number" then
                        if v <= availableMods then
                            SetVehicleMod(veh, modPart, v)
                        end
                    elseif type(v) == "boolean" and v == true then
                        if availableMods > 0 then availableMods = availableMods - 1 end
                        SetVehicleMod(veh, modPart, availableMods)
                    end
                else
                    if type(v) == "boolean" and v == true then
                        ToggleVehicleMod(veh, modPart)
                    end
                end
            end
        end
    end

    if not isNetwork then
        if calledBy and cache[calledBy] then
            cache[calledBy][veh] = true
        end

        return {id = veh}
    else
        local netId = NetworkGetNetworkIdFromEntity(veh)
        SetNetworkIdCanMigrate(netId, true)

        if calledBy and cache[calledBy] then
            cache[calledBy][veh] = netId
        end

        return {id = veh, netId = netId}
    end
end

Lib.deleteEntity = function(entity, resource)
    local calledBy = resource or GetInvokingResource()

    if cache[calledBy] and cache[calledBy][entity] then
        DeleteEntity(entity)
        cache[calledBy][entity] = nil
    end
end
