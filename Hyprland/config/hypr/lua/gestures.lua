hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "up",
	action = function()
		-- hl.exec_cmd("pkill -SIGUSR1 waybar")
		hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
	end,
	disable_inhibit = true,
})

hl.gesture({
	fingers = 3,
	direction = "down",
	mods = "SUPER",
	action = function()
		hl.exec_cmd("hyprlock")
	end,
})

hl.gesture({
	fingers = 4,
	direction = "up",
	action = "cursorZoom",
	zoom_level = 3,
})
