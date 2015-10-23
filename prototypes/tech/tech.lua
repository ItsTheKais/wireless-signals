data:extend(
{
    {
        type = "technology",
        name = "ws-telemetry",
        icon = "__wireless-signals__/resources/icons/telemetry.png",
        effects = 
        {
            {
                type = "unlock-recipe",
                recipe = "ws-radio-transmitter-1"
            },
            {
                type = "unlock-recipe",
                recipe = "ws-radio-reciever"
            },
        },
        prerequisites = {"circuit-network", "advanced-electronics-2"},
        unit =
        {
            count = 50,
            ingredients = 
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
                {"science-pack-3", 1},
            },
            time = 30
        },
        order = "a-d-e",
    },
    {
        type = "technology",
        name = "ws-telemetry-2",
        icon = "__wireless-signals__/resources/icons/telemetry.png",
        effects = 
        {
            {
                type = "unlock-recipe",
                recipe = "ws-radio-transmitter-2"
            },
        },
        prerequisites = {"ws-telemetry", "effectivity-module-2"},
        unit =
        {
            count = 100,
            ingredients = 
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
                {"science-pack-3", 1},
                {"alien-science-pack", 1},
            },
            time = 45
        },
        order = "a-d-e",
    },
}
)