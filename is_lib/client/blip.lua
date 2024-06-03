Lib.createBlipCoords = function(coords, args)
    local calledBy = GetInvokingResource()

    local sprite = args.sprite or 1
    local display = args.display or 2
    local scale = args.scale or 0.6
    local color = args.color or 1
    local alpha = args.alpha or 255
    local shortRange = args.shortRange or false
    local name = args.name or "Example Blip"

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, display)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, alpha)
    SetBlipAsShortRange(blip, shortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)

    if calledBy and blips[calledBy] then
        blips[calledBy][blip] = true
    end

    return blip
end

Lib.createBlipRadius = function(coords, args)
    local calledBy = GetInvokingResource()

    local radius = args.radius or 50.0
    local color = args.color or 1
    local alpha = args.alpha or 255
    local shortRange = args.shortRange or false

    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, radius)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, alpha)
    SetBlipAsShortRange(blip, shortRange)

    if calledBy and blips[calledBy] then
        blips[calledBy][blip] = true
    end

    return blip
end

Lib.removeBlip = function(blip, resource)
    local calledBy = resource or GetInvokingResource()

    if blips[calledBy] and blips[calledBy][blip] then
        RemoveBlip(blip)
        blips[calledBy][blip] = nil
    end
end
