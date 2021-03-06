data:extend(
{
	{
		type = "recipe",
		name = "ws-radio-transmitter-1",
		enabled = false,
		ingredients = 
		{
			{"steel-plate", 20},
			{"iron-stick", 16},
			{"advanced-circuit", 15},
			{"electronic-circuit", 20},
		},
		result = "ws-radio-transmitter-1"
	},
	{
		type = "recipe",
		name = "ws-radio-transmitter-2",
		enabled = false,
		ingredients = 
		{
			{"ws-radio-transmitter-1", 1},
			{"steel-plate", 30},
			{"processing-unit", 15},
			{"effectivity-module", 2},
		},
		result = "ws-radio-transmitter-2"
	},
	{
		type = "recipe",
		name = "ws-radio-receiver",
		enabled = false,
		ingredients = 
		{
			{"steel-plate", 10},
			{"iron-stick", 4},
			{"electronic-circuit", 10},
			{"battery", 10},
		},
		result = "ws-radio-receiver"
	},
	{
		type = "recipe",
		name = "ws-radio-repeater",
		enabled = false,
		ingredients = 
		{
			{"steel-plate", 15},
			{"iron-stick", 20},
			{"processing-unit", 5},
			{"battery", 20},
		},
		result = "ws-radio-repeater"
	}
}
)