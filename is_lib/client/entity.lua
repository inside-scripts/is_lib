Lib.playAnim = function(entity, args)
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

Lib.playScenario(entity, args)
    local enterAnim = args.enterAnim or true

    TaskStartScenarioInPlace(entity, args.scenario, 0, enterAnim)
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
        return {id = obj}
    else
        return {id = obj, netId = NetworkGetNetworkIdFromEntity(obj)}
    end
end

Lib.createPed = function(hash, coords, isNetwork, options)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
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
    end

    if not isNetwork then
        return {id = ped}
    else
        return {id = ped, netId = NetworkGetNetworkIdFromEntity(ped)}
    end
end

Lib.createVeh = function(hash, coords, isNetwork, options)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
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
            SetVehicleModColor_1(veh, paintType[options.primaryColor.type])
        end

        if options.secondaryColor and options.secondaryColor.r and options.secondaryColor.g and options.secondaryColor.b then
            SetVehicleCustomSecondaryColour(veh, options.secondaryColor.r, options.secondaryColor.g, options.secondaryColor.b)
            SetVehicleModColor_2(veh, paintType[options.secondaryColor.type])
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
        return {id = veh}
    else
        local netId = NetworkGetNetworkIdFromEntity(veh)
        SetNetworkIdCanMigrate(netId, true)

        return {id = veh, netId = netId}
    end
end
