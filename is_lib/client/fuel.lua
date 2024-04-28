Lib.getFuel = function(veh)
    if cfg.Fuel == "LegacyFuel" or cfg.Fuel == "cdn-fuel" or cfg.Fuel == "ps-fuel" or cfg.Fuel == "okokGasStation" or cfg.Fuel == "lj-fuel" or cfg.Fuel == "hyon_gas_station" or cfg.Fuel == "ND_Fuel" or cfg.Fuel == "myFuel" then
        return exports[cfg.Fuel]:GetFuel(veh)
    elseif cfg.Fuel == "ox_fuel" then
        return Entity(veh).state.fuel
    else
        return GetVehicleFuelLevel(veh)
    end
end

Lib.setFuel = function(veh, fuelLevel)
    if cfg.Fuel == "LegacyFuel" or cfg.Fuel == "cdn-fuel" or cfg.Fuel == "ps-fuel" or cfg.Fuel == "okokGasStation" or cfg.Fuel == "lj-fuel" or cfg.Fuel == "hyon_gas_station" or cfg.Fuel == "ND_Fuel" or cfg.Fuel == "myFuel" then
        exports[cfg.Fuel]:SetFuel(veh, fuelLevel)
    elseif cfg.Fuel == "ox_fuel" then
        Entity(veh).state.fuel = fuelLevel
    else
        SetVehicleFuelLevel(veh, fuelLevel)
    end
end