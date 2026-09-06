--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "zen-browser-on-w1",
    match = { class = "^(zen)$" },
    workspace = "1"
})

hl.window_rule({
    name = "brave-origin-browser-on-w1",
    match = { class = "^(brave-origin)$" },
    workspace = "1"
})

hl.workspace_rule({ workspace = "10", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1" })
