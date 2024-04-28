Lib.addKeys = function(veh)
    local plate = GetVehicleNumberPlateText(veh)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))

    if cfg.VehicleKeys == "qb-vehiclekeys" then
        TriggerEvent("qb-vehiclekeys:client:AddKeys", plate)
    elseif cfg.VehicleKeys == "qs-vehiclekeys" then
        exports['qs-vehiclekeys']:GiveKeys(plate, model, false)
    elseif cfg.VehicleKeys == "vehicles_keys" then
        TriggerServerEvent("vehicles_keys:selfGiveVehicleKeys", plate)
    elseif cfg.VehicleKeys == "mk_vehiclekeys" then
        exports["mk_vehiclekeys"]:AddKey(veh)
    elseif cfg.VehicleKeys == "wasabi_carlock" then
        exports["wasabi_carlock"]:GiveKey(plate)
    elseif cfg.VehicleKeys == "cd_garage" then
        TriggerEvent('cd_garage:AddKeys', plate)
    elseif cfg.VehicleKeys == "okokGarage" then
        TriggerServerEvent("okokGarage:GiveKeys", plate)
    end
end

Lib.removeKeys = function(veh)
    local plate = GetVehicleNumberPlateText(veh)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))

    if cfg.VehicleKeys == "qb-vehiclekeys" then
        TriggerEvent("qb-vehiclekeys:client:RemoveKeys", plate)
    elseif cfg.VehicleKeys == "qs-vehiclekeys" then
        exports['qs-vehiclekeys']:RemoveKeys(plate, model)
    elseif cfg.VehicleKeys == "vehicles_keys" then
        TriggerServerEvent("vehicles_keys:selfRemoveKeys", plate)
    elseif cfg.VehicleKeys == "mk_vehiclekeys" then
        exports["mk_vehiclekeys"]:RemoveKey(veh)
    elseif cfg.VehicleKeys == "wasabi_carlock" then
        exports["wasabi_carlock"]:RemoveKey(plate)
    elseif cfg.VehicleKeys == "cd_garage" then
        TriggerEvent('cd_garage:RemoveKeys', plate)
    elseif cfg.VehicleKeys == "okokGarage" then
        TriggerServerEvent("okokGarage:RemoveKeys", plate)
    end
end