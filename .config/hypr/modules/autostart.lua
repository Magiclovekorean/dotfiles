-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
   hl.exec_cmd("waybar")
   hl.exec_cmd("hypridle")
   hl.exec_cmd("hyprpaper")
   hl.exec_cmd("xhost +SI:localuser:root")
   hl.exec_cmd("wl-paste --type text --watch cliphist store")
   hl.exec_cmd("wl-paste --type image --watch cliphist store")
   -- clear clipboard history
   hl.exec_cmd("cliphist wipe")
   hl.exec_cmd("batsignal")
 end)

