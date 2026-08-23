---------------------
---- MY PROGRAMS ----
---------------------

--apps
local terminal    = "ghostty"
local fileManager = "dolphin"
local browser = "zen-browser"
local brave = "brave-origin"
local music = "spotify-launcher"
local notion = brave .. " --app=https://notion.so"

-- airplane mode
local airplane_mode = "toggle-airplane"

-- rofi
local launcher = "rofi -show drun -show-icons"
local runner = "rofi -show run"
local calculator = "rofi -show calc -modi calc -no-show-match -no-sort"
local emojiSearch = "rofi -modi emoji -show emoji"
local clipboard_history = "cliphist list | rofi -dmenu | cliphist decode | wl-copy"

-- color picker
local color_picker = "hyprpicker | wl-copy"

-- screenshots
local screenshot = 'f="$HOME/Pictures/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"; grim -g "$(slurp)" "$f" && wl-copy < "$f"'
local screenshot_and_edit = 'grim -g "$(slurp)" - | satty --filename -'

-- Change keyboard layout
local kb_toggle = "hyprctl switchxkblayout all next && notify-send 'Keyboard layout switched'"

local screenshot_ocr = os.getenv("HOME") .. "/.config/hypr/scripts/ocr.sh"

-- wallpaper and asthetics
local next_wallpaper = "wpaperctl next"
local previous_wallpaper = "wpaperctl previous"
local toggle_cycling_wallpaper = "wpaperctl toggle-pause"
-- toggle blur
local blur_enabled = true
local toggle_blur = function ()
    blur_enabled = not blur_enabled

    hl.config({
        decoration =  {
            blur = {
                enabled = blur_enabled
            }
        }
    })
end

-- power options
local shutdown = "systemctl poweroff"
local reboot = "systemctl reboot"
local lock = "hyprlock"
local logout = "uwsm stop"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local secondMod = "SUPER + SHIFT"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- Disable eDP-1 monitor when laptop's lid is closed
hl.bind(
    "switch:on:Lid Switch",
    function()
        hl.monitor({
            output = "eDP-1",
            disabled = true,
        })
    end,
    { locked = true }
)

hl.bind(
    "switch:off:Lid Switch",
    function()
        hl.monitor({
            output = "eDP-1",
            disabled = false,
        })
    end,
    { locked = true }
)

-- apps

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(music))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notion))


-- rofi
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(launcher))
hl.bind(secondMod .. " + Space", hl.dsp.exec_cmd(runner))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(calculator))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(emojiSearch))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboard_history))

-- color picker
hl.bind(secondMod .. " + C", hl.dsp.exec_cmd(color_picker))

-- screenshots
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(screenshot))
hl.bind(secondMod .. " + S", hl.dsp.exec_cmd(screenshot_and_edit))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(screenshot_ocr))

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(kb_toggle))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(secondMod .. " + Q", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Move focus with mainMod + hljk keys
hl.bind(mainMod .. " + h",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j",  hl.dsp.focus({ direction = "down" }))

hl.bind(secondMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(secondMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind(secondMod .. " + h",  hl.dsp.window.move({ direction = "left" }))
hl.bind(secondMod .. " + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(secondMod .. " + k",    hl.dsp.window.move({ direction = "up" }))
hl.bind(secondMod .. " + j",  hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(secondMod .. " + " .. key,     hl.dsp.window.move({ workspace = i }))
end


-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind(mainMod .. " + F3",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind(mainMod .. " + F2",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd(airplane_mode))

-- Resize mode (mainMod + R to enter, Escape to exit)
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })

    hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- Wallpaper mode (mainMod + W to enter, Escape to exit)
hl.bind(mainMod .. " + W", hl.dsp.submap("wallpaper"))

hl.define_submap("wallpaper", function()
    hl.bind("l", hl.dsp.exec_cmd(next_wallpaper))
    hl.bind("h", hl.dsp.exec_cmd(previous_wallpaper))
    hl.bind("Space", hl.dsp.exec_cmd(toggle_cycling_wallpaper))
    hl.bind("b", toggle_blur)

    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- System mode (secondMod + escape to enter, Escape to exit)
hl.bind(mainMod .. " + escape", hl.dsp.submap("system"))

hl.define_submap("system", function()
    hl.bind("s", hl.dsp.exec_cmd(shutdown))
    hl.bind("r", hl.dsp.exec_cmd(reboot))
    hl.bind("l", hl.dsp.exec_cmd(lock))
    hl.bind("SHIFT + L", hl.dsp.exec_cmd(logout))

    hl.bind("escape", hl.dsp.submap("reset"))
end)

