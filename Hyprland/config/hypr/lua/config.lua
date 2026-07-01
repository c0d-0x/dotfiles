local c = COLOURS

hl.config({
	ecosystem = {
		enforce_permissions = true,
		no_donation_nag = true,
	},

	xwayland = {
		force_zero_scaling = true,
	},

	general = {
		gaps_in = 3,
		gaps_out = 3,
		float_gaps = 5,

		border_size = 1,
		["col.active_border"] = c.colour5,
		["col.inactive_border"] = c.colour5,
		resize_on_border = false,
		layout = "dwindle",
		no_focus_fallback = false,
		allow_tearing = true,

		snap = {
			enabled = true,
			window_gap = 4,
			monitor_gap = 5,
			respect_gaps = true,
		},
	},

	group = {
		["col.border_active"] = c.colour5,
		["col.border_inactive"] = c.colour5,

		groupbar = {
			gaps_out = 4,
			gaps_in = 16,
			indicator_height = 4,
			["col.active"] = c.colour5,
			["col.inactive"] = c.colour2,

			render_titles = false,
			keep_upper_gap = false,
		},
	},

	decoration = {
		rounding = 5,
		rounding_power = 3,

		active_opacity = 1.0,
		inactive_opacity = 0.8,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			size = 7,
			noise = 0.025,
			passes = 1,
			special = true,
			vibrancy = 0.3,
			vibrancy_darkness = 0.25,
			new_optimizations = true,

			brightness = 1,
			contrast = 0.89,
			popups = false,
			popups_ignorealpha = 0.6,
			input_methods = true,
			input_methods_ignorealpha = 0.8,
		},

		-- glow = {
		-- 	enabled = true,
		-- 	range = 5,
		-- 	color = c.colour5,
		-- },
	},

	animations = {
		enabled = false,
	},

	dwindle = {
		preserve_split = true,
		smart_split = false,
		smart_resizing = false,
	},

	master = {
		new_status = "master",
	},

	misc = {
		font_family = "CaskaydiaMono Nerd Font",
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		allow_session_lock_restore = true,
		disable_splash_rendering = true,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		disable_autoreload = false,
		enable_swallow = false,

		vrr = 1,
	},

	debug = {
		vfr = true,
	},

	input = {
		kb_layout = "us",

		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
			disable_while_typing = true,
			tap_to_click = true,
			drag_lock = false,
		},
	},

	cursor = {
		zoom_factor = 1,
		zoom_rigid = false,
		zoom_disable_aa = true,
		hotspot_padding = 1,
	},
})
