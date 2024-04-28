Lib.getDate = function(time, args)
    local current = {}
    local add_time = 0

    if args and args.unit and args.count then
        if args.unit == "minutes" then
            add_time = 60 * args.count
        elseif args.unit == "hours" then
            add_time = 3600 * args.count
        elseif args.unit == "days" then
            add_time = 86400 * args.count
        elseif args.unit == "weeks" then
            add_time = 604800 * args.count
        end
    end

    if cfg.Time["Zone_Count"] >= 0 then
        current.time = time + (cfg.Time["Zone_Count"] * 3600) + add_time
    elseif cfg.Time["Zone_Count"] < 0 then
        current.time = time - math.abs((cfg.Time["Zone_Count"] * 3600)) + add_time
    end

    if cfg.Time["Format"] == 24 then
        current.date = os.date("%d/%m/%Y %H:%M", current.time)
    elseif cfg.Time["Format"] == 12 then
        current.date = os.date("%m/%d/%Y %I:%M %p", current.time)
    end

    return current
end