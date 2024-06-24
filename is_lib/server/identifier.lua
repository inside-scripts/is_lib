Lib.getIdentifiers = function(source)
    local getIdentifiers = GetPlayerIdentifiers(source)
    local identifiers = {}

    for _, id in ipairs(getIdentifiers) do
        if string.find(id, "steam:") then
            identifiers.steam = id:gsub("steam:", "")
        elseif string.find(id, "discord:") then
            identifiers.discord = id:gsub("discord:", "")
        elseif string.find(id, "license:") then
            identifiers.license = id:gsub("license:", "")
        elseif string.find(id, "xbl:") then
            identifiers.xbl = id:gsub("xbl:", "")
        elseif string.find(id, "live:") then
            identifiers.live = id:gsub("live:", "")
        elseif string.find(id, "fivem:") then
            identifiers.fivem = id:gsub("fivem:", "")
        end
    end

    return identifiers
end
