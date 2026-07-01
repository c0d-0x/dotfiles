-- FLOAT RULES
local float_apps = {
	"^(.*[Aa]mberol.*)$",
	"^(.*[Bb]lueman-manager.*)$",
	"^(.*[Cc]heese.*)$",
	"^(.*[Dd]iscord.*)$",
	"^(.*[Ff]lameshot.*)$",
	"^(.*[Gg]alculator.*)$",
	"^(.*[Mm]ousepad.*)$",
	"^(.*[Nn]m-connection-editor.*)$",
	"^(.*[Pp]acket[Tt]racer.*)$",
	"^(.*[Pp]rotonvpn-app.*)$",
	"^(.*[Qq][Bb]ittorrent.*)$",
	"^(.*[Ss]ystem[Mm]onitor.*)$",
	"^(.*[Tt]elegram.*)$",
	"^(.*[Tt]hunar.*)$",
	"^(.*[Vv]iewnior.*)$",
	"^(.*[Ww]hatsdesk.*)$",
	"^(.*[Ww]ireshark.*)$",
	"^(.*[Zz]oom.*)$",
	"^(.*[Ii]mv.*)$",
}

for _, reg in ipairs(float_apps) do
	hl.window_rule({
		match = { class = reg },
		float = true,
	})
end

--  NO BLUR + OPAQUE
local no_blur = {
	"^(.*[Aa]mberol.*)$",
	"^(.*[Bb]rave.*)$",
	"^(.*[Cc]romium.*)$",
	"^(.*[Zz]en.*)$",
	"^(.*[Jj]etbrains.*)$",
	"^(.*[Xx]fce4-terminal.*)$",
	"^(.*[Pp]acket[Tt]racer.*)$",
}

for _, reg in pairs(no_blur) do
	hl.window_rule({
		match = { class = reg },
		no_blur = true,
		opaque = true,
	})
end

-- ALL FLOATING WINDOWS: CENTER + 50% SIZE
hl.window_rule({
	match = { float = true },
	size = "<(monitor_w*0.5) <(monitor_h*0.5)",
	center = true,
})

-- NM-APPLET
hl.window_rule({
	match = { class = "^(.*[Nn]m.*)$" },
	float = true,
	pin = true,
})

-- SUPPRESS MAXIMIZE
hl.window_rule({
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- XWAYLAND FOCUS FIX
hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- SCRATCHPAD WORKSPACE
hl.workspace_rule({
	workspace = "special:magic",
	gaps_out = 50,
	gaps_in = 20,
})

-- LAYER RULES
hl.layer_rule({
	match = { namespace = "waybar" },
	blur = true,
	ignore_alpha = 0,
	order = -2,
})

hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0.5,
	no_anim = true,
})
