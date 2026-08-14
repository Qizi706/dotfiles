-- Hyprland 0.56+ configuration
-- https://wiki.hypr.land/Configuring/Start/

----------------
-- MONITORS ----
----------------

-- Official portable fallback: every unconfigured output uses its preferred mode.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

---------------------
-- CORE SETTINGS ----
---------------------

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},

	input = {
		kb_layout = "us",
		follow_mouse = 2,
		sensitivity = 0,
		accel_profile = "flat",
		repeat_delay = 250,
		repeat_rate = 50,
	},

	cursor = {
		inactive_timeout = 0,
		enable_hyprcursor = true,
		hide_on_key_press = false,
		no_warps = true,
	},

	general = {
		gaps_in = 5,
		gaps_out = 15,
		border_size = 0,
		col = {
			active_border = {
				colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
				angle = 45,
			},
			inactive_border = "rgba(595959aa)",
		},
		layout = "dwindle",
	},

	decoration = {
		rounding = 12,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 30,
			render_power = 5,
			offset = { 0, 5 },
			color = "rgba(00000070)",
		},
	},

	animations = {
		enabled = true,
	},

	master = {
		mfact = 0.5,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})

hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "default" })

-----------------------------
-- ENVIRONMENT VARIABLES ----
-----------------------------

-- Session-wide variables live in ~/.config/shell/profile.fish (or profile.sh)
-- so systemd services and both compositors inherit the same values.

-----------------
-- AUTOSTART ----
-----------------

hl.on("hyprland.start", function()
	local commands = {
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE && systemctl --user start hyprland-session.target",
		[[echo 'Xft.dpi:103' | xrdb -merge]],
		"wl-paste --watch cliphist store",
		"foot --server -c $XDG_CONFIG_HOME/foot/foot.ini",
	}

	for _, command in ipairs(commands) do
		hl.exec_cmd(command)
	end
end)

hl.on("hyprland.shutdown", function()
	os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
end)

----------------------
-- WINDOW RULES ------
----------------------

local function window_rule(class, effects)
	effects.match = { class = class }
	hl.window_rule(effects)
end

window_rule([=[org\.wezfurlong\.wezterm]=], { float = false, border_size = 0 })
window_rule([=[org\.gnome\..*]=], { rounding = 12, border_size = 0 })

for _, class in ipairs({
	"gnome-control-center",
	"pavucontrol",
	"nm-connection-editor",
}) do
	window_rule(class, { float = false })
end

for _, class in ipairs({
	"gnome-calculator",
	"galculator",
	"blueman-manager",
	[=[org\.gnome\.Nautilus]=],
	"steam",
	"xdg-desktop-portal",
	"discord",
	"wechat",
	"QQ",
	"zoom",
}) do
	window_rule(class, { float = true })
end

hl.window_rule({ match = { title = "Open Files" }, float = true })
hl.window_rule({
	match = { class = "firefox", title = "Picture-in-Picture" },
	float = true,
})

for _, class in ipairs({
	"ghostty",
	"zen",
	[=[com\.mitchellh\.ghostty]=],
	"kitty",
	"wechat",
}) do
	window_rule(class, { border_size = 0 })
end

window_rule("wechat", { no_blur = true })
window_rule("QQ", { no_blur = true })
hl.window_rule({ match = { float = false, focus = false }, opacity = "0.9 0.9" })
hl.layer_rule({ match = { namespace = "quickshell" }, no_anim = true })

window_rule("QQ", { workspace = "4" })
window_rule("wechat", { workspace = "4" })
window_rule("discord", { workspace = "4" })
window_rule([=[com\.follow\.clash]=], { workspace = "9" })

window_rule("pot", {
	float = true,
	move = { "cursor_x", "cursor_y" },
})

--------------------
-- KEYBINDINGS -----
--------------------

local mod = "SUPER"

local function bind(keys, dispatcher, options)
	return hl.bind(keys, dispatcher, options)
end

-- Application launchers
bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty +new-window"))
bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("dms restart"))
bind(mod .. " + D", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
bind(mod .. " + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
bind(mod .. " + M", hl.dsp.exec_cmd("dms ipc call processlist toggle"))
bind(mod .. " + comma", hl.dsp.exec_cmd("dms ipc call settings toggle"))
bind(mod .. " + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("dms ipc call notepad toggle"))
bind(mod .. " + Y", hl.dsp.exec_cmd("dms ipc call dankdash wallpaper"))
bind(mod .. " + E", hl.dsp.exec_cmd("nautilus"))

-- Security
bind(mod .. " + CTRL + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
bind(mod .. " + SHIFT + E", hl.dsp.exit())
bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("dms ipc call processlist toggle"))

-- Audio
bind(mod .. " + CTRL + equal", hl.dsp.exec_cmd("dms ipc call audio increment 3"), {
	locked = true,
	repeating = true,
})
bind(mod .. " + CTRL + minus", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), {
	locked = true,
	repeating = true,
})
bind(mod .. " + CTRL + M", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true })

-- Window management
bind(mod .. " + Q", hl.dsp.window.close())
bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(mod .. " + space", hl.dsp.window.float())
bind(mod .. " + W", hl.dsp.group.toggle())
bind(mod .. " + P", hl.dsp.window.pseudo())

for _, direction in ipairs({
	{ key = "left", value = "l" },
	{ key = "down", value = "d" },
	{ key = "up", value = "u" },
	{ key = "right", value = "r" },
		{ key = "H", value = "l" },
		{ key = "J", value = "d" },
		{ key = "K", value = "u" },
	}) do
	bind(mod .. " + " .. direction.key, hl.dsp.focus({ direction = direction.value }))
	bind(mod .. " + SHIFT + " .. direction.key, hl.dsp.window.move({ direction = direction.value }))
end

bind(mod .. " + Tab", hl.dsp.window.cycle_next({ prev = true }))
bind(mod .. " + SHIFT + Tab", hl.dsp.window.cycle_next())

bind(mod .. " + Home", function()
	local workspace = hl.get_active_workspace()
	local windows = workspace and workspace:get_windows() or {}
	if #windows > 0 then
		hl.dispatch(hl.dsp.focus({ window = windows[1] }))
	end
end)
bind(mod .. " + End", function()
	local workspace = hl.get_active_workspace()
	local windows = workspace and workspace:get_windows() or {}
	if #windows > 0 then
		hl.dispatch(hl.dsp.focus({ window = windows[#windows] }))
	end
end)

for _, direction in ipairs({
	{ key = "left", value = "l" },
	{ key = "right", value = "r" },
		{ key = "H", value = "l" },
		{ key = "J", value = "d" },
		{ key = "K", value = "u" },
	}) do
	bind(mod .. " + CTRL + " .. direction.key, hl.dsp.focus({ monitor = direction.value }))
end

for _, direction in ipairs({
	{ key = "left", value = "l" },
	{ key = "down", value = "d" },
	{ key = "up", value = "u" },
	{ key = "right", value = "r" },
	{ key = "H", value = "l" },
	{ key = "J", value = "d" },
	{ key = "K", value = "u" },
	{ key = "L", value = "r" },
}) do
	bind(mod .. " + SHIFT + CTRL + " .. direction.key, hl.dsp.window.move({ monitor = direction.value }))
end

-- Workspace navigation
for _, key in ipairs({ "Page_Down", "U" }) do
	bind(mod .. " + " .. key, hl.dsp.focus({ workspace = "e+1" }))
	bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = "e+1", follow = true }))
end
for _, key in ipairs({ "Page_Up", "I" }) do
	bind(mod .. " + " .. key, hl.dsp.focus({ workspace = "e-1" }))
	bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = "e-1", follow = true }))
end
for _, key in ipairs({ "down", "U" }) do
	bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = "e+1", follow = true }))
end
for _, key in ipairs({ "up", "I" }) do
	bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = "e-1", follow = true }))
end

bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = true }))

bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind(mod .. " + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1", follow = true }))
bind(mod .. " + CTRL + mouse_up", hl.dsp.window.move({ workspace = "e-1", follow = true }))

for workspace = 1, 9 do
	local key = tostring(workspace)
	bind(mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
	bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = true }))
end

-- Layout and sizing
bind(mod .. " + bracketleft", hl.dsp.layout("preselect l"))
bind(mod .. " + bracketright", hl.dsp.layout("preselect r"))
bind(mod .. " + R", hl.dsp.layout("togglesplit"))
bind(mod .. " + CTRL + F", function()
	local window = hl.get_active_window()
	local monitor = hl.get_active_monitor()
	if window and monitor then
		hl.dispatch(hl.dsp.window.resize({
			x = monitor.width,
			y = window.size.y,
			relative = false,
		}))
	end
end)

bind(mod .. " + mouse:272", hl.dsp.window.drag(), {
	mouse = true,
	description = "Move window",
})
bind(mod .. " + mouse:273", hl.dsp.window.resize(), {
	mouse = true,
	description = "Resize window",
})

bind(mod .. " + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), {
	description = "Expand window left",
})
bind(mod .. " + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), {
	description = "Shrink window left",
})

local function resize_by_percent(x_percent, y_percent)
	return function()
		local window = hl.get_active_window()
		if window then
			hl.dispatch(hl.dsp.window.resize({
				x = window.size.x * x_percent,
				y = window.size.y * y_percent,
				relative = true,
			}))
		end
	end
end

bind(mod .. " + minus", resize_by_percent(-0.1, 0), { repeating = true })
bind(mod .. " + equal", resize_by_percent(0.1, 0), { repeating = true })
bind(mod .. " + SHIFT + minus", resize_by_percent(0, -0.1), { repeating = true })
bind(mod .. " + SHIFT + equal", resize_by_percent(0, 0.1), { repeating = true })

-- Screenshots
bind("ALT + S", hl.dsp.exec_cmd("grimblast copy area"))
bind("CTRL + XF86Launch1", hl.dsp.exec_cmd("grimblast copy screen"))
bind("ALT + XF86Launch1", hl.dsp.exec_cmd("grimblast copy active"))
bind("ALT + SHIFT + S", hl.dsp.exec_cmd([[dms screenshot --dir "$HOME/Pictures/Screenshots"]]))
bind("CTRL + Print", hl.dsp.exec_cmd("grimblast copy screen"))
bind("ALT + Print", hl.dsp.exec_cmd("grimblast copy active"))

-- DPMS
bind(mod .. " + SHIFT + P", function()
	hl.timer(function()
		hl.dispatch(hl.dsp.dpms({ action = "off" }))
	end, { timeout = 500, type = "oneshot" })
end)
bind(mod .. " + SHIFT + O", hl.dsp.dpms({ action = "on" }))

-----------------
-- ALT + TAB ----
-----------------

alt_tab_down_bind = bind("ALT + TAB", hl.dsp.exec_cmd("$XDG_CONFIG_HOME/hypr/scripts/alttab/enable.sh down"))
alt_tab_up_bind = bind("ALT + SHIFT + TAB", hl.dsp.exec_cmd("$XDG_CONFIG_HOME/hypr/scripts/alttab/enable.sh up"))

hl.define_submap("alttab", function()
	bind("ALT + Tab", hl.dsp.send_shortcut({ mods = "", key = "tab", window = "class:alttab" }))
	bind("ALT + SHIFT + Tab", hl.dsp.send_shortcut({ mods = "SHIFT", key = "tab", window = "class:alttab" }))

	local finish = "$XDG_CONFIG_HOME/hypr/scripts/alttab/disable.sh"
	bind(
		"ALT + ALT_L",
		hl.dsp.exec_cmd(
			finish
				.. [[; hyprctl -q dispatch 'hl.dsp.send_shortcut({ mods = "", key = "return", window = "class:alttab" })']]
		),
		{
			release = true,
			transparent = true,
		}
	)
	bind(
		"ALT + SHIFT + ALT_L",
		hl.dsp.exec_cmd(
			finish
				.. [[; hyprctl -q dispatch 'hl.dsp.send_shortcut({ mods = "", key = "return", window = "class:alttab" })']]
		),
		{
			release = true,
			transparent = true,
		}
	)
	bind(
		"ALT + Return",
		hl.dsp.exec_cmd(
			finish
				.. [[; hyprctl -q dispatch 'hl.dsp.send_shortcut({ mods = "", key = "return", window = "class:alttab" })']]
		)
	)
	bind(
		"ALT + SHIFT + Return",
		hl.dsp.exec_cmd(
			finish
				.. [[; hyprctl -q dispatch 'hl.dsp.send_shortcut({ mods = "", key = "return", window = "class:alttab" })']]
		)
	)
	bind(
		"ALT + escape",
		hl.dsp.exec_cmd(
			finish
				.. [[; hyprctl -q dispatch 'hl.dsp.send_shortcut({ mods = "", key = "escape", window = "class:alttab" })']]
		)
	)
	bind(
		"ALT + SHIFT + escape",
		hl.dsp.exec_cmd(
			finish
				.. [[; hyprctl -q dispatch 'hl.dsp.send_shortcut({ mods = "", key = "escape", window = "class:alttab" })']]
		)
	)
end)

hl.workspace_rule({
	workspace = "special:alttab",
	gaps_out = 0,
	gaps_in = 0,
	border_size = 0,
})
window_rule("alttab", {
	no_anim = true,
	stay_focused = true,
	workspace = "special:alttab",
	border_size = 0,
})

-------------------
-- TRANSLATION ----
-------------------

bind(
	mod .. " + C",
	hl.dsp.exec_cmd([[
    mkdir -p "$XDG_CACHE_HOME/com.pot-app.desktop" &&
    grim -g "$(slurp)" "$XDG_CACHE_HOME/com.pot-app.desktop/pot_screenshot_cut.png" &&
    curl --fail --silent --show-error "127.0.0.1:60828/ocr_translate?screenshot=false"
]])
)

-- DMS-generated modules are local runtime state and may be absent on a new host.
local function require_optional(module)
	local ok, message = pcall(require, module)
	if not ok and not tostring(message):find("not found", 1, true) then
		error(message)
	end
end

for _, module in ipairs({ "dms.cursor", "dms.outputs", "dms.layout" }) do
	require_optional(module)
end

-- Load host-specific monitor and hardware overrides last.
require_optional("local.machine")
