local start_clipboard = "wl-paste --watch cliphist store"
local start_xdgportal = "~/.config/hypr/scripts/xdg-portal.sh"
local waybarctl = "~/.config/hypr/scripts/waybarctl.sh"

-- MONITORS
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = "1",
})

hl.monitor({
	output = "",
	mode = "highres",
	position = "auto",
	scale = "auto",
	mirror = "eDP-1",
})

-- AUTOSTART
hl.on("hyprland.start", function()
	hl.exec_cmd(start_xdgportal)
	hl.exec_cmd(start_clipboard)
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("bluetoothctl power off")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd(waybarctl)
end)

-- ENVIRONMENT VARIABLES
hl.env("LIBVA_DRIVER_NAME", "iHD")
hl.env("VDPAU_DRIVER", "va_gl")
hl.env("WLR_DRM_NO_ATOMIC", "1")
hl.env("WLR_RENDERER", "opengl")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("OBS_USE_EGL", "1")
hl.env("HYPRLAND_NO_RT", "1")
hl.env("HYPRLAND_NO_SD_NOTIFY", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- PERMISSIONS
hl.permission({ binary = "/usr/(bin|local/bin)/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
hl.permission({ binary = "/usr/(bin|local/bin)/hyprlock", type = "screencopy", mode = "allow" })

-- COLOURS
COLOURS = dofile(os.getenv("HOME") .. "/.cache/hellwal/colours.lua")

-- LOAD MODULES FROM
require("lua.config")
require("lua.devices")
require("lua.gestures")
require("lua.binds")
require("lua.rules")
