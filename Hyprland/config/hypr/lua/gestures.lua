hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "up",
	disable_inhibit = true,
	action = function()
		hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
	end,
})

hl.gesture({
	fingers = 3,
	direction = "down",
	mods = "SUPER",
	action = function()
		hl.dispatch(hl.dsp.exec_cmd("hyprlock"))
	end,
})

hl.gesture({
	fingers = 4,
	direction = "up",
	action = "cursorZoom",
	zoom_level = 3,
})
