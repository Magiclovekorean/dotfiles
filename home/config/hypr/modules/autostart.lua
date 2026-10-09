-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME PATH XDG_DATA_DIRS; systemctl --user start graphical-session.target")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    -- clear clipboard history
    hl.exec_cmd("cliphist wipe")
    hl.exec_cmd("batsignal")
end)
