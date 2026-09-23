local mainMod = "SUPER"
local secondMod = "ALT"

local scripts = "~/.config/hypr/scripts"
local fileManager = "thunar"
local menu = "rofi run -show drun"
local power_menu = "~/.config/rofi/powermenu/powermenu.sh"
local clip_style = "~/.config/rofi/clipboard.rasi"
local set_wallpaper = scripts .. "/chwall.sh"
local restart_waybar = scripts .. "/restart_waybar.sh"
local show_clipboard = "cliphist list | rofi -theme " .. clip_style .. " -dmenu | cliphist decode | wl-copy"
local show_emoji = "rofimoji --skin-tone light --action clipboard  --no-frecency"
local terminal = "alacritty"
local terminal2 = "kitty"

-- APP LAUNCHERS
local ts_state = true
local blue_state = true

hl.bind(mainMod .. " + B", function()
	local opt = "on"
	if blue_state then
		opt = "off"
	end

	blue_state = not blue_state
	hl.dispatch(hl.dsp.exec_cmd("bluetoothctl power " .. opt))
	if blue_state then
		hl.notification.create({ text = "bluetooth on", duration = 2000, icon = "ok" })
	else
		hl.notification.create({ text = "bluetooth off", duration = 2000, icon = "ok" })
	end
end)

hl.bind(mainMod .. " + CTRL + T", function()
	hl.device({
		name = "elan-touchscreen",
		enabled = ts_state,
	})

	if ts_state then
		hl.notification.create({ text = "Touchscreen on", duration = 2000, icon = "ok" })
	else
		hl.notification.create({ text = "Touchscreen off", duration = 2000, icon = "ok" })
	end
	ts_state = not ts_state
end)

hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd(power_menu))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(show_clipboard))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(show_emoji))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(set_wallpaper))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal2))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(restart_waybar))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float())

-- FOCUS
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- RESIZE
hl.bind(mainMod .. " +  CTRL + H", hl.dsp.window.resize({ x = -5, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " +  CTRL + L", hl.dsp.window.resize({ x = 5, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " +  CTRL + K", hl.dsp.window.resize({ x = 0, y = 5, relative = true }), { repeating = true })
hl.bind(mainMod .. " +  CTRL + J", hl.dsp.window.resize({ x = 0, y = -5, relative = true }), { repeating = true })

-- MOVE WINDOWS
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.center())

-- WORKSPACES
for i = 1, 9 do
	local key = i
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "m+1" }))

-- SCRATCHPAD
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + X", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- MOUSE
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- LMB
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- RMB

-- VOLUME / BRIGHTNESS
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)

hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)

hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)

hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- MEDIA (REQUIRES PLAYERCTL)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- SCREENSHOTS
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind("SUPER + Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

-- Tiled and Floating
hl.bind("SUPER + space", function()
	hl.dispatch(hl.dsp.window.cycle_next({
		floating = not hl.get_active_window().floating,
	}))
end, { description = "Switch focus between tiled and floating windows" })

-- GROUPS

local map = function(key, action, description)
	hl.bind(key, function()
		hl.dispatch(action)
		hl.dispatch(hl.dsp.submap("reset"))
	end, { description = description })
end

hl.bind(mainMod .. " + SPACE", hl.dsp.submap("group_management"), { description = "Enter a group management submap" })
hl.bind(secondMod .. " + SHIFT + tab", hl.dsp.group.prev())
hl.bind(secondMod .. " + tab", hl.dsp.group.next())

hl.define_submap("group_management", function()
	map("g", hl.dsp.group.toggle(), "Toggle window group")

	map("h", hl.dsp.window.move({ into_group = "l" }), "Move window into a group on the left")
	map("j", hl.dsp.window.move({ into_group = "d" }), "Move window into a group on the bottom")
	map("k", hl.dsp.window.move({ into_group = "u" }), "Move window into a group on the top")
	map("l", hl.dsp.window.move({ into_group = "r" }), "Move window into a group on the right")

	map("SPACE", hl.dsp.window.move({ out_of_group = true }), "Move window out of group")

	map("n", hl.dsp.group.next(), "Next window in group")
	map("p", hl.dsp.group.prev(), "Previous window in group")

	map("f", hl.dsp.group.move_window(), "Move window forward in the group order")
	map("b", hl.dsp.group.move_window({ forward = false }), "Move window backward in the group order")

	map("t", hl.dsp.group.lock_active(), "Toggle group lock")

	for i = 1, 10 do
		map(tostring(i % 10), hl.dsp.group.active({ index = i }), "Focus window " .. i .. " in a group")
	end

	hl.bind("escape", hl.dsp.submap("reset"), { description = "Quit submap" })
end)
