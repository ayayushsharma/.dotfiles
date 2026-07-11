-- hyprland.lua
-- See https://wiki.hypr.land/Configuring/Start/

---------------------
---- MY PROGRAMS ----
---------------------
local terminal = "kitty"
local fileManager = "dolphin"
local menu = "rofi -show drun -i"
local notification = "swaync-client -t -sw"
local mainMod = "SUPER"

------------------
---- MONITORS ----
------------------
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("wpaperd -d")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("swaync")
    hl.exec_cmd("blueman-applet")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 0,
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
        gaps_workspaces = 20,
    },
    decoration = {
        rounding = 0,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            vibrancy = 0.1696,
            xray = true,
            new_optimizations = true,
            noise = 0.0117,
            contrast = 0.8916,
            brightness = 0.8172,
        },
    },
    animations = {
        enabled = true,
    },
})

-----------------
---- CURVES -----
-----------------
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-------------------
---- ANIMATIONS ----
-------------------
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.1,
    bezier = "easeOutQuint",
    style = "popin 87%",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "linear",
    style = "popin 87%",
})
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade",
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1.5,
    bezier = "linear",
    style = "fade",
})
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({
    leaf = "workspacesIn",
    enabled = false,
    speed = 0.5,
    bezier = "almostLinear",
    style = "fade",
})
hl.animation({
    leaf = "workspacesOut",
    enabled = false,
    speed = 0.5,
    bezier = "almostLinear",
    style = "fade",
})

-----------------
---- LAYOUTS ----
-----------------
hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
})

----------------
----  MISC  ----
----------------
hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        close_special_on_empty = false,
    },
})

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            clickfinger_behavior = true,
        },
    },
})

----------------
---- GESTURES --
----------------
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-----------------
---- DEVICES ----
-----------------
hl.device({
    name = "razer-razer-deathadder-v2-x-hyperspeed",
    sensitivity = -1,
})

hl.device({
    name = "elan1203:00-04f3:307a-touchpad",
    sensitivity = 0.3,
})

---------------------
---- KEYBINDINGS ----
---------------------
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(
    mainMod .. " + W",
    hl.dsp.exec_cmd("google-chrome-stable --enable-features=TouchpadOverscrollHistoryNavigation")
)
hl.bind(mainMod .. " + L", hl.dsp.exit())

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notification))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("spotify"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + Grave", hl.dsp.exec_cmd("kitten quick-access-terminal"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pin())

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + s", hl.dsp.window.pin())
hl.bind(mainMod .. " + SHIFT + f", hl.dsp.window.fullscreen())

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + CTRL + mouse:272", hl.dsp.window.resize(), { mouse = true })

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
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl s 10%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl s 10%-"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(
    "Print",
    hl.dsp.exec_cmd(
        'grim -g "$(slurp)" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of the region taken" -t 1000'
    )
)
hl.bind(
    "SHIFT + Print",
    hl.dsp.exec_cmd(
        'grim - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of whole screen taken" -t 1000'
    )
)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
hl.workspace_rule({ workspace = "r[1-5]", persistent = true })

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
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

hl.window_rule({
    name = "firefox-pip",
    match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
    float = true,
    pin = true,
    size = "40% 40%",
    move = "60%-w-10 60%-w-10",
})

hl.window_rule({
    name = "generic-pip",
    match = { title = "^(Picture in picture)$" },
    float = true,
    pin = true,
    size = "30% 30%",
    move = "70% 100%",
})

hl.window_rule({
    name = "kitty-opacity",
    match = { class = "^(kitty)$" },
    opacity = "1 1",
})

hl.window_rule({
    name = "picture-in-picture-fullscreen-fix",
    match = { title = "^(Picture-in-Picture)$" },
    suppress_event = "fullscreen fullscreenoutput maximize",
})

---------------------------
---- LAYERING RULES ----
---------------------------
hl.layer_rule({
    name = "rofi_layering",
    match = { namespace = "^(rofi)$" },
    blur = true,
    xray = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    name = "waybar_layering",
    match = { namespace = "^(waybar)$" },
    blur = true,
    xray = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    name = "swaync_layering",
    match = { namespace = "^(swaync-control-center)$" },
    blur = true,
    ignore_alpha = 0,
})
