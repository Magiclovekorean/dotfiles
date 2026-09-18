--------------------------
---- XWAYLAND  --------
--------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/XWayland/

-- Fractional scaling (eDP-1 = 1.5) upscales XWayland apps (e.g. DaVinci Resolve),
-- which are X11-only, making their text blurry. Render them unzoomed instead.
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})