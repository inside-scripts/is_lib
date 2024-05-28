Lib.createBlipCoords = function(coords, args)
    local display = args.display or 2
    local scale = args.scale or 0.6
    local color = args.color or {r = 37, g = 250, b = 161}
    local alpha = args.alpha or 255
    local shortRange = args.shortRange or false
    local name = args.name or "Example Blip"

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, args.sprite)
    SetBlipDisplay(blip, display)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, 1)
    SetBlipSecondaryColour(blip, color.r, color.g, color.b)
    SetBlipAlpha(blip, alpha)
    SetBlipAsShortRange(blip, shortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)

    return blip
end

Lib.createBlipRadius = function(coords, args)
    local color = args.color or {r = 37, g = 250, b = 161}
    local alpha = args.alpha or 255
    local shortRange = args.shortRange or false

    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, args.radius)
    SetBlipColour(blip, 1)
    SetBlipSecondaryColour(blip, color.r, color.g, color.b)
    SetBlipAlpha(blip, alpha)
    SetBlipAsShortRange(blip, shortRange)

    return blip
end
