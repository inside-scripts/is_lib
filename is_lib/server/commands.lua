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
            local normalizedArgs = convertArgs(args, data.arguments)

            if fillArgs then
                local passedArgs = getArgsCount(normalizedArgs)

                if passedArgs < #data.arguments then
                    TriggerClientEvent('chat:addMessage', source, {
                        color = {37, 250, 161},
                        multiline = true,
                        args = {"WARNING", ("You provided too few arguments %s, required %s!"):format(passedArgs, #data.arguments)}
                    })
                    return
                end
            end

            action(source, normalizedArgs)
        end

        if cfg.Framework == "QBCore" then
            Core.Commands.Add(name, data.help, data.arguments, false, newAction, permission)
        elseif cfg.Framework == "ESX" then
            for _, v in ipairs(data.arguments) do
                v.type = "any" 
            end
            Core.RegisterCommand(name, permission, newAction, false, {help = data.help, arguments = data.arguments})
        end
    end
end
