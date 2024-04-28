Lib.sendWebhook = function(url, args)
    local decimalColor, timestamp, content

    if args.color then
        local color = args.color:gsub("#", "")
        decimalColor = tonumber(color, 16)
    end
    
    if args.timestamp then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
    end

    if args.content then
        content = args.content
    end

    local embeds = {
        {
            color = decimalColor,
            title = args.title or nil,
            url = args.url or nil,
            author = args.author or nil,
            description = args.description or nil,
            thumbnail = args.thumbnail or nil,
            fields = args.fields or nil,
            image = args.image or nil,
            timestamp = timestamp,
            footer = args.footer or nil,
        }
    }

    local data = {
        username = args.username,
        embeds = embeds,
        content = content
    }

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end