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
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })

-- MOVE WINDOWS
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.center())

-- WORKSPACES
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "m+1" }))

-- GROUPS
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(secondMod .. " + tab", hl.dsp.group.next())
hl.bind(secondMod .. " + L", hl.dsp.group.lock())
hl.bind(secondMod .. " + SHIFT + tab", hl.dsp.group.prev())
hl.bind(secondMod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ into_group = "right" }))

-- SCRATCHPAD
hl.bind(mainMod .. " + SHIFT + X", function()
	-- hl.exec_cmd("pkill -SIGUSR1 waybar")
	hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end)
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
