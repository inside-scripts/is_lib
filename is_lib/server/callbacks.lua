local serverCallbacks = {}
local clientRequests = {}
local RequestId = 0

Lib.RegisterServerCallback = function(eventName, callback)
    serverCallbacks[eventName] = callback
end

RegisterNetEvent('is_lib:triggerServerCallback', function(eventName, requestId, invoker, ...)
    if not serverCallbacks[eventName] then
        return print(('[^1ERROR^7] Server Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7'):format(eventName, invoker))
    end

    local src = source

    serverCallbacks[eventName](src, function(...)
        TriggerClientEvent('is_lib:serverCallback', src, requestId, invoker, ...)
    end, ...)
end)