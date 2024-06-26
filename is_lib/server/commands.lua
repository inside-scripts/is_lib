if cfg.Framework then
    local function convertArgs(passArgs, arguments)
        if cfg.Framework == "QBCore" then
            local convertedArgs = {}

            for i, v in ipairs(arguments) do
                convertedArgs[v.name] = passArgs[i]
            end

            return convertedArgs
        end

        return passArgs
    end

    local function getArgsCount(passArgs)
        local count = 0

        for _, __ in pairs(passArgs) do
            count = count + 1
        end

        return count
    end

    Lib.registerCommand = function(name, permission, fillArgs, action, data)
        local newAction = function(source, args)
            local convertedArgs

            if args and fillArgs and data.arguments then
                convertedArgs = convertArgs(args, data.arguments)
                local argsCount = getArgsCount(convertedArgs)

                if argsCount < #data.arguments then
                    TriggerClientEvent('chat:addMessage', source, {
                        color = {37, 250, 161},
                        multiline = true,
                        args = {"WARNING", ("You provided too few arguments %s, required %s!"):format(argsCount, #data.arguments)}
                    })

                    return
                end
            elseif args and data.arguments then
                convertedArgs = convertArgs(args, data.arguments)
            end

            action(source, convertedArgs)
        end

        if cfg.Framework == "QBCore" then
            Core.Commands.Add(name, data.help, data.arguments, false, newAction, permission)
        elseif cfg.Framework == "ESX" then
            if data.arguments then
                for _, v in pairs(data.arguments) do
                    v.type = "any" 
                end
            end

            Core.RegisterCommand(name, permission, newAction, false, {help = data.help or nil, arguments = data.arguments or nil})
        end
    end
end
