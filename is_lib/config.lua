cfg = {}

cfg.Time                 = {                  -- The time is retrieved directly from the Server, not the local Client's Computer, ensuring uniform time for all system users, regardless of their local time settings
    ["Zone_Count"] = 2,                       -- 2, -2
    ["Format"] = 12                           -- 12, 24
}

cfg.Framework            = "QBCore"           -- "QBCore" or "ESX"
cfg.Inventory            = "qb-inventory"     -- "qb-inventory", "ox_inventory", "qs-inventory", "ps-inventory", "lj-inventory", "origen_inventory", "codem-inventory", "ESX"
cfg.Fuel                 = "LegacyFuel"       -- "LegacyFuel", "cdn-fuel", "ps-fuel", "okokGasStation", "ox_fuel", "lj-fuel", "hyon_gas_station", "ND_Fuel", "myFuel"
cfg.VehicleKeys          = "qb-vehiclekeys"   -- "qb-vehiclekeys", "qs-vehiclekeys", "vehicles_keys", "mk_vehiclekeys", "wasabi_carlock", "cd_garage", "okokGarage"