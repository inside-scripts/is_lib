RegisterNetEvent("is_lib:playAnim", function(entity, args, coords)
    TriggerClientEvent("is_lib:playAnim", -1, entity, args, coords)
end)

RegisterNetEvent("is_lib:playSpeech", function(entity, args, coords)
    TriggerClientEvent("is_lib:playSpeech", -1, entity, args, coords)
end)
