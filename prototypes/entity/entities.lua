data:extend(
{
    {
        type = "lamp",
        name = "ws-radio-transmitter-1",
        icon = "__wireless-signals__/resources/icons/radio-transmitter-1.png",
        icon_size = 32,
        flags = {"placeable-player", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.75, result = "ws-radio-transmitter-1"},
        max_health = 125,
        corpse = "medium-remnants",
        collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
        selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
        vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
        fast_replaceable_group = "ws-radio-equipment",
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "175kJ"
        },
        energy_usage_per_tick = "300kW",
        light =
        {
            intensity = 0.0,
            size = 0
        },
        picture_off =
        {
            filename = "__wireless-signals__/resources/entity/radio-transmitter-1.png",
            priority = "high",
            width = 235,
            height = 207,
            frame_count = 1,
            axially_symmetrical = false,
            direction_count = 1,
            shift = {2.69, -1.91},
        },
        picture_on =
        {
            filename = "__wireless-signals__/resources/blank.png",
            priority = "high",
            width = 1,
            height = 1,
            frame_count = 1,
            axially_symmetrical = false,
            direction_count = 1,
            shift = {0.0, 0.0},
        },
        circuit_wire_connection_point =
        {
            shadow =
            {
                red = {1.09, -0.19},
                green = {0.34, 0.56},
            },
            wire =
            {
                red = {0.66, -0.53},
                green = {-0.13, 0.22},
            }
        },
        circuit_wire_max_distance = 9
    },
    {
        type = "lamp",
        name = "ws-radio-transmitter-2",
        icon = "__wireless-signals__/resources/icons/radio-transmitter-2.png",
        icon_size = 32,
        flags = {"placeable-player", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.75, result = "ws-radio-transmitter-2"},
        max_health = 125,
        corpse = "medium-remnants",
        collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
        selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
        vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
        fast_replaceable_group = "ws-radio-equipment",
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "425kJ"
        },
        energy_usage_per_tick = "850kW",
        light =
        {
            intensity = 0.0,
            size = 0
        },
        picture_off =
        {
            filename = "__wireless-signals__/resources/entity/radio-transmitter-2.png",
            priority = "high",
            width = 262,
            height = 228,
            frame_count = 1,
            axially_symmetrical = false,
            direction_count = 1,
            shift = {2.97, -2.19},
        },
        picture_on =
        {
            filename = "__wireless-signals__/resources/blank.png",
            priority = "high",
            width = 1,
            height = 1,
            frame_count = 1,
            axially_symmetrical = false,
            direction_count = 1,
            shift = {0.0, 0.0},
        },
        circuit_wire_connection_point =
        {
            shadow =
            {
                red = {1.09, -0.19},
                green = {0.34, 0.56},
            },
            wire =
            {
                red = {0.66, -0.53},
                green = {-0.13, 0.22},
            }
        },
        circuit_wire_max_distance = 9
    },
    {
        type = "constant-combinator",
        name = "ws-radio-receiver",
        icon = "__wireless-signals__/resources/icons/radio-receiver.png",
        icon_size = 32,
        flags = {"placeable-player", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.75, result = "ws-radio-receiver"},
        max_health = 100,
        corpse = "medium-remnants",
        collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
        selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
        vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        fast_replaceable_group = "ws-radio-equipment",
        item_slot_count = 45,
        sprites = 
        {
            north = 
            {
                filename = "__wireless-signals__/resources/entity/radio-receiver.png",
                width = 203,
                height = 179,
                frame_count = 1,
                shift = {2.25, -1.91},
            },
            east = 
            {
                filename = "__wireless-signals__/resources/entity/radio-receiver.png",
                width = 203,
                height = 179,
                frame_count = 1,
                shift = {2.25, -1.91},
            },
            south = 
            {
                filename = "__wireless-signals__/resources/entity/radio-receiver.png",
                width = 203,
                height = 179,
                frame_count = 1,
                shift = {2.25, -1.91},
            },
            west = 
            {
                filename = "__wireless-signals__/resources/entity/radio-receiver.png",
                width = 203,
                height = 179,
                frame_count = 1,
                shift = {2.25, -1.91},
            }
        },
        activity_led_sprites =
        {
            north = 
            {
                filename = "__wireless-signals__/resources/blank.png",
                width = 1,
                height = 1,
                frame_count = 1
            },
            east = 
            {
                filename = "__wireless-signals__/resources/blank.png",
                width = 1,
                height = 1,
                frame_count = 1
            },
            south = 
            {
                filename = "__wireless-signals__/resources/blank.png",
                width = 1,
                height = 1,
                frame_count = 1
            },
            west = 
            {
                filename = "__wireless-signals__/resources/blank.png",
                width = 1,
                height = 1,
                frame_count = 1
            }
        },
        activity_led_light =
        {
            intensity = 0,
            size = 0
        },
        activity_led_light_offsets =
        {
            {0, 0},
            {0, 0},
            {0, 0},
            {0, 0}
        },
        circuit_wire_connection_points =
        {
            {
                shadow =
                {
                    red = {-0.09, 0.19},
                    green = {0.81, 0.47},
                },
                wire =
                {
                    red = {-0.41, -0.19},
                    green = {0.37, 0.0},
                }
            },
            {
                shadow =
                {
                    red = {-0.09, 0.19},
                    green = {0.81, 0.47},
                },
                wire =
                {
                    red = {-0.41, -0.19},
                    green = {0.37, 0.0},
                }
            },
            {
                shadow =
                {
                    red = {-0.09, 0.19},
                    green = {0.81, 0.47},
                },
                wire =
                {
                    red = {-0.41, -0.19},
                    green = {0.37, 0.0},
                }
            },
            {
                shadow =
                {
                    red = {-0.09, 0.19},
                    green = {0.81, 0.47},
                },
                wire =
                {
                    red = {-0.41, -0.19},
                    green = {0.37, 0.0},
                }
            }
        },
        circuit_wire_max_distance = 9
    },
    {
        type = "beacon",
        name = "ws-radio-repeater",
        icon = "__wireless-signals__/resources/icons/radio-repeater.png",
        icon_size = 32,
        flags = {"placeable-player", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.75, result = "ws-radio-repeater"},
        max_health = 100,
        corpse = "medium-remnants",
        dying_explosion = "medium-explosion",
        collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
        selection_box = {{-0.9, -0.9}, {0.9, 0.9}},
        vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        fast_replaceable_group = "ws-radio-equipment",
        allowed_effects = {"consumption"},
        base_picture =
        {
            filename = "__wireless-signals__/resources/entity/radio-repeater.png",
            width = 129,
            height = 113,
            shift = {0.91, -0.84}
        },
        animation =
        {
            filename = "__wireless-signals__/resources/blank.png",
            width = 1,
            height = 1,
            line_length = 1,
            frame_count = 1,
            shift = {0, 0},
            animation_speed = 1
        },
        animation_shadow =
        {
            filename = "__wireless-signals__/resources/blank.png",
            width = 1,
            height = 1,
            line_length = 1,
            frame_count = 1,
            shift = {0, 0},
            animation_speed = 1
        },
        radius_visualisation_picture =
        {
            filename = "__wireless-signals__/resources/blank.png",
            width = 1,
            height = 1
        },
        supply_area_distance = 0,
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "500kJ"
        },
        energy_usage = "500kW",
        distribution_effectivity = 0,
        module_specification =
        {
            module_slots = 0,
            module_info_icon_shift = {0, 0},
            module_info_multi_row_initial_height_modifier = 0
        }
    }
}
)