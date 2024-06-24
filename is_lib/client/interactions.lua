local function checkDefaultOptions(options) -- Checks default options and sets them if they do not exist
    for _,v in ipairs(options) do
        v.name = v.name or Lib.getRandomString(5)
        v.icon = v.icon or "fa-solid fa-user"
        v.label = v.label or "Example Label"
        v.onSelect = v.onSelect or function() print("Example Function") end
    end

    return options
end

local function findInteractionCache(type, obj, calledBy) -- Finds an interaction cache that contains this entity
    local interactionIndex, interactionCache

    for i,v in ipairs(interactions[calledBy]) do
        if v.type == type and v.entity == obj then
            interactionIndex = i
            interactionCache = v  
            break  
        elseif v.type == type and v.name == obj then
            interactionIndex = i
            interactionCache = v  
            break 
        end
    end

    return interactionIndex, interactionCache
end

local function addInteractionCache(type, obj, options, args, calledBy) -- Adds non-existent options to the cache or creates a new one interaction cache
    local interactionIndex, interactionCache = findInteractionCache(type, obj, calledBy)

    if interactionCache then
        -- Create a set to track existing option names
        local existingOptions = {}
        for _, cacheOption in ipairs(interactionCache.options) do
            existingOptions[cacheOption.name] = true
        end
        
        -- Add only non-existent options
        for _, argsOption in ipairs(options) do
            if not existingOptions[argsOption.name] then
                table.insert(interactions[calledBy][interactionIndex].options, argsOption)
                existingOptions[argsOption.name] = true
            end
        end
    else
        if type == "entity" then
            table.insert(interactions[calledBy], {
                type = type,
                entity = obj,
                options = options
            })
        elseif type == "coords" then
            table.insert(interactions[calledBy], {
                type = type,
                name = obj,
                args = args,
                options = options
            })
        end
    end
end

local function removeOptionFromCache(interactionIndex, interactionCache, optionName, calledBy) -- Removes an option from the cache - if the last one, it removes the entire interaction cache
    for i,v in ipairs(interactionCache.options) do
        if v.name == optionName then
            if interactions[calledBy][interactionIndex].options == 1 then
                interactions[calledBy][interactionIndex] = nil
            else
                table.remove(interactions[calledBy][interactionIndex].options, i)
            end
            break
        end
    end
end

Lib.addInteractionEntity = function(entity, args)
    local calledBy = GetInvokingResource()

    args.options = checkDefaultOptions(args.options)
    args.distance = args.distance or 2.5
    args.squareDistance = args.squareDistance or 3.0

    if cfg.Interaction == "qb-target" and Lib.isExportAvailable(cfg.Interaction, "AddTargetEntity") then
        local _, interactionCache = findInteractionCache("entity", entity, calledBy)
        local num = interactionCache and #interactionCache.options or 0 

        for i,v in ipairs(args.options) do
            v.num = num + i
            v.action = v.onSelect
            v.onSelect = nil
        end

        addInteractionCache("entity", entity, args.options, nil, calledBy)

        exports[cfg.Interaction]:AddTargetEntity(entity, {
            options = args.options,
            distance = args.distance
        })
    elseif cfg.Interaction == "ox_target" and Lib.isExportAvailable(cfg.Interaction, "addLocalEntity") then
        for _,v in ipairs(args.options) do
            v.distance = args.distance
        end

        addInteractionCache("entity", entity, args.options, nil, calledBy)

        exports[cfg.Interaction]:addLocalEntity(entity, args.options)
    elseif cfg.Interaction == "is_interaction" and Lib.isExportAvailable(cfg.Interaction, "addInteractionLocalEntity") then
        addInteractionCache("entity", entity, args.options, nil, calledBy)

        exports[cfg.Interaction]:addInteractionLocalEntity("is_lib:"..entity, entity, {
            hideSquare = args.hideSquare or false,
            checkVisibility = args.checkVisibility or true,
            showInVehicle = args.showInVehicle or false,
            distance = args.squareDistance,
            distanceText = args.distance,
            offset = args.offset or {
                text = {x = 0.0, y = 0.0, z = 1.0},
                target = {x = 0.0, y = 0.0, z = 0.0}
            },
            options = args.options
        })
    end
end

Lib.addInteractionCoords = function(name, coords, args)
    local calledBy = GetInvokingResource()

    args.options = checkDefaultOptions(args.options)
    args.distance = args.distance or 2.5
    args.squareDistance = args.squareDistance or 3.0
    args.boxLength = args.boxLength or 1.5
    args.boxWidth = args.boxWidth or 1.5
    args.boxHeight = args.boxHeight or 3.0
    args.boxHeading = args.boxHeading or 0.0
    args.debugPoly = args.debugPoly or false

    if cfg.Interaction == "qb-target" and Lib.isExportAvailable(cfg.Interaction, "AddBoxZone") and Lib.isExportAvailable(cfg.Interaction, "RemoveZone") then
        local _, interactionCache = findInteractionCache("coords", name, calledBy)
        local num = interactionCache and #interactionCache.options or 0 

        for i,v in ipairs(args.options) do
            v.num = num + i
            v.action = v.onSelect
            v.onSelect = nil
        end

        addInteractionCache("coords", name, args.options, {
            coords = coords, 
            distance = args.distance,
            boxLength = args.boxLength,
            boxWidth = args.boxWidth,
            heading = args.boxHeading,
            debugPoly = args.debugPoly,
            minZ = coords.z - (args.boxHeight / 2),
            maxZ = coords.z + (args.boxHeight / 2)
        }, calledBy)

        if interactionCache then
            exports[cfg.Interaction]:RemoveZone(name)
        end

        exports[cfg.Interaction]:AddBoxZone(name, coords, args.boxLength, args.boxWidth, {
            name = "is_lib:"..name,
            heading = args.boxHeading,
            debugPoly = args.debugPoly,
            minZ = coords.z - (args.boxHeight / 2),
            maxZ = coords.z + (args.boxHeight / 2)
        }, {
            options = interactionCache and interactionCache.options or args.options,
            distance = args.distance
        })
    elseif cfg.Interaction == "ox_target" and Lib.isExportAvailable(cfg.Interaction, "addBoxZone") and Lib.isExportAvailable(cfg.Interaction, "removeZone") then
        for _,v in ipairs(args.options) do
            v.distance = args.distance
        end

        local _, interactionCache = findInteractionCache("coords", name, calledBy)
        if interactionCache then
            exports[cfg.Interaction]:removeZone(interactionCache.id)
        end

        addInteractionCache("coords", name, args.options, {
            coords = coords, 
            distance = args.distance,
            boxLength = args.boxLength,
            boxWidth = args.boxWidth,
            heading = args.boxHeading,
            debugPoly = args.debugPoly,
            boxHeight = args.boxHeight
        }, calledBy)

        _, interactionCache = findInteractionCache("coords", name, calledBy)
        interactionCache.id = exports[cfg.Interaction]:addBoxZone({
            coords = vector3(coords.x, coords.y, coords.z),
            size = vector3(args.boxLength, args.boxWidth, args.boxHeight),
            rotation = args.boxHeading,
            debug = args.debugPoly,
            options = interactionCache and interactionCache.options or args.options,
        })
    elseif cfg.Interaction == "is_interaction" and Lib.isExportAvailable(cfg.Interaction, "addInteractionCoords") then   
        addInteractionCache("coords", name, args.options, {
            coords = coords, 
            hideSquare = args.hideSquare,
            checkVisibility = args.checkVisibility,
            showInVehicle = args.showInVehicle,
            distance = args.squareDistance,
            distanceText = args.distance,
            offset = args.offset or {
                text = {x = 0.0, y = 0.0, z = 1.0},
                target = {x = 0.0, y = 0.0, z = 0.0}
            },
        }, calledBy)

        exports[cfg.Interaction]:addInteractionCoords(name, coords, {
            hideSquare = args.hideSquare,
            checkVisibility = args.checkVisibility,
            showInVehicle = args.showInVehicle,
            distance = args.squareDistance,
            distanceText = args.distance,
            offset = args.offset or {
                text = {x = 0.0, y = 0.0, z = 1.0},
                target = {x = 0.0, y = 0.0, z = 0.0}
            },
            options = args.options
        })
    end
end

Lib.removeInteractionEntity = function(entity, optionName, calledBy)
    calledBy = calledBy or GetInvokingResource()
    local interactionIndex, interactionCache = findInteractionCache("entity", entity, calledBy)

    if interactionIndex then
        if cfg.Interaction == "qb-target" and Lib.isExportAvailable(cfg.Interaction, "RemoveTargetEntity") then
            if optionName then
                local optionLabel
                for i,v in ipairs(interactionCache.options) do -- Removes an option from the cache - if the last one, it removes the entire option and return label for qbtarget to delete
                    if v.name == optionName then
                        optionLabel = v.label
                        if interactions[calledBy][interactionIndex].options == 1 then
                            interactions[calledBy][interactionIndex] = nil
                        else
                            table.remove(interactions[calledBy][interactionIndex].options, i)
                        end
                        break
                    end
                end

                exports[cfg.Interaction]:RemoveTargetEntity(entity, optionLabel)
            else
                exports[cfg.Interaction]:RemoveTargetEntity(entity)
                interactions[calledBy][interactionIndex] = nil
            end
        elseif cfg.Interaction == "ox_target" and Lib.isExportAvailable(cfg.Interaction, "removeLocalEntity") then
            if optionName then
                removeOptionFromCache(interactionIndex, interactionCache, optionName, calledBy)
                exports[cfg.Interaction]:removeLocalEntity(entity, optionName)
            else
                exports[cfg.Interaction]:removeLocalEntity(entity)
                interactions[calledBy][interactionIndex] = nil
            end
        elseif cfg.Interaction == "is_interaction" and Lib.isExportAvailable(cfg.Interaction, "addInteractionLocalEntity") then
            if optionName then
                removeOptionFromCache(interactionIndex, interactionCache, optionName, calledBy)
                exports["is_interaction"]:removeLocalEntity(entity, "is_lib:"..entity, optionName)
            else
                exports["is_interaction"]:removeLocalEntity(entity, "is_lib:"..entity)
                interactions[calledBy][interactionIndex] = nil
            end
        end
    end
end

Lib.removeInteractionCoords = function(name, optionName, calledBy)
    calledBy = calledBy or GetInvokingResource()
    local interactionIndex, interactionCache = findInteractionCache("coords", name, calledBy)

    if interactionIndex then
        if cfg.Interaction == "qb-target" and Lib.isExportAvailable(cfg.Interaction, "AddBoxZone") and Lib.isExportAvailable(cfg.Interaction, "RemoveZone") then
            if optionName then
                if #interactionCache.options == 1 then
                    exports[cfg.Interaction]:RemoveZone(name)
                    interactions[calledBy][interactionIndex] = nil 
                else
                    exports[cfg.Interaction]:RemoveZone(name)

                    removeOptionFromCache(interactionIndex, interactionCache, optionName, calledBy)

                    local args = interactionCache.args
                    exports[cfg.Interaction]:AddBoxZone(name, args.coords, args.boxLength, args.boxWidth, {
                        name = "is_lib:"..name,
                        heading = args.boxHeading,
                        debugPoly = args.debugPoly,
                        minZ = args.minZ,
                        maxZ = args.maxZ
                    }, {
                        options = interactionCache.options,
                        distance = args.distance
                    })
                end
            else
                exports[cfg.Interaction]:RemoveZone(name)
                interactions[calledBy][interactionIndex] = nil 
            end
        elseif cfg.Interaction == "ox_target" and Lib.isExportAvailable(cfg.Interaction, "addBoxZone") and Lib.isExportAvailable(cfg.Interaction, "removeZone") then
            if optionName then
                if #interactionCache.options == 1 then
                    exports[cfg.Interaction]:removeZone(interactionCache.id)
                    interactions[calledBy][interactionIndex] = nil 
                else
                    exports[cfg.Interaction]:removeZone(interactionCache.id)

                    removeOptionFromCache(interactionIndex, interactionCache, optionName, calledBy)

                    local args = interactionCache.args
                    interactionCache.id = exports[cfg.Interaction]:addBoxZone({
                        coords = args.coords,
                        size = vector3(args.boxLength, args.boxWidth, args.boxHeight),
                        rotation = args.boxHeading,
                        debug = args.debugPoly,
                        options = interactionCache.options,
                    })
                end
            else
                exports[cfg.Interaction]:removeZone(interactionCache.id)
                interactions[calledBy][interactionIndex] = nil 
            end
        elseif cfg.Interaction == "is_interaction" and Lib.isExportAvailable(cfg.Interaction, "removeCoords") then   
            local args = interactionCache.args
            if optionName then
                if #interactionCache.options == 1 then
                    exports[cfg.Interaction]:removeCoords(args.coords, name)
                    interactions[calledBy][interactionIndex] = nil 
                else
                    exports[cfg.Interaction]:removeCoords(args.coords, name, optionName)
                    removeOptionFromCache(interactionIndex, interactionCache, optionName, calledBy)
                end
            else
                exports[cfg.Interaction]:removeCoords(args.coords, name)
                interactions[calledBy][interactionIndex] = nil 
            end
        end
    end
end
