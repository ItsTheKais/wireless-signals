for _, force in pairs(game.forces) do
	force.recipes["ws-radio-repeater"].enabled = force.technologies["ws-telemetry-2"].researched
	force.reset_recipes()
end