Lib.createBlipCoords = function(coords, args)
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

    return blip
end

Lib.createBlipRadius = function(coords, args)
    local color = args.color or 1
    local alpha = args.alpha or 255
    local shortRange = args.shortRange or false

    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, args.radius)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, alpha)
    SetBlipAsShortRange(blip, shortRange)

    return blip
end
